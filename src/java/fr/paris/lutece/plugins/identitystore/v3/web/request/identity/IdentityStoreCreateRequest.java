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
package fr.paris.lutece.plugins.identitystore.v3.web.request.identity;

import fr.paris.lutece.plugins.identitystore.business.contract.ServiceContract;
import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.service.attribute.IdentityAttributeFormatterService;
import fr.paris.lutece.plugins.identitystore.service.attribute.IdentityAttributeGeocodesAdjustmentService;
import fr.paris.lutece.plugins.identitystore.service.contract.ServiceContractService;
import fr.paris.lutece.plugins.identitystore.service.identity.IdentityService;
import fr.paris.lutece.plugins.identitystore.v3.web.request.AbstractIdentityStoreAppCodeRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.request.validator.IdentityAttributeValidator;
import fr.paris.lutece.plugins.identitystore.v3.web.request.validator.IdentityChangeRequestValidator;
import fr.paris.lutece.plugins.identitystore.v3.web.request.validator.IdentityDuplicateValidator;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.IdentityRequestValidator;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeChangeStatus;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeStatus;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.ResponseStatus;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.crud.IdentityChangeRequest;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.crud.IdentityChangeResponse;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.util.Constants;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.util.ResponseStatusFactory;
import fr.paris.lutece.plugins.identitystore.web.exception.ClientAuthorizationException;
import fr.paris.lutece.plugins.identitystore.web.exception.DuplicatesConsistencyException;
import fr.paris.lutece.plugins.identitystore.web.exception.IdentityStoreException;
import fr.paris.lutece.plugins.identitystore.web.exception.RequestContentFormattingException;
import fr.paris.lutece.plugins.identitystore.web.exception.RequestFormatException;
import fr.paris.lutece.plugins.identitystore.web.exception.ResourceConsistencyException;
import fr.paris.lutece.plugins.identitystore.web.exception.ResourceNotFoundException;
import fr.paris.lutece.portal.business.datastore.DataEntity;
import fr.paris.lutece.portal.business.datastore.DataEntityHome;
import fr.paris.lutece.portal.service.util.AppPropertiesService;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * This class represents a create request for IdentityStoreRestServive
 */
public class IdentityStoreCreateRequest extends AbstractIdentityStoreAppCodeRequest
{
    private static final String PROPERTY_CHECK_LOGIN_UNIQUENESS = "identitystore.identity.check_login_uniqueness";;

    private final boolean controlsOnly;

    private final IdentityChangeRequest _identityChangeRequest;
    private final List<AttributeStatus> formatStatuses;
    private ServiceContract serviceContract;

    /**
     * Constructor of IdentityStoreCreateRequest
     * 
     * @param identityChangeRequest
     *            the dto of identity's change
     */
    public IdentityStoreCreateRequest( final IdentityChangeRequest identityChangeRequest, final String strClientCode, final String strAppCode,
            final String authorName, final String authorType ) throws IdentityStoreException
    {
        this(identityChangeRequest, strClientCode, strAppCode, authorName, authorType, false);
    }

    public IdentityStoreCreateRequest( final IdentityChangeRequest identityChangeRequest, final String strClientCode, final String strAppCode,
                                       final String authorName, final String authorType, final boolean controlsOnly ) throws IdentityStoreException
    {
        super( strClientCode, strAppCode, authorName, authorType );
        this._identityChangeRequest = identityChangeRequest;
        this.controlsOnly = controlsOnly;
        this.formatStatuses = new ArrayList<>( );
    }

    @Override
    protected void fetchResources( ) throws ResourceNotFoundException, ClientAuthorizationException {
        serviceContract = ServiceContractService.instance( ).getActiveServiceContract( _strClientCode );
    }

    @Override
    protected void validateRequestFormat( ) throws RequestFormatException
    {
        IdentityRequestValidator.instance( ).checkIdentityChange( _identityChangeRequest, false );
        IdentityAttributeValidator.instance( ).checkAttributeExistence( _identityChangeRequest.getIdentity( ) );
        IdentityChangeRequestValidator.instance( ).checkRequiredAttributesForCreation( _identityChangeRequest, serviceContract );
        IdentityAttributeValidator.instance( ).validatePivotAttributesIntegrity( null, _identityChangeRequest.getIdentity( ), true );
    }

    @Override
    protected void validateClientAuthorization( ) throws ClientAuthorizationException
    {
        ServiceContractService.instance( ).validateCreateAuthorization( _identityChangeRequest, serviceContract );
    }

    @Override
    protected void validateResourcesConsistency( ) throws ResourceConsistencyException
    {
        // do nothing because CREATE request does not update any resource
    }

    @Override
    protected void formatRequestContent( ) throws RequestContentFormattingException
    {
        formatStatuses.addAll( IdentityAttributeFormatterService.instance( ).formatIdentityChangeRequestAttributeValues( _identityChangeRequest ) );
        formatStatuses.addAll( IdentityAttributeGeocodesAdjustmentService.instance( ).adjustGeocodesAttributes( _identityChangeRequest ) );
        IdentityAttributeValidator.instance( ).validateIdentityAttributeValues( _identityChangeRequest.getIdentity( ) );
    }

    @Override
    protected void checkDuplicatesConsistency( ) throws DuplicatesConsistencyException
    {
        IdentityDuplicateValidator.instance( ).checkConnectionIdUniquenessForCreate( _identityChangeRequest );
        IdentityDuplicateValidator.instance( ).checkDuplicateExistenceForCreation( _identityChangeRequest );
        if ( AppPropertiesService.getPropertyBoolean( PROPERTY_CHECK_LOGIN_UNIQUENESS, false ) )
        {
            IdentityDuplicateValidator.instance( ).checkLoginUniquenessForCreate( _identityChangeRequest );
        }
    }

    @Override
    protected IdentityChangeResponse doSpecificRequest( ) throws IdentityStoreException
    {
        final IdentityChangeResponse response = new IdentityChangeResponse( );
        if (controlsOnly) {
            // if we are here, it means that all the controls were successful.
            response.setStatus( ResponseStatusFactory.success( ).setAttributeStatuses( formatStatuses ).setMessageKey( Constants.PROPERTY_REST_INFO_SUCCESSFUL_OPERATION ) );
            return response;
        }

        final Pair<Identity, List<AttributeStatus>> result = IdentityService.instance( ).create( _identityChangeRequest, _author, serviceContract,
                formatStatuses );
        final Identity createdIdentity = result.getKey( );
        final List<AttributeStatus> attrStatusList = result.getValue( );
        attrStatusList.addAll( formatStatuses );

        response.setCustomerId( createdIdentity.getCustomerId( ) );
        response.setCreationDate( createdIdentity.getCreationDate( ) );
        response.setConnectionId( createdIdentity.getConnectionId( ) );

        final boolean incompleteCreation = attrStatusList.stream( ).anyMatch( s -> s.getStatus( ).equals( AttributeChangeStatus.NOT_CREATED ) );
        final ResponseStatus status = incompleteCreation ? ResponseStatusFactory.incompleteSuccess( ) : ResponseStatusFactory.success( );
        response.setStatus( status.setAttributeStatuses( attrStatusList ).setMessageKey( Constants.PROPERTY_REST_INFO_SUCCESSFUL_OPERATION ) );

        return response;
    }

}
