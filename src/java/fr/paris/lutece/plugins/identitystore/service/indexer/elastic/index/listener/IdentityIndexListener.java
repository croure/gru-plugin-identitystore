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
package fr.paris.lutece.plugins.identitystore.service.indexer.elastic.index.listener;

import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentity;
import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentityHome;
import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.business.rules.duplicate.DuplicateRule;
import fr.paris.lutece.plugins.identitystore.service.IdentityChangeListener;
import fr.paris.lutece.plugins.identitystore.service.duplicate.DuplicateRuleService;
import fr.paris.lutece.plugins.identitystore.service.duplicate.IDuplicateService;
import fr.paris.lutece.plugins.identitystore.service.indexer.elastic.index.model.AttributeObject;
import fr.paris.lutece.plugins.identitystore.service.indexer.elastic.index.model.IdentityObject;
import fr.paris.lutece.plugins.identitystore.service.indexer.elastic.index.service.IIdentityIndexer;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.DtoConverter;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.RequestAuthor;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChangeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.DuplicateSearchResponse;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.QualifiedIdentitySearchResult;
import fr.paris.lutece.portal.service.util.AppLogService;
import fr.paris.lutece.portal.service.util.AppPropertiesService;
import fr.paris.lutece.util.sql.TransactionManager;

import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

public class IdentityIndexListener implements IdentityChangeListener
{
    private static final String CURRENT_INDEX_ALIAS = AppPropertiesService.getProperty( "identitystore.elastic.client.identities.alias", "identities-alias" );
    private static final String SERVICE_NAME = "Elastic Search identity change listener";

    private final IIdentityIndexer _identityIndexer;
    private final IDuplicateService _duplicateServiceElasticSearch;

    public IdentityIndexListener( final IIdentityIndexer _identityIndexer, final IDuplicateService _duplicateServiceElasticSearch )
    {
        this._identityIndexer = _identityIndexer;
        this._duplicateServiceElasticSearch = _duplicateServiceElasticSearch;
    }

    @Override
    public void processIdentityChange( IdentityChangeType identityChangeType, Identity identity, String statusCode, String statusMessage, RequestAuthor author,
            String clientCode, Map<String, String> metadata )
    {
        switch( identityChangeType )
        {
            case CREATE:
            case MERGE_CANCELLED:
                AppLogService.debug( "Indexing identity change (" + identityChangeType.name( ) + ") with customerId = " + identity.getCustomerId( ) );
                this._identityIndexer.create( this.toIdentityObject( identity ), CURRENT_INDEX_ALIAS );
                break;
            case DELETE_REQUEST:
            case UPDATE:
            case CONSOLIDATED:
                AppLogService.debug( "Indexing identity change (" + identityChangeType.name( ) + ") with customerId = " + identity.getCustomerId( ) );
                this._identityIndexer.update( this.toIdentityObject( identity ), CURRENT_INDEX_ALIAS );
                break;
            case DELETE:
            case MERGED:
                AppLogService.debug( "Indexing identity change (" + identityChangeType.name( ) + ") with customerId = " + identity.getCustomerId( ) );
                this._identityIndexer.delete( identity.getCustomerId( ), CURRENT_INDEX_ALIAS );
                break;
            case READ:
                return;
            case EXCLUDED:
            case EXCLUSION_CANCELLED:
            case MARKED_SUSPICIOUS:
            case CONSOLIDATION_CANCELLED:
            default:
                break;
        }

        // Ensure that the identity is a valid suspicion
        this.checkSuspicion( identity );
    }

    /**
     * Builds the index document of the given {@link Identity}
     *
     * @param identity
     *            the {@link Identity} to index
     * @return the {@link IdentityObject} to send to the index
     */
    private IdentityObject toIdentityObject( final Identity identity )
    {
        return new IdentityObject( identity.getConnectionId( ), identity.getCustomerId( ), identity.getCreationDate( ), identity.getLastUpdateDate( ),
                identity.getExpirationDate( ), identity.getDeleteDate( ), identity.isMonParisActive( ), this.mapToIndexObject( identity ) );
    }

    @Override
    public String getName( )
    {
        return SERVICE_NAME;
    }

    private Map<String, AttributeObject> mapToIndexObject( final Identity identity )
    {
        return identity.getAttributes( ).values( ).stream( )
                .map( attribute -> new AttributeObject( attribute.getAttributeKey( ).getName( ), attribute.getAttributeKey( ).getKeyName( ),
                        attribute.getAttributeKey( ).getKeyType( ).getCode( ), attribute.getValue( ), attribute.getAttributeKey( ).getDescription( ),
                        attribute.getAttributeKey( ).getPivot( ), attribute.getCertificate( ) != null ? attribute.getCertificate( ).getCertifierCode( ) : null,
                        attribute.getCertificate( ) != null ? attribute.getCertificate( ).getCertifierName( ) : null,
                        attribute.getCertificate( ) != null ? attribute.getCertificate( ).getCertificateDate( ) : null,
                        attribute.getCertificate( ) != null ? attribute.getCertificate( ).getExpirationDate( ) : null, attribute.getLastUpdateClientCode( ) ) )
                .collect( Collectors.toMap( AttributeObject::getKey, o -> o ) );
    }

    /**
     * Check if the given {@link Identity} is a {@link fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentity} or not. <br>
     * If it is suspicious, delete from suspicions.
     *
     * @param identity
     *            the {@link Identity} to handle
     */
    private void checkSuspicion( final Identity identity )
    {
        final SuspiciousIdentity suspiciousIdentity = SuspiciousIdentityHome.selectByCustomerID( identity.getCustomerId( ) );
        if ( suspiciousIdentity != null )
        {
            try
            {
                final Map<String, String> attributeMap = DtoConverter.convertIdentityToDto( identity ).getAttributes( ).stream( )
                        .collect( Collectors.toMap( AttributeDto::getKey, AttributeDto::getValue ) );
                final DuplicateRule duplicateRule = DuplicateRuleService.instance().get(suspiciousIdentity.getDuplicateRuleCode());
                final Map<String, QualifiedIdentitySearchResult> duplicates = _duplicateServiceElasticSearch.findDuplicates(attributeMap, identity.getCustomerId(), Collections.singletonList(duplicateRule), Collections.emptyList());
                final QualifiedIdentitySearchResult qualifiedIdentitySearchResult = duplicates.get(suspiciousIdentity.getDuplicateRuleCode());

                if ( qualifiedIdentitySearchResult == null || qualifiedIdentitySearchResult.getQualifiedIdentities( ).isEmpty( ) )
                {
                    TransactionManager.beginTransaction( null );
                    SuspiciousIdentityHome.remove( identity.getCustomerId( ) );
                    TransactionManager.commitTransaction( null );
                }
            }
            catch( final Exception e )
            {
                TransactionManager.rollBack( null );
                AppLogService.error( "Handle suspicion :: Could not handle identity " + identity.getCustomerId( ) + " : " + e.getMessage( ) );
            }
        }
    }
}
