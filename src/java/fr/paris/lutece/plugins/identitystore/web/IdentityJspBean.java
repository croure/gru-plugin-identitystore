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
package fr.paris.lutece.plugins.identitystore.web;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import fr.paris.lutece.plugins.grubusiness.business.web.rs.DemandDisplay;
import fr.paris.lutece.plugins.grubusiness.business.web.rs.DemandResult;
import fr.paris.lutece.plugins.grubusiness.business.web.rs.EnumGenericStatus;
import fr.paris.lutece.plugins.grubusiness.service.notification.NotificationException;
import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentityHome;
import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAttribute;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAttributeHome;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityConstants;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityHome;
import fr.paris.lutece.plugins.identitystore.service.IdentityManagementResourceIdService;
import fr.paris.lutece.plugins.identitystore.service.PurgeIdentityService;
import fr.paris.lutece.plugins.identitystore.service.identity.IdentityService;
import fr.paris.lutece.plugins.identitystore.service.search.ISearchIdentityService;
import fr.paris.lutece.plugins.identitystore.utils.Batch;
import fr.paris.lutece.plugins.identitystore.v3.csv.CsvIdentityService;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.DtoConverter;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeTreatmentType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.BatchDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.IdentityDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.AttributeChange;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChange;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChangeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.importing.BatchImportRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.SearchAttribute;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.util.Constants;
import fr.paris.lutece.plugins.identitystore.web.exception.ClientAuthorizationException;
import fr.paris.lutece.plugins.identitystore.web.exception.IdentityStoreException;
import fr.paris.lutece.plugins.notificationstore.v1.web.service.NotificationStoreService;
import fr.paris.lutece.portal.service.admin.AccessDeniedException;
import fr.paris.lutece.portal.service.security.AccessLogService;
import fr.paris.lutece.portal.service.security.AccessLoggerConstants;
import fr.paris.lutece.portal.service.spring.SpringContextService;
import fr.paris.lutece.portal.service.util.AppLogService;
import fr.paris.lutece.portal.service.util.AppPropertiesService;
import fr.paris.lutece.portal.util.mvc.admin.annotations.Controller;
import fr.paris.lutece.portal.util.mvc.commons.annotations.Action;
import fr.paris.lutece.portal.util.mvc.commons.annotations.View;
import fr.paris.lutece.util.http.SecurityUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * This class provides the user interface to manage Identity features ( manage, create, modify, remove )
 */
@Controller( controllerJsp = "ManageIdentities.jsp", controllerPath = "jsp/admin/plugins/identitystore/", right = "IDENTITYSTORE_MANAGEMENT" )
public class IdentityJspBean extends ManageIdentitiesJspBean
{
    /**
     * 
     */
    private static final long serialVersionUID = 6053504380426222888L;

    // Templates
    private static final String TEMPLATE_SEARCH_IDENTITIES = "/admin/plugins/identitystore/search_identities.html";
    private static final String TEMPLATE_VIEW_IDENTITY = "/admin/plugins/identitystore/view_identity.html";
    private static final String TEMPLATE_VIEW_IDENTITY_DELETED = "/admin/plugins/identitystore/view_identity_deleted.html";
    private static final String TEMPLATE_VIEW_IDENTITY_HISTORY = "/admin/plugins/identitystore/view_identity_change_history.html";
    private static final String TEMPLATE_VIEW_IDENTITY_NOTIFICATIONS = "/admin/plugins/identitystore/view_identity_notifications.html";

    // jsp
    private static final String JSP_MANAGE_IDENTITIES = "jsp/admin/plugins/identitystore/ManageIdentities.jsp";

    // Parameters
    private static final String PARAMETER_ID_IDENTITY = "id";

    // Properties for page titles
    private static final String PROPERTY_PAGE_TITLE_MANAGE_IDENTITIES = "identitystore.manage_identities.pageTitle";
    private static final String PROPERTY_PAGE_TITLE_VIEW_IDENTITY = "identitystore.create_identity.pageTitle";
    private static final String PROPERTY_PAGE_TITLE_VIEW_CHANGE_HISTORY = "identitystore.view_change_history.pageTitle";
    private static final String PROPERTY_PAGE_TITLE_VIEW_NOTIFICATIONS = "identitystore.view_notifications.pageTitle";

    // Markers
    private static final String MARK_IDENTITY_LIST = "identity_list";
    private static final String MARK_IDENTITY = "identity";
    private static final String MARK_ATTRIBUTES = "attributes";
    private static final String MARK_MERGED_IDENTITIES = "merged_identities";
    private static final String MARK_IDENTITY_IS_SUSPICIOUS = "identity_is_suspicious";
    private static final String MARK_IDENTITY_CHANGE_LIST = "identity_change_list";
    private static final String MARK_ATTRIBUTES_CHANGE_LIST = "attributes_change_list";
    private static final String MARK_HAS_CREATE_ROLE = "createIdentityRole";
    private static final String MARK_HAS_MODIFY_ROLE = "modifyIdentityRole";
    private static final String MARK_HAS_DELETE_ROLE = "deleteIdentityRole";
    private static final String MARK_HAS_VIEW_ROLE = "viewIdentityRole";
    private static final String MARK_HAS_ATTRIBUTS_HISTO_ROLE = "histoAttributsRole";
    private static final String MARK_IDENTITY_NOTIFICATIONS_LIST = "demand_list";
    private static final String MARK_GENERIC_STATUS = "generic_status_list";
    private static final String MARK_INFOS_ARE_MISSING = "infos_are_missing";
    private static final String MARK_AT_LEAST_ONE_SC_FOUND = "at_least_one_service_contract_found";
    private static final String MARK_MASTER_CUID = "master_cuid";
    private static final String MARK_MASTER_CUID_MODIFICATION_DATE = "master_cuid_consolidation_date";
    private static final String MARK_DELETE_HISTORY = "delete_history";
    private static final String MARK_ACCOUNT_HISTORY = "account_history";

    // Views
    private static final String VIEW_MANAGE_IDENTITIES = "manageIdentitys";
    private static final String VIEW_IDENTITY = "viewIdentity";
    private static final String VIEW_IDENTITY_HISTORY = "viewIdentityHistory";
    private static final String VIEW_IDENTITY_NOTIFICATIONS = "viewIdentityNotifications";

    // Actions
    private static final String ACTION_EXPORT_IDENTITIES = "exportIdentities";
    private static final String ACTION_BATCH_GENERATE_REQUESTS = "exportRequestIdentities";

    // Events
    private static final String DISPLAY_IDENTITY_EVENT_CODE = "DISPLAY_IDENTITY";
    private static final String DISPLAY_IDENTITY_HISTORY_EVENT_CODE = "DISPLAY_HISTORY_IDENTITY";

    // Datasource
    private static final String DATASOURCE_DB = "db";
    private static final String DATASOURCE_ES = "es";
    private static final int BATCH_PARTITION_SIZE = AppPropertiesService.getPropertyInt( "identitystore.export.batch.size", 100 );
    private static final int PROPERTY_MAX_NB_IDENTITY_RETURNED = AppPropertiesService.getPropertyInt("identitystore.search.maxNbIdentityReturned", 0);
    private static final String RESOURCE_SEARCH_LINK = AppPropertiesService.getProperty("identitystore.search.resource.link", "");

    // Session variable to store working values
    private Identity _identity;

    private final List<IdentityDto> _identities = new ArrayList<>( );

    private final ISearchIdentityService _searchIdentityServiceDB = SpringContextService.getBean( "identitystore.searchIdentityService.database" );
    private final ISearchIdentityService _searchIdentityServiceES = SpringContextService.getBean( "identitystore.searchIdentityService.elasticsearch" );
    private final NotificationStoreService _notificationStoreService = SpringContextService.getBean( "notificationStore.notificationStoreService" );

    private final List<String> excludedAppCodes = Arrays
	    .asList( AppPropertiesService.getProperty( "daemon.purgeIdentityDaemon.excluded.app.codes", "" ).split( "," ) );

    private static final boolean GUID_SEARCH_EXTENDED_IN_HISTORY = AppPropertiesService.getPropertyBoolean("identitystore.identity.extend.guid.search.to.history", true );

    @View( value = VIEW_MANAGE_IDENTITIES, defaultView = true )
    public String getManageIdentitys( HttpServletRequest request )
    {
	_identity = null;
	_identities.clear( );
	final Map<String, String> queryParameters = this.getQueryParameters( request );

	final List<SearchAttribute> atttributes = new ArrayList<>( );
	final String cuid = queryParameters.get( QUERY_PARAM_CUID );
	final String guid = queryParameters.get( QUERY_PARAM_GUID );
	final String insee_city = queryParameters.get( QUERY_PARAM_INSEE_CITY );
	final String insee_country = queryParameters.get( QUERY_PARAM_INSEE_COUNTRY );
	final String email = queryParameters.get( QUERY_PARAM_EMAIL );
	final String gender = queryParameters.get( QUERY_PARAM_GENDER );
	final String common_name = queryParameters.get(QUERY_PARAM_COMMON_LASTNAME);
	final String first_name = queryParameters.get( QUERY_PARAM_FIRST_NAME );
	final String birthdate = queryParameters.get( QUERY_PARAM_BIRTHDATE );
	final String birthplace = queryParameters.get( QUERY_PARAM_INSEE_BIRTHPLACE_LABEL );
	final String birthcountry = queryParameters.get( QUERY_PARAM_INSEE_BIRTHCOUNTRY_LABEL );
	final String phone = queryParameters.get( QUERY_PARAM_PHONE );
	final String datasource = Optional.ofNullable( queryParameters.get( QUERY_PARAM_DATASOURCE ) ).orElse( DATASOURCE_DB );

	try
	{
	    if ( StringUtils.isNotEmpty( cuid ) )
	    {
		if ( datasource.equals( DATASOURCE_DB ) )
		{
		    final Identity identity = IdentityHome.findMasterIdentityByCustomerId( cuid, true );
		    if ( identity != null )
		    {
			final IdentityDto qualifiedIdentity = DtoConverter.convertIdentityToDto( identity );
			_identities.add( qualifiedIdentity );
		    }
		}
		else
		    if ( datasource.equals( DATASOURCE_ES ) )
		    {
			_identities.addAll( _searchIdentityServiceES.getQualifiedIdentities( cuid, Collections.emptyList() )
				.getQualifiedIdentities( ) );
		    }
	    }
	    else
	    {
		if ( StringUtils.isNotEmpty( guid ) )
		{
		    if ( datasource.equals( DATASOURCE_DB ) )
		    {
			final Identity identity = IdentityHome.findMasterIdentityByConnectionId( guid, true );
			if ( identity != null )
			{
			    final IdentityDto qualifiedIdentity = DtoConverter.convertIdentityToDto( identity );
			    _identities.add( qualifiedIdentity );
			}
			else if (GUID_SEARCH_EXTENDED_IN_HISTORY)
			{
				// If no identity was found with the current connection ID, search in the account history
				final List<Identity> identityList = IdentityHome.findMasterIdentitiesByOldConnectionId(guid, true);
				if ( !identityList.isEmpty( ) )
				{
					identityList.stream( ).map( DtoConverter::convertIdentityToDto ).forEach( _identities::add );
				}
			}
		    }
		    else
			if ( datasource.equals( DATASOURCE_ES ) )
			{
			    _identities.addAll( _searchIdentityServiceES.getQualifiedIdentitiesByConnectionId( guid, Collections.emptyList() )
				    .getQualifiedIdentities( ) );
			}
		}
		else
		{
		    if ( StringUtils.isNotEmpty( insee_city ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_BIRTH_PLACE_CODE, insee_city, AttributeTreatmentType.STRICT ) );
		    }
		    if ( StringUtils.isNotEmpty( insee_country ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_BIRTH_COUNTRY_CODE, insee_country, AttributeTreatmentType.STRICT ) );
		    }
		    if ( StringUtils.isNotEmpty( email ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_COMMON_EMAIL, email, AttributeTreatmentType.STRICT ) );
		    }
		    if ( StringUtils.isNotEmpty( gender ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_GENDER, gender, AttributeTreatmentType.STRICT ) );
		    }
		    if ( StringUtils.isNotEmpty( common_name ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_COMMON_LASTNAME, common_name, AttributeTreatmentType.APPROXIMATED ) );
		    }
		    if ( StringUtils.isNotEmpty( first_name ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_FIRST_NAME, first_name, AttributeTreatmentType.APPROXIMATED ) );
		    }
		    if ( StringUtils.isNotEmpty( birthdate ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_BIRTH_DATE, birthdate, AttributeTreatmentType.STRICT ) );
		    }
		    if ( StringUtils.isNotEmpty( birthplace ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_BIRTH_PLACE, birthplace, AttributeTreatmentType.APPROXIMATED ) );
		    }
		    if ( StringUtils.isNotEmpty( birthcountry ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_BIRTH_COUNTRY, birthcountry, AttributeTreatmentType.APPROXIMATED ) );
		    }
		    if ( StringUtils.isNotEmpty( phone ) )
		    {
			atttributes.add( new SearchAttribute( Constants.PARAM_COMMON_PHONE, phone, AttributeTreatmentType.STRICT ) );
		    }
		    if ( CollectionUtils.isNotEmpty( atttributes ) )
		    {
			if ( datasource.equals( DATASOURCE_DB ) )
			{
			    _identities.addAll( _searchIdentityServiceDB.getQualifiedIdentities( atttributes, PROPERTY_MAX_NB_IDENTITY_RETURNED, false, Collections.emptyList( ) )
				    .getQualifiedIdentities( ) );
			}
			else
			    if ( datasource.equals( DATASOURCE_ES ) )
			    {
				_identities.addAll( _searchIdentityServiceES.getQualifiedIdentities( atttributes, PROPERTY_MAX_NB_IDENTITY_RETURNED, false, Collections.emptyList( ) )
					.getQualifiedIdentities( ) );
			    }
		    }
		}
	    }
	}
	catch( Exception e )
	{
	    addError( e.getMessage( ) );
	    this.clearParameters( request );
	    return redirectView( request, VIEW_MANAGE_IDENTITIES );
	}

	_identities.forEach(
		qualifiedIdentity -> AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, IdentityService.SEARCH_IDENTITY_EVENT_CODE,
			getUser( ), SecurityUtil.logForgingProtect( qualifiedIdentity.getCustomerId( ) ), IdentityService.SPECIFIC_ORIGIN ) );

	final Map<String, Object> model = getPaginatedListModel( request, MARK_IDENTITY_LIST, _identities, JSP_MANAGE_IDENTITIES );
	model.put( MARK_HAS_CREATE_ROLE,
		IdentityManagementResourceIdService.isAuthorized( IdentityManagementResourceIdService.PERMISSION_CREATE_IDENTITY, getUser( ) ) );
	model.put( MARK_HAS_MODIFY_ROLE,
		IdentityManagementResourceIdService.isAuthorized( IdentityManagementResourceIdService.PERMISSION_MODIFY_IDENTITY, getUser( ) ) );
	model.put( MARK_HAS_DELETE_ROLE,
		IdentityManagementResourceIdService.isAuthorized( IdentityManagementResourceIdService.PERMISSION_DELETE_IDENTITY, getUser( ) ) );
	model.put( MARK_HAS_VIEW_ROLE,
		IdentityManagementResourceIdService.isAuthorized( IdentityManagementResourceIdService.PERMISSION_VIEW_IDENTITY, getUser( ) ) );

	model.put( QUERY_PARAM_CUID, cuid );
	model.put( QUERY_PARAM_GUID, guid );
	model.put( QUERY_PARAM_INSEE_CITY, insee_city );
	model.put( QUERY_PARAM_INSEE_COUNTRY, insee_country );
	model.put( QUERY_PARAM_COMMON_LASTNAME, common_name );
	model.put( QUERY_PARAM_FIRST_NAME, first_name );
	model.put( QUERY_PARAM_EMAIL, email );
	model.put( QUERY_PARAM_INSEE_BIRTHPLACE_LABEL, birthplace );
	model.put( QUERY_PARAM_INSEE_BIRTHCOUNTRY_LABEL, birthcountry );
	model.put( QUERY_PARAM_PHONE, phone );
	model.put( QUERY_PARAM_BIRTHDATE, birthdate );
	model.put( QUERY_PARAM_GENDER, gender );
	model.put( QUERY_PARAM_DATASOURCE, datasource );

	return getPage( PROPERTY_PAGE_TITLE_MANAGE_IDENTITIES, TEMPLATE_SEARCH_IDENTITIES, model );
    }

    /**
     * view identity
     *
     * @param request
     *            http request
     * @return The HTML form to view info
     */
     @View( VIEW_IDENTITY )
    public String getViewIdentity( HttpServletRequest request )
     {
	 final String cuid = request.getParameter( PARAMETER_ID_IDENTITY );

	 _identity = IdentityHome.findByCustomerId( cuid );
     if ( _identity == null )
     {
         // If the identity is not found via it's customer ID, it may be deleted
         final IdentityChange deleteHistory;
         try
         {
             deleteHistory = IdentityHome.findHistoryBySearchParameters( cuid, null, null, IdentityChangeType.DELETE, null, null, null, null, null, null, 1 )
                                         .stream( )
                                         .findFirst( )
                                         .orElse( null );
         }
         catch ( final IdentityStoreException e )
         {
             addError( e.getMessage( ) );
             return redirectView( request, VIEW_MANAGE_IDENTITIES );
         }
         if ( deleteHistory == null )
         {
             // If the identity is not deleted, error, redirect to the default view
             addError( "No existing identity for this customer ID" );
             return redirectView( request, VIEW_MANAGE_IDENTITIES );
         }
         final String filteredCustomerId = SecurityUtil.logForgingProtect( cuid );
         AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, DISPLAY_IDENTITY_EVENT_CODE, getUser( ), filteredCustomerId,
                                               IdentityService.SPECIFIC_ORIGIN );

         final Map<String, Object> model = getModel( );
         model.put( MARK_DELETE_HISTORY, deleteHistory );
         return getPage(PROPERTY_PAGE_TITLE_VIEW_IDENTITY, TEMPLATE_VIEW_IDENTITY_DELETED, model);
     }

	 final List<Identity> mergedIdentities = IdentityHome.findMergedIdentities(_identity.getId());

	 final String filteredCustomerId = SecurityUtil.logForgingProtect( _identity.getCustomerId( ) );
	 AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, DISPLAY_IDENTITY_EVENT_CODE, getUser( ), filteredCustomerId,
		 IdentityService.SPECIFIC_ORIGIN );

	 List<IdentityAttribute> attributes = sortIdentityttributes( );

	 final Map<String, Object> model = getModel( );
	 model.put( MARK_IDENTITY, _identity );
	 model.put( MARK_ATTRIBUTES, attributes );
	 model.put( MARK_MERGED_IDENTITIES, mergedIdentities );
	 model.put( MARK_IDENTITY_IS_SUSPICIOUS, SuspiciousIdentityHome.hasSuspicious( Collections.singletonList( _identity.getCustomerId( ) ) ) );
	 model.put( MARK_HAS_ATTRIBUTS_HISTO_ROLE,
		 IdentityManagementResourceIdService.isAuthorized( IdentityManagementResourceIdService.PERMISSION_ATTRIBUTS_HISTO, getUser( ) ) );
	 model.put( QUERY_PARAM_CUID_LINK, RESOURCE_SEARCH_LINK );

	 if( _identity.isMerged( ) )
	 {
		 final Identity masterIdentity = IdentityHome.findByPrimaryKey( _identity.getMasterIdentityId( ) );
		 if( masterIdentity != null )
		 {
			 model.put( MARK_MASTER_CUID, masterIdentity.getCustomerId( ) );
			 try
			 {
				 final List<IdentityChange> historyBySearchParameters = IdentityHome.findHistoryBySearchParameters( masterIdentity.getCustomerId( ), null, null,
						 IdentityChangeType.CONSOLIDATED, null, null, null, null, null, null, 1);
				 if( !historyBySearchParameters.isEmpty( ) )
				 {
					 final IdentityChange identityChange = historyBySearchParameters.get( 0 );
					 model.put( MARK_MASTER_CUID_MODIFICATION_DATE, identityChange.getModificationDate( ) );
				 }
			 } catch ( final Exception e )  {
				 this.addError( "Could not fetch consolidation history" );
			 }
		 }
	 }
	 if ( StringUtils.isNotBlank( _identity.getConnectionId( ) ) )
	 {
		 model.put( MARK_ACCOUNT_HISTORY, IdentityHome.selectFullIdentityAccountHistory( _identity.getId( ) ) );
	 }

	 return getPage( PROPERTY_PAGE_TITLE_VIEW_IDENTITY, TEMPLATE_VIEW_IDENTITY, model );
     }

     /**
      * Build the attribute history View
      *
      * @param request
      *            The HTTP request
      * @return The page
      */
     @View( value = VIEW_IDENTITY_HISTORY )
     public String getIdentityHistoryView( HttpServletRequest request )
     {
	 final String cuid = request.getParameter( PARAMETER_ID_IDENTITY );

	 if ( cuid != null && ( _identity == null || !_identity.getCustomerId( ).equals( cuid ) ) )
	 {
	     _identity = IdentityHome.findByCustomerId( cuid );
	 }

	 // here we use a LinkedHashMap to have same attributs order as in viewIdentity
	 final List<AttributeChange> attributeChangeList = new ArrayList<>( );
	 final List<IdentityChange> identityChangeList = new ArrayList<>( );

	 try
	 {
		 // If the identity is still null, we are most likely on a deleted identity. Fetch only the identity history
		 if ( _identity != null )
		 {
			 attributeChangeList.addAll( IdentityAttributeHome.getAttributeChangeHistory( _identity.getId( ) ) );
		 }
		 identityChangeList.addAll( IdentityHome.findHistoryByCustomerId( cuid ) );
	 }
	 catch( final IdentityStoreException e )
	 {
		 addError( e.getMessage( ) );
		 return getViewIdentity( request );
	 }

	 final String filteredCustomerId = SecurityUtil.logForgingProtect( cuid );
	 AccessLogService.getInstance( ).info( AccessLoggerConstants.EVENT_TYPE_READ, DISPLAY_IDENTITY_HISTORY_EVENT_CODE, getUser( ), filteredCustomerId,
		 IdentityService.SPECIFIC_ORIGIN );

	 final Map<String, Object> model = getModel( );
	 model.put( MARK_IDENTITY_CHANGE_LIST, identityChangeList );
	 model.put( MARK_ATTRIBUTES_CHANGE_LIST, attributeChangeList );

	 return getPage( PROPERTY_PAGE_TITLE_VIEW_CHANGE_HISTORY, TEMPLATE_VIEW_IDENTITY_HISTORY, model );
     }

     /**
      * Build the attribute history View
      *
      * @param request
      *            The HTTP request
      * @return The page
      * @throws NotificationException 
      */
     @View( value = VIEW_IDENTITY_NOTIFICATIONS )
     public String getIdentityNotificationsView( HttpServletRequest request )
     {
	 final String CUID = request.getParameter( PARAMETER_ID_IDENTITY );

	 if ( CUID != null && ( _identity == null || !_identity.getCustomerId( ).equals( CUID ) ) )
	 {
	     _identity = IdentityHome.findByCustomerId( CUID );
	 }

	 List<DemandDisplay> demandDisplayList = new ArrayList<>( );
	 Map<String,Boolean> indicators = new HashMap<>( );
	 indicators.put( PurgeIdentityService.KEY_AT_LEAST_ONE_CS_FOUND, false);
	 indicators.put( PurgeIdentityService.KEY_INFOS_ARE_MISSING, false);
	 StringBuilder msg = new StringBuilder( );

	 if ( _identity != null )
	 {
	     final List<Identity> mergedIdentities = IdentityHome.findMergedIdentities( _identity.getId( ) );

	     // Get Demands notifications associated to each identity or its merged ones
	     DemandResult demandResult;
	     try
	     {
		 demandResult = _notificationStoreService.getListDemand( _identity.getCustomerId( ), null, null, null, null );

		 demandDisplayList = demandResult.getListDemandDisplay() == null ? new ArrayList<>() : new ArrayList<>(demandResult.getListDemandDisplay());
		 for ( final Identity mergedIdentity : mergedIdentities )
		 {
		     List<DemandDisplay> mergedIdsDemands = _notificationStoreService.getListDemand( mergedIdentity.getCustomerId( ), null, null, null, null ).getListDemandDisplay( );
		     if ( mergedIdsDemands != null )
		     {
			 demandDisplayList.addAll( mergedIdsDemands );                  
		     }
		 }

		 for ( final DemandDisplay demand : demandDisplayList )
		 { 
		     final Timestamp expirationDateFromDemand = PurgeIdentityService.checkExpirationDateByDemand( demand, 
			     indicators, excludedAppCodes, msg, _notificationStoreService);

		     demand.setRegulatoryDateForIdentityRetention( expirationDateFromDemand );
		     demand.setAppCode( PurgeIdentityService.getAppCodeFromDemandTypeId( 
			     demand.getDemand( ).getTypeId( ), _notificationStoreService ) );   
		 }

	     } 
	     catch ( NotificationException | ClientAuthorizationException e )
	     {
		 AppLogService.error( "Error on Notification request", e );
		 addError( "Error on Notification request : " + e.getMessage( ) );
	     }
	 }

	 if ( msg.length( ) > 0 )
	 {
	     addWarning( msg.toString( ) );
	 }

	 final Map<String, Object> model = getModel( );
	 model.put( MARK_IDENTITY_NOTIFICATIONS_LIST, demandDisplayList );
	 model.put( MARK_GENERIC_STATUS, EnumGenericStatus.getGenericStatusAsMap( ) );
	 model.put( MARK_AT_LEAST_ONE_SC_FOUND, indicators.get( PurgeIdentityService.KEY_AT_LEAST_ONE_CS_FOUND ) );
	 model.put( MARK_INFOS_ARE_MISSING, indicators.get( PurgeIdentityService.KEY_INFOS_ARE_MISSING ) );

	 return getPage( PROPERTY_PAGE_TITLE_VIEW_NOTIFICATIONS, TEMPLATE_VIEW_IDENTITY_NOTIFICATIONS, model );
     }

     /**
      * Process the data capture form of a new suspiciousidentity
      *
      * @param request
      *            The Http Request
      * @return The Jsp URL of the process result
      * @throws AccessDeniedException
      */
     @Action( ACTION_EXPORT_IDENTITIES )
     public void doExportIdentities( HttpServletRequest request )
     {
	 try
	 {
	     final List<IdentityDto> identitiesToProcess = _identities.stream( ).filter( this::validateMinimumAttributes )
		     .peek( identityDto -> identityDto.setExternalCustomerId( UUID.randomUUID( ).toString( ) ) ).collect( Collectors.toList( ) );
	     final Batch<IdentityDto> batches = Batch.ofSize( identitiesToProcess, BATCH_PARTITION_SIZE );

	     final ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
	     final ZipOutputStream zipOut = new ZipOutputStream( outputStream );

	     int i = 0;
	     for ( final List<IdentityDto> batch : batches )
	     {
		 final byte [ ] bytes = CsvIdentityService.instance( ).write( batch );
		 final ZipEntry zipEntry = new ZipEntry( "identities-" + ++i + ".csv" );
		 zipEntry.setSize( bytes.length );
		 zipOut.putNextEntry( zipEntry );
		 zipOut.write( bytes );
	     }
	     zipOut.closeEntry( );
	     zipOut.close( );
	     this.download( outputStream.toByteArray( ), "identities.zip", "application/zip" );
	 }
	 catch( Exception e )
	 {
	     addError( e.getMessage( ) );
	     redirectView( request, VIEW_MANAGE_IDENTITIES );
	 }
     }

     private boolean validateMinimumAttributes( final IdentityDto identity )
     {
	 return this.checkAttributeExists( identity, Constants.PARAM_FAMILY_NAME ) && this.checkAttributeExists( identity, Constants.PARAM_FIRST_NAME )
		 && this.checkAttributeExists( identity, Constants.PARAM_BIRTH_DATE );
     }

     private boolean checkAttributeExists( final IdentityDto identity, final String attributeKey )
     {
	 return identity.getAttributes( ).stream( )
		 .anyMatch( attributeDto -> Objects.equals( attributeDto.getKey( ), attributeKey ) && StringUtils.isNotBlank( attributeDto.getValue( ) ) );
     }

     /**
      * Process the data capture form of a new suspiciousidentity
      *
      * @param request
      *            The Http Request
      * @return The Jsp URL of the process result
      * @throws AccessDeniedException
      */
     @Action( ACTION_BATCH_GENERATE_REQUESTS )
     public void doGenerateBatchIdentities( HttpServletRequest request )
     {
	 try
	 {
	     // Prepare identities for import (clear not used params)
	     _identities.forEach( identityDto -> {
		 identityDto.setExternalCustomerId( UUID.randomUUID( ).toString( ) );
		 identityDto.setCustomerId( null );
		 identityDto.setQuality( null );
		 identityDto.setExpiration( null );
		 identityDto.setMerge( null );
		 identityDto.setLastUpdateDate( null );
		 identityDto.setConnectionId( null );
		 identityDto.setMonParisActive( null );
		 identityDto.setCreationDate( null );
		 identityDto.setDuplicateDefinition( null );
		 identityDto.setSuspicious( null );
	     } );
	     final Batch<IdentityDto> batches = Batch.ofSize( _identities, BATCH_PARTITION_SIZE );

	     final ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
	     final ZipOutputStream zipOut = new ZipOutputStream( outputStream );

	     int i = 0;
	     final String reference = UUID.randomUUID( ).toString( );

	     final ObjectMapper mapper = new ObjectMapper( );
	     mapper.enable( SerializationFeature.INDENT_OUTPUT );
	     mapper.disable( DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES );

	     for ( final List<IdentityDto> batch : batches )
	     {
		 final BatchImportRequest batchImportRequest = new BatchImportRequest( );
		 batchImportRequest.setBatch( new BatchDto( ) );
		 batchImportRequest.getBatch( ).setReference( reference );
		 batchImportRequest.getBatch( ).setComment( "Batch exporté depuis identity store" );
		 batchImportRequest.getBatch( ).setCreationDate( Timestamp.from( Instant.now( ) ) );
		 batchImportRequest.getBatch( ).setUser( getUser( ).getEmail( ) );
		 batchImportRequest.getBatch( ).setAppCode( "TEST" );
		 batchImportRequest.getBatch( ).setIdentities( batch );
		 final ZipEntry zipEntry = new ZipEntry( "identities-" + ++i + ".json" );
		 final byte [ ] bytes = mapper.writeValueAsBytes( batchImportRequest );
		 zipEntry.setSize( bytes.length );
		 zipOut.putNextEntry( zipEntry );
		 zipOut.write( bytes );
	     }
	     zipOut.closeEntry( );
	     zipOut.close( );
	     this.download( outputStream.toByteArray( ), "identity_requests.zip", "application/zip" );
	 }
	 catch( Exception e )
	 {
	     addError( e.getMessage( ) );
	     redirectView( request, VIEW_MANAGE_IDENTITIES );
	 }
     }

     private List<IdentityAttribute> sortIdentityttributes( )
     {
	 if ( _identity != null )
	 {
	     final List<String> _sortedAttributeKeyList = Arrays.asList( AppPropertiesService.getProperty(IdentityConstants.PROPERTY_IDENTITY_ATTRIBUTE_ORDER, "" ).split( "," ) );
	     List<IdentityAttribute> valueList = new ArrayList<>(_identity.getAttributes( ).values());
	     valueList.sort( ( a1, a2 ) -> {
		 final int index1 = _sortedAttributeKeyList.indexOf( a1.getAttributeKey( ).getKeyName() );
		 final int index2 = _sortedAttributeKeyList.indexOf( a2.getAttributeKey( ).getKeyName() );
		 final int i1 = index1 == -1 ? 999 : index1;
		 final int i2 = index2 == -1 ? 999 : index2;
		 if ( i1 == i2 )
		 {
		     return a1.getAttributeKey( ).getKeyName().compareTo( a2.getAttributeKey( ).getKeyName() );
		 }
		 return Integer.compare( i1, i2 );
	     } );
	     return valueList;
	 }
	 return null;
     }
}
