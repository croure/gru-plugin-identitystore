/*
 * Copyright (c) 2002-2024, City of Paris
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice
 *     and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice
 *     and the following disclaimer in the documentation and/or other materials
 *     provided with the distribution.
 *
 *  3. Neither the name of 'Mairie de Paris' nor 'Lutece' nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * License 1.0
 */
package fr.paris.lutece.plugins.identitystore.service.identity;

import fr.paris.lutece.plugins.identitystore.business.application.ClientApplication;
import fr.paris.lutece.plugins.identitystore.business.attribute.AttributeKey;
import fr.paris.lutece.plugins.identitystore.business.contract.ServiceContract;
import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.ExcludedIdentities;
import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentity;
import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentityHome;
import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAccountHistory;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAttribute;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityHome;
import fr.paris.lutece.plugins.identitystore.business.rules.duplicate.DuplicateRule;
import fr.paris.lutece.plugins.identitystore.cache.IdentityDtoCache;
import fr.paris.lutece.plugins.identitystore.service.attribute.IdentityAttributeService;
import fr.paris.lutece.plugins.identitystore.service.contract.AttributeCertificationDefinitionService;
import fr.paris.lutece.plugins.identitystore.service.listeners.IdentityStoreNotifyListenerService;
import fr.paris.lutece.plugins.identitystore.service.search.ISearchIdentityService;
import fr.paris.lutece.plugins.identitystore.service.user.InternalUserService;
import fr.paris.lutece.plugins.identitystore.utils.Batch;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.DtoConverter;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeChangeStatus;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeChangeStatusType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeStatus;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AuthorType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.IdentityDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.Page;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.QualityDefinition;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.RequestAuthor;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.ResponseStatusType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.crud.IdentityChangeRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.crud.UpdatedIdentityDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.AttributeChangeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChange;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChangeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.merge.IdentityMergeRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.IdentitySearchRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.QualifiedIdentitySearchResult;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.SearchAttribute;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.UpdatedIdentitySearchRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.util.Constants;
import fr.paris.lutece.plugins.identitystore.web.exception.IdentityStoreException;
import fr.paris.lutece.plugins.identitystore.web.exception.RequestFormatException;
import fr.paris.lutece.plugins.identitystore.web.exception.ResourceNotFoundException;
import fr.paris.lutece.plugins.notificationstore.v1.web.service.NotificationStoreService;
import fr.paris.lutece.portal.service.security.AccessLogService;
import fr.paris.lutece.portal.service.security.AccessLoggerConstants;
import fr.paris.lutece.portal.service.spring.SpringContextService;
import fr.paris.lutece.portal.service.util.AppPropertiesService;
import fr.paris.lutece.util.http.SecurityUtil;
import fr.paris.lutece.util.sql.TransactionManager;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.sql.Timestamp;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class IdentityService
{
    // Conf
    private static final String PIVOT_UNCERTIF_LEVEL_THRESHOLD = "identitystore.identity.uncertify.attribute.pivot.level.threshold";
    private static final String GUID_SEARCH_EXTENDED_IN_HISTORY = "identitystore.identity.extend.guid.search.to.history";

    // EVENTS FOR ACCESS LOGGING
    public static final String CREATE_IDENTITY_EVENT_CODE = "CREATE_IDENTITY";
    public static final String UPDATE_IDENTITY_EVENT_CODE = "UPDATE_IDENTITY";
    public static final String DECERTIFY_IDENTITY_EVENT_CODE = "DECERTIFY_IDENTITY";
    public static final String GET_IDENTITY_EVENT_CODE = "GET_IDENTITY";
    public static final String SEARCH_IDENTITY_EVENT_CODE = "SEARCH_IDENTITY";
    public static final String DELETE_IDENTITY_EVENT_CODE = "DELETE_IDENTITY";
    public static final String CONSOLIDATE_IDENTITY_EVENT_CODE = "CONSOLIDATE_IDENTITY";
    public static final String MERGE_IDENTITY_EVENT_CODE = "MERGE_IDENTITY";
    public static final String CANCEL_MERGE_IDENTITY_EVENT_CODE = "CANCEL_MERGE_IDENTITY";
    public static final String CANCEL_CONSOLIDATE_IDENTITY_EVENT_CODE = "CANCEL_CONSOLIDATE_IDENTITY";
    public static final String SPECIFIC_ORIGIN = "BO";

    // PROPERTIES
    private static final String PROPERTY_MAX_RESULT_UPDATED_IDENTITY_SEARCH = "identitystore.identity.updated.size.limit";

    // SERVICES
    private final IdentityStoreNotifyListenerService _identityStoreNotifyListenerService = IdentityStoreNotifyListenerService.instance( );
    private final IdentityAttributeService _identityAttributeService = IdentityAttributeService.instance( );
    private final InternalUserService _internalUserService = InternalUserService.getInstance( );
    private final IdentityQualityService _identityQualityService = IdentityQualityService.instance( );
    private final ISearchIdentityService _elasticSearchIdentityService = SpringContextService.getBean( "identitystore.searchIdentityService.elasticsearch" );
    private final NotificationStoreService _notificationStoreService = SpringContextService.getBean( "notificationStore.notificationStoreService" );

    // CACHE
    private final IdentityDtoCache _identityDtoCache = SpringContextService.getBean( "identitystore.identityDtoCache" );

    private static IdentityService _instance;

    public static IdentityService instance( )
    {
        if ( _instance == null )
        {
            _instance = new IdentityService( );
        } 
        return _instance;
    }

    /**
     * Creates a new {@link Identity} according to the given {@link IdentityChangeRequest}
     *
     * @param request
     *            the {@link IdentityChangeRequest} holding the parameters of the identity change request
     * @param author
     *            the author of the request
     * @param serviceContract
     *            service contract of the client requesting the change
     * @param formatStatuses
     *            the attribute formatting statuses (only for history purposes)
     * @return the created {@link Identity} along with a list of the {@link AttributeStatus}
     * @throws IdentityStoreException
     *             in case of error
     */
    public Pair<Identity, List<AttributeStatus>> create( final IdentityChangeRequest request, final RequestAuthor author, final ServiceContract serviceContract,
            final List<AttributeStatus> formatStatuses ) throws IdentityStoreException
    {
        final String clientCode = serviceContract.getClientCode( );
        final Identity identity = new Identity( );
        final List<AttributeStatus> attrStatusList = new ArrayList<>( );
        TransactionManager.beginTransaction( null );
        try
        {
            identity.setUnicityHashCode( _identityQualityService.computeUnicityHashCode( request ) );
            identity.setMonParisActive( request.getIdentity( ).isMonParisActive( ) );
            if ( StringUtils.isNotEmpty( request.getIdentity( ).getConnectionId( ) ) )
            {
                identity.setConnectionId( request.getIdentity( ).getConnectionId( ) );
            }
            IdentityHome.create( identity, serviceContract.getDataRetentionPeriodInMonths( ) );

            for ( final AttributeDto attributeDto : request.getIdentity( ).getAttributes( ) )
            {
                final AttributeStatus attributeStatus = _identityAttributeService.createAttribute( attributeDto, identity, clientCode );
                attrStatusList.add( attributeStatus );
            }

            TransactionManager.commitTransaction( null );

            /* Historique des modifications */
            for ( final AttributeStatus attributeStatus : attrStatusList )
            {
                _identityStoreNotifyListenerService.notifyListenersAttributeChange( AttributeChangeType.CREATE, identity, attributeStatus, author, clientCode );
            }

            /* Indexation et historique */
            final boolean incompleteCreation = Stream.concat( attrStatusList.stream( ), formatStatuses.stream( ) )
                    .anyMatch( s -> s.getStatus( ).equals( AttributeChangeStatus.NOT_CREATED ) );
            final ResponseStatusType statusType = incompleteCreation ? ResponseStatusType.INCOMPLETE_SUCCESS : ResponseStatusType.SUCCESS;
            final String statusMessage = incompleteCreation ? "incomplete success" : "success";
            _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.CREATE, identity, statusType.name( ), statusMessage, author,
                    clientCode, new HashMap<>( ) );
            AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_CREATE, CREATE_IDENTITY_EVENT_CODE,
                    _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( identity.getCustomerId( ) ), SPECIFIC_ORIGIN );

            return Pair.of( identity, attrStatusList );
        }
        catch( final Exception e )
        {
            TransactionManager.rollBack( null );
            if ( e instanceof IdentityStoreException )
            {
                throw e;
            }
            throw new IdentityStoreException( e.getMessage( ), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT );
        }
    }

    /**
     * Updates an existing {@link Identity} according to the given {@link IdentityChangeRequest} and following the given rules: <br>
     * <ul>
     * <li>The {@link Identity} must exist in te database. If not, NOT_FOUND status is returned in the execution response</li>
     * <li>The {@link Identity} must not be merged or deleted. In case of merged/deleted identity, the update is not performed and the customer ID of the
     * primary identity is returned in the execution response with a CONFLICT status</li>
     * <li>If the {@link Identity} can be updated, its {@link IdentityAttribute} list is updated following the given rule:
     * <ul>
     * <li>If the {@link IdentityAttribute} exists, it is updated if the value is different, and if the process level given in the request is higher than the
     * existing one. If the value cannot be updated, the NOT_UPDATED status, associated with the attribute key, is returned in the execution response.</li>
     * <li>If the {@link IdentityAttribute} does not exist, it is created. The CREATED status, associated with the attribute key, is returned in the execution
     * response.</li>
     * <li>CUID and GUID attributes cannot be modified.</li>
     * </ul>
     * </li>
     * </ul>
     *
     * @param customerId
     *            the id of the updated {@link Identity}
     * @param request
     *            the {@link IdentityChangeRequest} holding the parameters of the identity change request
     * @param author
     *            the author of the request
     * @param serviceContract
     *            service contract of the client requesting the change
     * @param formatStatuses
     *            the attribute formatting statuses (only for history purposes)
     * @return the updated {@link Identity} along with the attribute statuses
     * @throws IdentityStoreException
     *             in case of error
     */
    public Pair<Identity, List<AttributeStatus>> update( final String customerId, final IdentityChangeRequest request, final RequestAuthor author,
            final ServiceContract serviceContract, final List<AttributeStatus> formatStatuses ) throws IdentityStoreException
    {
        final String clientCode = serviceContract.getClientCode( );
        final Identity identity = IdentityHome.findByCustomerId( customerId );

        TransactionManager.beginTransaction( null );
        try
        {
            final Map<String, String> metadata = new HashMap<>();
            if ( !StringUtils.equalsIgnoreCase( identity.getConnectionId( ), request.getIdentity( ).getConnectionId( ) )
                    && StringUtils.isNotEmpty( request.getIdentity( ).getConnectionId( ) ) )
            {
                final String oldConnectionId = identity.getConnectionId();
                metadata.put(Constants.METADATA_NEW_GUID, request.getIdentity( ).getConnectionId( ) );
                metadata.put(Constants.METADATA_OLD_GUID, oldConnectionId);
                identity.setConnectionId( request.getIdentity( ).getConnectionId( ) );
                IdentityHome.update( identity );
                if ( StringUtils.isNotBlank( oldConnectionId ) )
                {
                    // Find date when the old GUID was set to the identity
                    final Timestamp oldGuidCreationDate =
                            IdentityHome.getIdentityGuidCreationDate( identity.getCustomerId( ), oldConnectionId );

                    final IdentityAccountHistory history = new IdentityAccountHistory( );
                    history.setConnectionId( oldConnectionId );
                    history.setIdIdentity( identity.getId( ) );
                    history.setDeletionDate( Timestamp.from( ZonedDateTime.now( ZoneId.systemDefault( ) ).toInstant( ) ) );
                    history.setCreationDate( oldGuidCreationDate == null ? identity.getCreationDate( ) : oldGuidCreationDate );
                    IdentityHome.insertIdentityAccountHistory( history );
                }
            }

            // => process update :
            final List<AttributeStatus> attrStatusList = this.updateIdentity( identity, request.getIdentity( ), clientCode, metadata, false);

            TransactionManager.commitTransaction( null );

            /* Historique des modifications */
            for ( final AttributeStatus attributeStatus : attrStatusList )
            {
                _identityStoreNotifyListenerService.notifyListenersAttributeChange( AttributeChangeType.UPDATE, identity, attributeStatus, author, clientCode );
            }

            /* Indexation et historique */
            final boolean allAttrCreatedOrUpdated = Stream.concat( attrStatusList.stream( ), formatStatuses.stream( ) ).map( AttributeStatus::getStatus )
                    .allMatch( status -> status.getType( ) == AttributeChangeStatusType.SUCCESS );
            final ResponseStatusType statusType = allAttrCreatedOrUpdated ? ResponseStatusType.SUCCESS : ResponseStatusType.INCOMPLETE_SUCCESS;
            final String statusMessage = allAttrCreatedOrUpdated ? "success" : "incomplete success";
            _identityStoreNotifyListenerService.notifyListenersIdentityChange(IdentityChangeType.UPDATE, identity, statusType.name( ), statusMessage, author,
                    clientCode, metadata);
            AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_MODIFY, UPDATE_IDENTITY_EVENT_CODE,
                    _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( identity.getCustomerId( ) ), SPECIFIC_ORIGIN );

            return Pair.of( identity, attrStatusList );
        }
        catch( final Exception e )
        {
            TransactionManager.rollBack( null );
            if ( e instanceof IdentityStoreException )
            {
                throw e;
            }
            throw new IdentityStoreException( e.getMessage( ), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT );
        }
    }

    /**
     * Merges two existing {@link Identity} specified in the given {@link IdentityMergeRequest} and following the given rules: <br>
     * <ul>
     * <li>Both {@link Identity} must exist and not be merged or deleted in te database. If not, FAILURE status is returned in the execution response</li>
     * <li>The {@link IdentityAttribute}(s) of the secondary {@link Identity} are processed, according to the list of keys specified in the
     * {@link IdentityMergeRequest}.
     * <ul>
     * <li>If the {@link IdentityAttribute} is not present in the primary {@link Identity}, it is created.</li>
     * <li>If the {@link IdentityAttribute} is present in the primary {@link Identity}, it is updated if the certification process is higher and the value is
     * different.</li>
     * </ul>
     * </li>
     * </ul>
     *
     * @param primaryIdentity the primary identity (master)
     * @param secondaryIdentity the secondary identity (merged)
     * @param identityForConsolidate the identityDto holding the attributes for consolidation
     * @param duplicateRuleCode the duplicate rule code
     * @param author
     *            the author of the request
     * @param clientCode
     *            code of the {@link ClientApplication} requesting the change
     * @param formatStatuses the format statuses (only for history)
     * @return the merged {@link Identity}
     * @throws IdentityStoreException
     *             in case of error
     */
    public Pair<Identity, List<AttributeStatus>> merge( final Identity primaryIdentity, final Identity secondaryIdentity, 
    		final IdentityDto identityForConsolidate, final String duplicateRuleCode, final RequestAuthor author, 
    		final String clientCode, boolean isResetFlagMonParisActive, 
            final List<AttributeStatus> formatStatuses ) throws IdentityStoreException
    {
	TransactionManager.beginTransaction( null );
        try
        {
            // reset first the unicityHashCode to avoid constaints conflicts  in next transaction
            IdentityHome.resetUnicityHashCode( secondaryIdentity );
            
            // commit
            TransactionManager.commitTransaction( null );
        }
        catch( Exception e )
        { 
            TransactionManager.rollBack( null );
            throw new IdentityStoreException( e.getMessage( ), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT );
        }
	
	TransactionManager.beginTransaction( null );
        try
        {
            final List<AttributeStatus> attrStatusList = new ArrayList<>( );
            final Map<String, String> primaryMetadata = new HashMap<>( );
            
            final Identity consolidatedIdentity = IdentityHome.findByCustomerId( primaryIdentity.getCustomerId( ) );
            primaryIdentity.setId( consolidatedIdentity.getId() );

            final Identity mergedIdentity = IdentityHome.findByCustomerId( secondaryIdentity.getCustomerId( ) );
            secondaryIdentity.setId( mergedIdentity.getId() );

            boolean identityUpdateRequested = false;

            // update expiration date if necessary
            if ( consolidatedIdentity.getExpirationDate( ).before( mergedIdentity.getExpirationDate( ) ) )
            {
            	primaryIdentity.setExpirationDate( mergedIdentity.getExpirationDate( ) );
                identityUpdateRequested = true;
            }
            
            // merge (merge first to reset unicity-hash-code and avoid unicity constraint violation) 
            secondaryIdentity.setMasterIdentityId( primaryIdentity.getId( ) );
            IdentityHome.merge( secondaryIdentity );
            
            // update attributes
            if ( identityForConsolidate != null && CollectionUtils.isNotEmpty( identityForConsolidate.getAttributes( ) ) )
            {
        	// search and keep the original certifier client (and certification date) in merge request
        	identityForConsolidate.getAttributes ( ).stream ( )
	            .filter( attr -> secondaryIdentity.getAttributes( ).containsKey( attr.getKey( ) ) )
	            .forEach( attr -> {
	        	String lastClientCode = secondaryIdentity.getAttributes( ).get( attr.getKey( ) ).getLastUpdateClientCode( );
	        	attr.setLastUpdateClientCode ( lastClientCode );
	            });
        	
        	// try to update 
                attrStatusList.addAll( this.updateIdentity( primaryIdentity, identityForConsolidate, clientCode, primaryMetadata, identityUpdateRequested, true ) );
            }
            
            
            // reset of the is_mon_paris_active flag of the secondary identity if necessary 
            if ( isResetFlagMonParisActive )
            {
            	secondaryIdentity.setMonParisActive( false ); 
            }
            
            // ré-affecter les notifications sur l'identité consolidée
            _notificationStoreService.reassignNotifications( secondaryIdentity.getCustomerId(), primaryIdentity.getCustomerId() );
            
            // commit
            TransactionManager.commitTransaction( null );
            
            /* Historique des modifications */
            for ( AttributeStatus attributeStatus : attrStatusList )
            {
                _identityStoreNotifyListenerService.notifyListenersAttributeChange( AttributeChangeType.MERGE, primaryIdentity, attributeStatus, author,
                        clientCode );
            }

            /* Indexation et historique */
            final boolean allAttrCreatedOrUpdated = Stream.concat( attrStatusList.stream( ), formatStatuses.stream( ) ).map( AttributeStatus::getStatus )
                    .allMatch( status -> status.getType( ) == AttributeChangeStatusType.SUCCESS );
            final ResponseStatusType statusType = allAttrCreatedOrUpdated ? ResponseStatusType.SUCCESS : ResponseStatusType.INCOMPLETE_SUCCESS;
            final String statusMessage = allAttrCreatedOrUpdated ? "success" : "incomplete success";

            primaryMetadata.put( Constants.METADATA_MERGED_MASTER_IDENTITY_CUID, primaryIdentity.getCustomerId( ) );
            primaryMetadata.put( Constants.METADATA_DUPLICATE_RULE_CODE, duplicateRuleCode );
            _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.MERGED, secondaryIdentity, statusType.name( ), statusMessage,
                    author, clientCode, primaryMetadata );

            AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_MODIFY, CONSOLIDATE_IDENTITY_EVENT_CODE,
                    _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( primaryIdentity.getCustomerId( ) ),
                    SPECIFIC_ORIGIN );

            final Map<String, String> secondaryMetadata = new HashMap<>( );
            secondaryMetadata.put( Constants.METADATA_MERGED_CHILD_IDENTITY_CUID, secondaryIdentity.getCustomerId( ) );
            secondaryMetadata.put( Constants.METADATA_DUPLICATE_RULE_CODE, duplicateRuleCode );
            _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.CONSOLIDATED, primaryIdentity, statusType.name( ),
                    statusMessage, author, clientCode, secondaryMetadata );

            AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_MODIFY, MERGE_IDENTITY_EVENT_CODE,
                    _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( secondaryIdentity.getCustomerId( ) ),
                    SPECIFIC_ORIGIN );

            return Pair.of( primaryIdentity, attrStatusList );
        }
        catch( IdentityStoreException e )
        {
            TransactionManager.rollBack( null );
            throw e;
        }
        catch( Exception e )
        { 
            TransactionManager.rollBack( null );
            throw new IdentityStoreException( e.getMessage( ), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT );
        }
    }

    /**
     * Detach a merged {@link Identity} from its master {@link Identity}
     * 
     * @param request
     *            the unmerge request
     * @param author
     *            the author of the request
     * @param clientCode
     *            the client code of the calling application
     */
    public Pair<Identity, List<AttributeStatus>>  cancelMerge( final IdentityMergeRequest request, final RequestAuthor author, final String clientCode ) throws IdentityStoreException
    {
	final List<AttributeStatus> attrStatusList = new ArrayList<>( );
        final Map<String, String> metadata = new HashMap<>( );
	
        final Identity primaryIdentity = IdentityHome.findByCustomerId( request.getPrimaryCuid( ) );
        Identity secondaryIdentity = IdentityHome.findByCustomerId( request.getSecondaryCuid( ) );
        
        final IdentityDto dtoWithNewAttributes = request.getIdentity( );

        TransactionManager.beginTransaction( null );
        try
        {
            // Annulation du merge
            IdentityHome.cancelMerge( secondaryIdentity );
            
            // ajout des attributs minimum
            if ( dtoWithNewAttributes != null && !dtoWithNewAttributes.getAttributes ( ).isEmpty ( ) )
            {
        	attrStatusList.addAll( this.updateIdentity( secondaryIdentity, dtoWithNewAttributes, clientCode, metadata, false ) );
            }
        
            TransactionManager.commitTransaction( null );

        }
        catch( final Exception e )
        {
            TransactionManager.rollBack( null );
            throw new IdentityStoreException( e.getMessage( ), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT );
        }
        
        /* Notification listeners pour indexation/historique */
        final Map<String, String> secondaryMetadata = new HashMap<>( );
        secondaryMetadata.put( Constants.METADATA_UNMERGED_MASTER_CUID, primaryIdentity.getCustomerId( ) );
        _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.MERGE_CANCELLED, secondaryIdentity,
                ResponseStatusType.SUCCESS.name( ), ResponseStatusType.SUCCESS.name( ), author, clientCode, secondaryMetadata );
        AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_MODIFY, CANCEL_MERGE_IDENTITY_EVENT_CODE,
                _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( secondaryIdentity.getCustomerId( ) ),
                SPECIFIC_ORIGIN );

        final Map<String, String> primaryMetadata = new HashMap<>( );
        primaryMetadata.put( Constants.METADATA_UNMERGED_CHILD_CUID, secondaryIdentity.getCustomerId( ) );
        _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.CONSOLIDATION_CANCELLED, primaryIdentity,
                ResponseStatusType.SUCCESS.name( ), ResponseStatusType.SUCCESS.name( ), author, clientCode, primaryMetadata );
        AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_MODIFY, CANCEL_CONSOLIDATE_IDENTITY_EVENT_CODE,
                _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( primaryIdentity.getCustomerId( ) ),
                SPECIFIC_ORIGIN );
        
        // refresh
        secondaryIdentity = IdentityHome.findByCustomerId( request.getSecondaryCuid( ) );
        return Pair.of( secondaryIdentity, attrStatusList );
    }

    /**
     * Perform an identity research over a list of attributes (key and values) specified in the {@link IdentitySearchRequest}
     *
     * @param request
     *            the {@link IdentitySearchRequest} holding the parameters of the research
     * @param author
     *            the author of the request
     * @param serviceContract
     *            service contract of the client requesting the change
     * @throws ResourceNotFoundException
     *             in case of {@link AttributeKey} management error
     * @throws IdentityStoreException
     *             in case of unpredicted error
     * @return list of matching identities
     */
    public List<IdentityDto> search( final IdentitySearchRequest request, final RequestAuthor author, final ServiceContract serviceContract )
            throws IdentityStoreException
    {
        final String clientCode = serviceContract.getClientCode( );
        AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, SEARCH_IDENTITY_EVENT_CODE,
                _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( request.toString( ) ), SPECIFIC_ORIGIN );
        final List<SearchAttribute> providedAttributes = request.getSearch( ).getAttributes( );
        final QualifiedIdentitySearchResult result = _elasticSearchIdentityService.getQualifiedIdentities( providedAttributes, request.getMax( ),
                request.isConnected( ), Collections.emptyList( ) );
        if ( CollectionUtils.isNotEmpty( result.getQualifiedIdentities( ) ) )
        {
            final List<IdentityDto> filteredIdentities = this.getEnrichedIdentities( request.getSearch( ).getAttributes( ), serviceContract,
                    result.getQualifiedIdentities( ) );
            if ( CollectionUtils.isNotEmpty( filteredIdentities ) )
            {
                for ( final IdentityDto identity : filteredIdentities )
                {
                    AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, SEARCH_IDENTITY_EVENT_CODE,
                            _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( identity.getCustomerId( ) ),
                            SPECIFIC_ORIGIN );
                    if ( author.getType( ).equals( AuthorType.agent ) )
                    {
                        /* Indexation et historique */
                        _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.READ,
                                DtoConverter.convertDtoToIdentity( identity ), ResponseStatusType.OK.name( ), "Operation completed successfully", author,
                                clientCode, new HashMap<>( ) );
                    }
                }
                return filteredIdentities;
            }
        }
       
        // return the empty list
        return result.getQualifiedIdentities( ); 
    }

    /**
     * Perform an identity research by customer or connection ID.
     *
     * @param customerId
     * @param serviceContract
     * @param author
     *            the author of the request
     * @throws ResourceNotFoundException
     */
    public IdentityDto searchByCustomerId(final String customerId, final ServiceContract serviceContract, final RequestAuthor author )
            throws IdentityStoreException
    {
        final String clientCode = serviceContract.getClientCode( );
        AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, GET_IDENTITY_EVENT_CODE, _internalUserService.getApiUser( clientCode ),
                SecurityUtil.logForgingProtect( customerId ), SPECIFIC_ORIGIN );

        final IdentityDto identityDto = _identityDtoCache.getMasterIdentityByCustomerId( customerId, serviceContract );
        if ( identityDto == null )
        {
            // #345 : If the identity doesn't exist, make an extra search in the history (only for CUID search).
            // If there is a record, it means the identity has been deleted => send back a specific message
            if ( StringUtils.isNotBlank( customerId ) && !IdentityHome.findHistoryByCustomerId( customerId ).isEmpty( ) )
            {
                throw new ResourceNotFoundException( "The requested identity has been deleted.", Constants.PROPERTY_REST_ERROR_IDENTITY_DELETED );
            }
            else
            {
                throw new ResourceNotFoundException( "The requested identity could not be found.", Constants.PROPERTY_REST_ERROR_NO_IDENTITY_FOUND );
            }
        }
        else
        {
            if ( author != null )
            {
                AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, SEARCH_IDENTITY_EVENT_CODE,
                        _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( identityDto.getCustomerId( ) ),
                        SPECIFIC_ORIGIN );
            }
            if ( author != null && author.getType( ).equals( AuthorType.agent ) )
            {
                /* Indexation et historique */
                _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.READ, DtoConverter.convertDtoToIdentity( identityDto ),
                        ResponseStatusType.OK.name( ), "Operation completed successfully", author, clientCode, new HashMap<>( ) );
            }
            return identityDto;
        }
    }

    /**
     * Perform an identity research by connection ID.
     *
     * @param connectionId - the connection ID
     * @param serviceContract - the service contract
     * @param author
     *            the author of the request
     * @throws ResourceNotFoundException
     */
    public List<IdentityDto> searchByConnectionId( final String connectionId, final ServiceContract serviceContract, final RequestAuthor author )
            throws IdentityStoreException
    {
        final String clientCode = serviceContract.getClientCode( );
        AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, GET_IDENTITY_EVENT_CODE, _internalUserService.getApiUser( clientCode ),
                SecurityUtil.logForgingProtect( connectionId ), SPECIFIC_ORIGIN );

        final List<IdentityDto> resultList;
        final IdentityDto result = _identityDtoCache.getMasterIdentityByConnectionId( connectionId, serviceContract );
        if ( result != null )
        {
            resultList = List.of( result );
        }
        else if ( AppPropertiesService.getPropertyBoolean(GUID_SEARCH_EXTENDED_IN_HISTORY, true ) )
        {
            // If the identity was not found with the current connection ID, perform another search in the connection ID history
            resultList = _identityDtoCache.getMasterIdentitiesByOldConnectionId( connectionId, serviceContract );

            if ( resultList.isEmpty( ) )
            {
                throw new ResourceNotFoundException( "The requested identity could not be found.", Constants.PROPERTY_REST_ERROR_NO_IDENTITY_FOUND );
            }
        }
        else
        {
            throw new ResourceNotFoundException( "The requested identity could not be found.", Constants.PROPERTY_REST_ERROR_NO_IDENTITY_FOUND );
        }

        if ( author != null )
        {
            for ( final IdentityDto identityDto : resultList )
            {
                AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, SEARCH_IDENTITY_EVENT_CODE,
                        _internalUserService.getApiUser( author, clientCode ), SecurityUtil.logForgingProtect( identityDto.getCustomerId( ) ),
                        SPECIFIC_ORIGIN );

                if ( author.getType( ).equals( AuthorType.agent ) )
                {
                    /* Indexation et historique */
                    _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.READ, DtoConverter.convertDtoToIdentity( identityDto ),
                            ResponseStatusType.OK.name( ), "Operation completed successfully", author, clientCode, new HashMap<>( ) );
                }
            }
        }

        return resultList;
    }

    /**
     * Performs a search of a list of {@link IdentityDto}, providing a list of customer ids
     * 
     * @param customerIds
     *            the customer ids to search for
     * @return a list of {@link IdentityDto}
     */
    public List<IdentityDto> search( final List<String> customerIds, final List<String> attributes )
    {
        try
        {
            final QualifiedIdentitySearchResult result = _elasticSearchIdentityService.getQualifiedIdentities( customerIds, attributes );
            if ( result != null && CollectionUtils.isNotEmpty( result.getQualifiedIdentities( ) ) )
            {
                result.getQualifiedIdentities( ).forEach( identityDto -> {
                    IdentityQualityService.instance( ).computeQuality( identityDto );
                    identityDto.getQuality( ).setScoring( 1D );
                    identityDto.getQuality( ).setCoverage( 1 );
                } );
                return result.getQualifiedIdentities( );
            }
        }
        catch( final IdentityStoreException e )
        {
            // ignore this identity
        }
        return new ArrayList<>( );
    }

    /**
     * Performs a search of an {@link IdentityDto}, providing its customer id
     * 
     * @param customerId
     *            the customer id to search for
     * @return an {@link IdentityDto}
     */
    public IdentityDto search( final String customerId )
    {
        try
        {
            final QualifiedIdentitySearchResult result = _elasticSearchIdentityService.getQualifiedIdentities( customerId, Collections.emptyList( ) );
            if ( result != null && CollectionUtils.isNotEmpty( result.getQualifiedIdentities( ) ) )
            {
                final IdentityDto identityDto = result.getQualifiedIdentities( ).get( 0 );
                IdentityQualityService.instance( ).computeQuality( identityDto );
                identityDto.getQuality( ).setScoring( 1D );
                identityDto.getQuality( ).setCoverage( 1 );
                return identityDto;
            }
        }
        catch( final IdentityStoreException e )
        {
            // ignore this identity
        }
        return null;
    }

    /**
     * Filter a list of search results over {@link ServiceContract} defined for the given clientCode. Also complete identities with additional information
     * (quality, duplicates, ...).
     * 
     * @param searchAttributes
     *            la requête de recherche si existante
     * @param serviceContract
     *            le contrat de service du demandeur
     * @param identities
     *            la liste de résultats à traiter
     * @return the list of filtered and completed {@link IdentityDto}
     */
    private List<IdentityDto> getEnrichedIdentities( final List<SearchAttribute> searchAttributes, final ServiceContract serviceContract,
            final List<IdentityDto> identities )
    {
        final Comparator<QualityDefinition> qualityComparator = Comparator.comparing( QualityDefinition::getScoring )
                .thenComparingDouble( QualityDefinition::getQuality ).reversed( );
        final Comparator<IdentityDto> identityComparator = Comparator.comparing( IdentityDto::getQuality, qualityComparator );
        return identities.stream( ).filter( IdentityDto::isNotMerged )
                .peek( identity -> IdentityQualityService.instance( ).enrich( searchAttributes, identity, serviceContract, null ) ).sorted( identityComparator )
                .collect( Collectors.toList( ) );
    }

    /**
     * Process full identity update with attributes of the requestIdentity
     * 
     * @param identity
     * @param requestIdentity
     * @param clientCode
     * @param metadata
     * @return the list of attribute status
     * @throws IdentityStoreException
     */
    private List<AttributeStatus> updateIdentity( final Identity identity, final IdentityDto requestIdentity, final String clientCode, final Map<String, String> metadata, boolean identityUpdateRequested)
            throws IdentityStoreException
    {
	return updateIdentity( identity, requestIdentity, clientCode, metadata, identityUpdateRequested, false);
    }
            
    /**
     * Process full identity update with attributes of the requestIdentity
     * 
     * @param identity
     * @param requestIdentity
     * @param clientCode
     * @param metadata
     * @return the list of attribute status
     * @throws IdentityStoreException
     */
    private List<AttributeStatus> updateIdentity( final Identity identity, final IdentityDto requestIdentity, final String clientCode, 
	    final Map<String, String> metadata, boolean identityUpdateRequested, boolean keepOriginalCertification)
            throws IdentityStoreException
    {
        final List<AttributeStatus> attrStatusList = new ArrayList<>( );

        /* Récupération des attributs déja existants ou non */
        final Map<Boolean, List<AttributeDto>> sortedAttributes = requestIdentity.getAttributes( ).stream( )
                .collect( Collectors.partitioningBy( a -> identity.getAttributes( ).containsKey( a.getKey( ) ) ) );
        final List<AttributeDto> existingWritableAttributes = CollectionUtils.isNotEmpty( sortedAttributes.get( true ) ) ? sortedAttributes.get( true )
                : new ArrayList<>( );
        final List<AttributeDto> newWritableAttributes = CollectionUtils.isNotEmpty( sortedAttributes.get( false ) ) ? sortedAttributes.get( false )
                : new ArrayList<>( );

        /* Create new attributes */
        for ( final AttributeDto attributeToWrite : newWritableAttributes )
        {
            final AttributeStatus attributeStatus = _identityAttributeService.createAttribute( attributeToWrite, 
        	    identity, ( keepOriginalCertification?attributeToWrite.getLastUpdateClientCode ( ):clientCode ) );
            attrStatusList.add( attributeStatus );
        }

        /* Update existing attributes */
        for ( final AttributeDto attributeToUpdate : existingWritableAttributes )
        {
            final AttributeStatus attributeStatus = _identityAttributeService.updateAttribute( attributeToUpdate, 
        	    identity, ( keepOriginalCertification?attributeToUpdate.getLastUpdateClientCode ( ):clientCode ) );
            attrStatusList.add( attributeStatus );
        }

        boolean monParisUpdated = false;
        if ( requestIdentity.getMonParisActive( ) != null && requestIdentity.getMonParisActive( ) != identity.isMonParisActive( ) )
        {
            metadata.put(Constants.METADATA_NEW_MON_PARIS_ACTIF, String.valueOf( requestIdentity.getMonParisActive( ) ) );
            metadata.put(Constants.METADATA_OLD_MON_PARIS_ACTIF, String.valueOf( identity.isMonParisActive( ) ) );
            if( !identity.isMonParisActive( ) && requestIdentity.getMonParisActive( ) )
            {
                // If monParis flag switches from false to true, reset delete_date
                identity.setDeleteDate( null );
            }
            monParisUpdated = true;
            identity.setMonParisActive( requestIdentity.isMonParisActive( ) );
        }

        /* Compute new unicity hashcode based on existing, successfully created or updated attributes */
        final String previousHashCode = identity.getUnicityHashCode();
        // WARNING: identity attributes list is modified through _identityAttributeService, it won't match if the service is modified in another way
        identity.setUnicityHashCode( _identityQualityService.computeUnicityHashCode( identity ) );
        final boolean unicityHascodeHasChanged = !StringUtils.equals( previousHashCode, identity.getUnicityHashCode( ) );

        /* Check if the attribute list has changed */
        final boolean attributeHasChanged = Collections.disjoint(AttributeChangeStatus.getSuccessStatuses(), attrStatusList.stream().map(AttributeStatus::getStatus).collect(Collectors.toList()));

        if ( identityUpdateRequested  || monParisUpdated  || !attributeHasChanged || unicityHascodeHasChanged )
        {
            // If there was an update on the monParis flag or in the attributes, we update the identity
            IdentityHome.update( identity );
        }

        return attrStatusList;
    }

    /**
     * Gets a list of qualified identities on which to search potential duplicates.<br/>
     * Returned identities must have all attributes checked by the provided rule, and must also not be already merged nor be tagged as suspicious.<br/>
     * The list is sorted by quality (higher quality identities first).
     *
     * @param rule
     *            the rule used to get matching identities
     * @param batchSize the size of the batches
     * @param includeSuspicions filter CUIDs, to include or not, the CUIDs that are identified as suspicions
     * @return the list of identities
     */
    public Batch<String> getCUIDsBatchForPotentialDuplicate(final DuplicateRule rule, final int batchSize, final boolean includeSuspicions )
    {
        final List<Integer> attributes = rule.getCheckedAttributes( ).stream( ).map( AttributeKey::getId ).collect( Collectors.toList( ) );
        final List<String> customerIdsList = IdentityHome.findByAttributeExisting( attributes, rule.getNbFilledAttributes( ), true, !includeSuspicions, rule.getPriority() );
        if ( customerIdsList.isEmpty( ) )
        {
            return Batch.ofSize( Collections.emptyList( ), 0 );
        }
        return Batch.ofSize( customerIdsList, batchSize );
    }

    /**
     * request a deletion of identity .
     *
     * @param customerId
     *            the customer ID
     * @param clientCode
     *            the client code
     * @param author
     *            the author of the request
     */
    public void deleteRequest( final String customerId, final String clientCode, final RequestAuthor author ) throws IdentityStoreException {
        final Identity identity = IdentityHome.findByCustomerId(customerId);

        TransactionManager.beginTransaction(null);
        try {
            // expire identity (the deletion is managed by the dedicated Daemon)
            IdentityHome.softRemove(customerId);
            TransactionManager.commitTransaction(null);

            /* Notify listeners for indexation, history, ... */
            _identityStoreNotifyListenerService.notifyListenersIdentityChange(IdentityChangeType.DELETE_REQUEST, identity, ResponseStatusType.SUCCESS.name(),
                    ResponseStatusType.SUCCESS.name(), author, clientCode, new HashMap<>());

            
        } catch (final Exception e) {
            TransactionManager.rollBack(null);
            if (e instanceof IdentityStoreException) {
                throw e;
            }
            throw new IdentityStoreException(e.getMessage(), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT);
        }
    }

    /**
     * Dé-certification d'une identité.
     *
     * @param strCustomerId
     *            customer ID
     * @return the response
     * @see IdentityAttributeService#uncertifyAttribute
     */
    public Pair<Identity, List<AttributeStatus>> uncertifyIdentity( final String strCustomerId, final List<AttributeKey> requestedAttributesKeys, final String strClientCode, final RequestAuthor author )
            throws IdentityStoreException
    {
        final Identity identity = IdentityHome.findByCustomerId( strCustomerId );
        final Collection<IdentityAttribute> attributesToDecertify;
        if (!requestedAttributesKeys.isEmpty()) {
            final List<String> requestedAttributeKeysStr = requestedAttributesKeys.stream().map(AttributeKey::getKeyName).collect(Collectors.toList());
            // #27794 - if pivot requested to be decertified, and one of them is leveled >= PIVOT_UNCERTIF_LEVEL_THRESHOLD
            //          -> decertify all pivots
            final int pivotUncertifyLevelThreshold = AppPropertiesService.getPropertyInt(PIVOT_UNCERTIF_LEVEL_THRESHOLD, 400);
            final List<IdentityAttribute> pivotAttributes =
                    identity.getAttributes().values().stream().filter(a -> a.getAttributeKey().getPivot()).collect(Collectors.toList());
            if (requestedAttributesKeys.stream().anyMatch(AttributeKey::getPivot) && pivotAttributes.stream().anyMatch(a -> AttributeCertificationDefinitionService.instance().getLevelAsInteger( a.getCertificate( ).getCertifierCode( ), a.getAttributeKey().getKeyName() ) >= pivotUncertifyLevelThreshold)) {
                attributesToDecertify = identity.getAttributes().values().stream().filter(a -> a.getAttributeKey().getPivot() || requestedAttributeKeysStr.contains(a.getAttributeKey().getKeyName())).collect(Collectors.toList());
            } else {
                attributesToDecertify = identity.getAttributes().values().stream().filter(a -> requestedAttributeKeysStr.contains(a.getAttributeKey().getKeyName())).collect(Collectors.toList());
            }
        } else {
            attributesToDecertify = identity.getAttributes().values();
        }

        if (attributesToDecertify.isEmpty()) {
            throw new IdentityStoreException( "No attributes to decertify", Constants.PROPERTY_REST_ERROR_DURING_TREATMENT);
        }

        TransactionManager.beginTransaction( null );
        try
        {
            final List<AttributeStatus> attrStatusList = new ArrayList<>( );
            for ( final IdentityAttribute attribute : attributesToDecertify)
            {
                final AttributeStatus status = _identityAttributeService.uncertifyAttribute( attribute );
                attrStatusList.add( status );
            }

            // update identity to set lastupdate_date
            IdentityHome.update( identity );
            TransactionManager.commitTransaction( null );

            /* Historique des modifications */
            for ( AttributeStatus attributeStatus : attrStatusList )
            {
                _identityStoreNotifyListenerService.notifyListenersAttributeChange( AttributeChangeType.UPDATE, identity, attributeStatus, author,
                        strClientCode );
            }

            /* Indexation et historique */
            _identityStoreNotifyListenerService.notifyListenersIdentityChange( IdentityChangeType.UPDATE, identity, ResponseStatusType.SUCCESS.name( ),
                    ResponseStatusType.SUCCESS.name( ), author, strClientCode, new HashMap<>( ) );

            AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_MODIFY, DECERTIFY_IDENTITY_EVENT_CODE,
                    _internalUserService.getApiUser( author, strClientCode ), SecurityUtil.logForgingProtect( strCustomerId ), SPECIFIC_ORIGIN );

            return Pair.of( identity, attrStatusList );
        }
        catch( final Exception e )
        {
            TransactionManager.rollBack( null );
            if ( e instanceof IdentityStoreException )
            {
                throw e;
            }
            throw new IdentityStoreException( e.getMessage( ), e, Constants.PROPERTY_REST_ERROR_DURING_TREATMENT );
        }
    }

    /**
     * Delete the identity and all his children, including potential merged identities, EXCEPT identity history.<br/>
     * The purge consist of deleting, for the identity and all of its potential merged identities :
     * <ul>
     * <li>the {@link Identity} object</li>
     * <li>the {@link IdentityAttribute} objetcs</li>
     * <li>the IdentityAttributeHistory objects</li>
     * <li>the {@link SuspiciousIdentity} objects</li>
     * <li>the {@link ExcludedIdentities} objects</li>
     * </ul>
     * The identity's history is kept.
     * 
     * @param customerId
     *            the customerId of the identity to delete
     *            the customerId of the identity to delete
     */
    public void delete( final String customerId )
    {
        Identity identity = IdentityHome.findByCustomerId( customerId );
        if ( identity != null && identity.getId( ) != -1 )
        {
            final List<Identity> mergedIdentities = IdentityHome.findMergedIdentities( identity.getId( ) );
            TransactionManager.beginTransaction( null );
            try
            {
        	Map<String,String> mapIdentityValues = new HashMap<> ( );
        	if ( AppPropertiesService.getPropertyBoolean ( "daemon.purgeIdentityDaemon.keepIdentityValuesInHistory", false ) )
        	{
        	    mapIdentityValues = identity.toMap( );
        	}
        	
                // Delete eventual merged identities first
                for ( final Identity mergedIdentity : mergedIdentities )
                {
                    SuspiciousIdentityHome.remove( mergedIdentity.getCustomerId( ) );
                    SuspiciousIdentityHome.removeExcludedIdentities( mergedIdentity.getCustomerId( ) );
                    IdentityHome.deleteAttributeHistory( mergedIdentity.getId( ) );
                    IdentityHome.hardRemove( mergedIdentity.getId( ) );
                }
                // Delete the actual identity
                SuspiciousIdentityHome.remove( customerId );
                SuspiciousIdentityHome.removeExcludedIdentities( customerId );
                IdentityHome.deleteAttributeHistory( identity.getId( ) );
                IdentityHome.hardRemove( identity.getId( ) );

                /* Notify listeners for indexation, history, ... */
                _identityStoreNotifyListenerService.notifyListenersIdentityChange(IdentityChangeType.DELETE, identity, ResponseStatusType.SUCCESS.name(),
                        ResponseStatusType.SUCCESS.name(), new RequestAuthor ("DAEMON", AuthorType.application.name ( ) ), "DAEMON", mapIdentityValues);
                
                AccessLogService.getInstance().info(AccessLoggerConstants.EVENT_TYPE_DELETE, DELETE_IDENTITY_EVENT_CODE,
                        null, SecurityUtil.logForgingProtect(customerId), SPECIFIC_ORIGIN);
                
                TransactionManager.commitTransaction( null );
            }
            catch( final Exception e )
            {
                TransactionManager.rollBack( null );
                throw e;
            }
        }
    }

    /**
     * Search for updated identities according to the provided request
     *
     * @param request
     *            the request
     * @return the updated identities, along with the pagination (or null if none requested)
     * @throws IdentityStoreException
     *             in case of error
     */
    public Pair<List<UpdatedIdentityDto>, Page> searchUpdatedIdentities( final UpdatedIdentitySearchRequest request ) throws IdentityStoreException
    {
        final int maxFromProperty = AppPropertiesService.getPropertyInt( PROPERTY_MAX_RESULT_UPDATED_IDENTITY_SEARCH, 500 );
        final int maxResult = request.getMax( ) == null ? maxFromProperty : Math.min( request.getMax( ), maxFromProperty );
        final List<UpdatedIdentityDto> updatedIdentities;
        if ( request.getPage( ) != null && request.getSize( ) != null )
        {
            // Si pagination
            // première requête qui ne ramène que les ID (avec un LIMIT ${maxResult}), triés par date de derniere modification
            final List<Integer> allUpdatedIdentityIds = IdentityHome.findUpdatedIdentityIds( request.getDays( ), request.getIdentityChangeTypes( ),
                    request.getUpdatedAttributes( ), maxResult );

            final int totalRecords = allUpdatedIdentityIds.size( );
            if ( totalRecords == 0 )
            {
                throw new ResourceNotFoundException( "No updated identity found with the provided criterias.",
                        Constants.PROPERTY_REST_ERROR_NO_UPDATED_IDENTITY_FOUND );
            }
            final int totalPages = (int) Math.ceil( (double) totalRecords / request.getSize( ) );
            if ( request.getPage( ) > totalPages )
            {
                throw new RequestFormatException( "Pagination index should not exceed total number of pages.", Constants.PROPERTY_REST_PAGINATION_END_ERROR );
            }

            final Page pagination = new Page( );
            pagination.setTotalPages( totalPages );
            pagination.setTotalRecords( totalRecords );
            pagination.setCurrentPage( request.getPage( ) );
            pagination.setNextPage( request.getPage( ) == totalPages ? null : request.getPage( ) + 1 );
            pagination.setPreviousPage( request.getPage( ) > 1 ? request.getPage( ) - 1 : null );

            // deuxième requête qui prend les IDs correspondant à la page demandée (sublist), et qui va chercher les data
            final int start = ( request.getPage( ) - 1 ) * request.getSize( );
            final int end = Math.min( start + request.getSize( ), totalRecords );
            updatedIdentities = IdentityHome.getUpdatedIdentitiesFromIds( allUpdatedIdentityIds.subList( start, end ) );

            return Pair.of( updatedIdentities, pagination );
        }
        else
        {
            // Pas de pagination demandée, une seule requête qui ramène directement les datas (avec un LIMIT ${maxResult} )
            updatedIdentities = IdentityHome.findUpdatedIdentities( request.getDays( ), request.getIdentityChangeTypes( ), request.getUpdatedAttributes( ),
                    maxResult );
            if ( updatedIdentities.isEmpty( ) )
            {
                throw new ResourceNotFoundException( "No updated identity found with the provided criterias.",
                        Constants.PROPERTY_REST_ERROR_NO_UPDATED_IDENTITY_FOUND );
            }

            return Pair.of( updatedIdentities, null );
        }
    }

}
