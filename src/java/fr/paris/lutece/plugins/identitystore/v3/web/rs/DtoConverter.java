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
package fr.paris.lutece.plugins.identitystore.v3.web.rs;

import fr.paris.lutece.plugins.identitystore.business.application.ClientApplication;
import fr.paris.lutece.plugins.identitystore.business.attribute.AttributeCertificate;
import fr.paris.lutece.plugins.identitystore.business.attribute.AttributeKey;
import fr.paris.lutece.plugins.identitystore.business.attribute.AttributeValue;
import fr.paris.lutece.plugins.identitystore.business.attribute.KeyType;
import fr.paris.lutece.plugins.identitystore.business.contract.AttributeCertification;
import fr.paris.lutece.plugins.identitystore.business.contract.AttributeRequirement;
import fr.paris.lutece.plugins.identitystore.business.contract.AttributeRight;
import fr.paris.lutece.plugins.identitystore.business.contract.ServiceContract;
import fr.paris.lutece.plugins.identitystore.business.duplicates.suspicions.SuspiciousIdentityHome;
import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAccountHistory;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAttribute;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityHome;
import fr.paris.lutece.plugins.identitystore.business.referentiel.RefAttributeCertificationLevel;
import fr.paris.lutece.plugins.identitystore.business.referentiel.RefAttributeCertificationProcessus;
import fr.paris.lutece.plugins.identitystore.business.referentiel.RefCertificationLevel;
import fr.paris.lutece.plugins.identitystore.business.referentiel.RefCertificationLevelHome;
import fr.paris.lutece.plugins.identitystore.cache.IdentityAccountHistoryDtoCache;
import fr.paris.lutece.plugins.identitystore.cache.IdentityDtoCache;
import fr.paris.lutece.plugins.identitystore.service.attribute.IdentityAttributeService;
import fr.paris.lutece.plugins.identitystore.service.contract.AttributeCertificationDefinitionService;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.application.ClientApplicationDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeKeyDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeValueDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.ExpirationDefinition;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.IdentityAccountHistoryDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.IdentityDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.MergeDefinition;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.contract.AttributeDefinitionDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.contract.AttributeRequirementDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.contract.AttributeRightDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.contract.CertificationProcessusDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.contract.ServiceContractDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.referentiel.AttributeCertificationLevelDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.referentiel.AttributeCertificationProcessusDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.referentiel.LevelDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.util.Constants;
import fr.paris.lutece.plugins.identitystore.web.exception.ResourceNotFoundException;
import fr.paris.lutece.portal.service.spring.SpringContextService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 *
 * class to help managing rest feature
 *
 */
public final class DtoConverter
{

    private static final IdentityAccountHistoryDtoCache _identityAccountHistoryDtoCache =
            SpringContextService.getBean( "identitystore.identityAccountHistoryDtoCache" );

    /**
     * private constructor
     */
    private DtoConverter( )
    {
    }

    /**
     * returns a identityDto initialized from provided identity
     *
     * @param identity
     *            business identity to convert
     * @return identityDto initialized from provided identity
     */
    public static IdentityDto convertIdentityToDto( final Identity identity )
    {
        final IdentityDto identityDto = new IdentityDto( );
        identityDto.setConnectionId( identity.getConnectionId( ) );
        identityDto.setCustomerId( identity.getCustomerId( ) );
        identityDto.setLastUpdateDate( identity.getLastUpdateDate( ) );
        identityDto.setCreationDate( identity.getCreationDate( ) );
        identityDto.setDeleteDate( identity.getDeleteDate( ) );
        identityDto.setMonParisActive( identity.isMonParisActive( ) );

        if ( identity.isMerged( ) )
        {
            final MergeDefinition merge = new MergeDefinition( );
            merge.setMerged( identity.isMerged( ) );
            merge.setMergeDate( identity.getMergeDate( ) );
            if ( identity.getMasterIdentityId( ) != null && identity.getMasterIdentityId( ) > 0 )
            {
                merge.setMasterCustomerId( IdentityHome.findByPrimaryKey( identity.getMasterIdentityId( ) ).getCustomerId( ) );
            }
            identityDto.setMerge( merge );
        }

        if ( identity.getExpirationDate( ) != null || identity.isDeleted( ) || identity.getDeleteDate( ) != null )
        {
            final ExpirationDefinition expiration = new ExpirationDefinition( );
            expiration.setExpirationDate( identity.getExpirationDate( ) );
            expiration.setDeleted( identity.isDeleted( ) );
            expiration.setDeleteDate( identity.getDeleteDate( ) );
            identityDto.setExpiration( expiration );
        }

        identityDto.setSuspicious( SuspiciousIdentityHome.hasSuspicious( Collections.singletonList( identity.getCustomerId( ) ) ) );

        if ( MapUtils.isNotEmpty( identity.getAttributes( ) ) )
        {
            for ( final IdentityAttribute attribute : identity.getAttributes( ).values( ) )
            {
                identityDto.getAttributes( ).add( convertAttributeToDto( attribute ) );
            }
        }

        final List<IdentityAccountHistory> accountHistory =
                _identityAccountHistoryDtoCache.getFullIdentityAccountHistory( identity.getId( ), identity.getLastUpdateDate( ) );
        if ( accountHistory != null && !accountHistory.isEmpty( ) )
        {
            accountHistory.stream( ).map( DtoConverter::convertIdentityAccountHistoryToDto ).forEach( dto -> identityDto.getAccountHistory( ).add( dto ) );
        }

        return identityDto;
    }

    public static Identity convertDtoToIdentity( final IdentityDto dto )
    {
        final Identity identity = new Identity( );
        identity.setConnectionId( dto.getConnectionId( ) );
        identity.setCustomerId( dto.getCustomerId( ) );
        identity.setLastUpdateDate( dto.getLastUpdateDate( ) );
        identity.setMonParisActive( dto.isMonParisActive( ) );
        identity.setCreationDate( dto.getCreationDate( ) );

        if ( dto.getExpiration( ) != null )
        {
            identity.setDeleted( dto.getExpiration( ).isDeleted( ) );
            identity.setExpirationDate( dto.getExpiration( ).getExpirationDate( ) );
            identity.setDeleteDate( dto.getExpiration( ).getDeleteDate( ) );
        }

        if ( dto.getMerge( ) != null )
        {
            identity.setMerged( dto.isMerged( ) );
            identity.setMergeDate( dto.getMerge( ).getMergeDate( ) );
        }

        identity.getAttributes( ).putAll( dto.getAttributes( ).stream( ).map( DtoConverter::convertDtoToAttribute )
                .collect( Collectors.toMap( o -> o.getAttributeKey( ).getKeyName( ), o -> o ) ) );

        return identity;
    }

    private static AttributeDto convertAttributeToDto( final IdentityAttribute attribute )
    {
        final AttributeKey attributeKey = attribute.getAttributeKey( );

        final AttributeDto attributeDto = new AttributeDto( );
        attributeDto.setKey( attributeKey.getKeyName( ) );
        attributeDto.setValue( attribute.getValue( ) );
        attributeDto.setType( attributeKey.getKeyType( ).getCode( ) );
        attributeDto.setLastUpdateClientCode( attribute.getLastUpdateClientCode( ) );
        attributeDto.setLastUpdateDate( attribute.getLastUpdateDate( ) );

        if ( attribute.getCertificate( ) != null )
        {
            attributeDto.setCertifier( attribute.getCertificate( ).getCertifierCode( ) );
            attributeDto.setCertificationLevel( AttributeCertificationDefinitionService.instance( )
                    .getLevelAsInteger( attribute.getCertificate( ).getCertifierCode( ), attributeKey.getKeyName( ) ) );
            attributeDto.setCertificationDate( attribute.getCertificate( ).getCertificateDate( ) );

        }
        return attributeDto;
    }

    private static IdentityAttribute convertDtoToAttribute( final AttributeDto dto )
    {
        final IdentityAttribute attribute = new IdentityAttribute( );
        attribute.setValue( dto.getValue( ) );
        attribute.setLastUpdateClientCode( dto.getLastUpdateClientCode( ) );
        attribute.setLastUpdateDate( dto.getLastUpdateDate( ) );

        final AttributeKey attributeKey = new AttributeKey( );
        attributeKey.setKeyName( dto.getKey( ) );
        attributeKey.setKeyType( KeyType.valueByCode( dto.getType( ) ) );
        attribute.setAttributeKey( attributeKey );

        if ( dto.getCertificationDate( ) != null )
        {
            final AttributeCertificate certificate = new AttributeCertificate( );
            certificate.setCertificateDate( Timestamp.from( dto.getCertificationDate( ).toInstant( ) ) );
            certificate.setCertifierName( dto.getCertifier( ) );
            certificate.setCertifierCode( dto.getCertifier( ) );
            attribute.setCertificate( certificate );
        }

        return attribute;
    }

    /**
     * returns a serviceContractDto initialized from provided serviceContract
     *
     * @param serviceContract
     *            business service contract to convert
     * @return serviceContractDto initialized from provided serviceContract
     */
    public static ServiceContractDto convertContractToDto( final ServiceContract serviceContract )
    {
        final ServiceContractDto serviceContractDto = new ServiceContractDto( );
        serviceContractDto.setId( serviceContract.getId( ) );
        serviceContractDto.setClientCode( serviceContract.getClientCode( ) );
        serviceContractDto.setName( serviceContract.getName( ) );
        serviceContractDto.setServiceType( serviceContract.getServiceType( ) );
        serviceContractDto.setMoaContactName( serviceContract.getMoaContactName( ) );
        serviceContractDto.setMoaEntityName( serviceContract.getMoaEntityName( ) );
        serviceContractDto.setMoeResponsibleName( serviceContract.getMoeResponsibleName( ) );
        serviceContractDto.setMoeEntityName( serviceContract.getMoeEntityName( ) );
        serviceContractDto.setStartingDate( serviceContract.getStartingDate( ) );
        serviceContractDto.setEndingDate( serviceContract.getEndingDate( ) );
        serviceContractDto.setAuthorizedCreation( serviceContract.getAuthorizedCreation( ) );
        serviceContractDto.setAuthorizedUpdate( serviceContract.getAuthorizedUpdate( ) );
        serviceContractDto.setAuthorizedSearch( serviceContract.getAuthorizedSearch( ) );
        serviceContractDto.setAuthorizedAccountUpdate( serviceContract.getAuthorizedAccountUpdate( ) );
        serviceContractDto.setAuthorizedDeletion( serviceContract.getAuthorizedDeletion( ) );
        serviceContractDto.setAuthorizedExport( serviceContract.getAuthorizedExport( ) );
        serviceContractDto.setAuthorizedImport( serviceContract.getAuthorizedImport( ) );
        serviceContractDto.setAuthorizedMerge( serviceContract.getAuthorizedMerge( ) );
        serviceContractDto.setAuthorizedDecertification( serviceContract.getAuthorizedDecertification( ) );
        serviceContractDto.setAuthorizedAgentHistoryRead( serviceContract.getAuthorizedAgentHistoryRead( ) );
        serviceContractDto.setAuthorizedAttachementCertification( serviceContract.getAuthorizedAttachmentCertification( ) );
        serviceContractDto.setDataRetentionPeriodInMonths( serviceContract.getDataRetentionPeriodInMonths( ) );
        serviceContractDto.setCreationDate( serviceContract.getCreationDate( ) );
        serviceContractDto.setLastUpdateDate( serviceContract.getLastUpdateDate( ) );
        serviceContractDto.setAuthorName( serviceContract.getAuthorName( ) );

        final List<AttributeDefinitionDto> attributeDefinitions = new ArrayList<>( );

        for ( final AttributeRight attributeRight : serviceContract.getAttributeRights( ) )
        {
            final AttributeDefinitionDto attributeDefinitionDto = extractAttributeDefinition( attributeRight.getAttributeKey( ) );
            attributeDefinitionDto.setAttributeRight( new AttributeRightDto( ) );
            attributeDefinitionDto.getAttributeRight( ).setMandatory( attributeRight.isMandatory( ) );
            attributeDefinitionDto.getAttributeRight( ).setReadable( attributeRight.isReadable( ) );
            attributeDefinitionDto.getAttributeRight( ).setSearchable( attributeRight.isSearchable( ) );
            attributeDefinitionDto.getAttributeRight( ).setWritable( attributeRight.isWritable( ) );
            attributeDefinitions.add( attributeDefinitionDto );
        }

        for ( final AttributeCertification attributeCertification : serviceContract.getAttributeCertifications( ) )
        {
            AttributeDefinitionDto current = attributeDefinitions.stream( )
                    .filter( attributeDefinitionDto -> attributeDefinitionDto.getKeyName( ).equals( attributeCertification.getAttributeKey( ).getKeyName( ) ) )
                    .findFirst( ).orElse( null );
            if ( current == null )
            {
                current = extractAttributeDefinition( attributeCertification.getAttributeKey( ) );
                attributeDefinitions.add( current );
            }

            final List<CertificationProcessusDto> certificationProcesses = attributeCertification.getRefAttributeCertificationProcessus( ).stream( )
                    .map( ref -> {
                        final CertificationProcessusDto certificationProcessus = new CertificationProcessusDto( );
                        certificationProcessus.setCode( ref.getCode( ) );
                        certificationProcessus.setLabel( ref.getLabel( ) );
                        certificationProcessus.setLevel( ref.getLevel( ).getRefCertificationLevel( ).getLevel( ) );
                        return certificationProcessus;
                    } ).collect( Collectors.toList( ) );
            current.getAttributeCertifications( ).addAll( certificationProcesses );
        }

        // TODO améliorer car la remontée n'est pas optimale pour ce UC
        final List<AttributeRequirement> attributeRequirements = serviceContract.getAttributeRequirements( ).stream( )
                .filter( attributeRequirement -> attributeRequirement.getRefCertificationLevel( ).getLevel( ) != null ).collect( Collectors.toList( ) );
        for ( final AttributeRequirement attributeRequirement : attributeRequirements )
        {
            AttributeDefinitionDto current = attributeDefinitions.stream( )
                    .filter( attributeDefinitionDto -> attributeDefinitionDto.getKeyName( ).equals( attributeRequirement.getAttributeKey( ).getKeyName( ) ) )
                    .findFirst( ).orElse( null );
            if ( current == null )
            {
                current = extractAttributeDefinition( attributeRequirement.getAttributeKey( ) );
                attributeDefinitions.add( current );
            }
            final AttributeRequirementDto requirement = new AttributeRequirementDto( );
            requirement.setLevel( attributeRequirement.getRefCertificationLevel( ).getLevel( ) );
            requirement.setName( attributeRequirement.getRefCertificationLevel( ).getName( ) );
            requirement.setDescription( attributeRequirement.getRefCertificationLevel( ).getDescription( ) );
            current.setAttributeRequirement( requirement );
        }

        serviceContractDto.getAttributeDefinitions( ).addAll( attributeDefinitions );

        return serviceContractDto;
    }

    private static AttributeDefinitionDto extractAttributeDefinition( final AttributeKey attributeKey )
    {
        final AttributeDefinitionDto attributeDefinitionDto = new AttributeDefinitionDto( );
        attributeDefinitionDto.setName( attributeKey.getName( ) );
        attributeDefinitionDto.setKeyName( attributeKey.getKeyName( ) );
        attributeDefinitionDto.setDescription( attributeKey.getDescription( ) );
        attributeDefinitionDto.setType( AttributeType.valueOf( attributeKey.getKeyType( ).name( ) ) );
        attributeDefinitionDto.setCertifiable( attributeKey.getCertifiable( ) );
        attributeDefinitionDto.setPivot( attributeKey.getPivot( ) );
        attributeDefinitionDto.setKeyWeight( attributeKey.getKeyWeight( ) );
        attributeDefinitionDto.setMandatoryForCreation( attributeKey.isMandatoryForCreation( ) );
        attributeDefinitionDto.setValidationRegex( attributeKey.getValidationRegex( ) );
        attributeDefinitionDto.setValidationErrorMessage( attributeKey.getValidationErrorMessage( ) );
        attributeDefinitionDto.setValidationErrorMessageKey( attributeKey.getValidationErrorMessageKey( ) );
        attributeDefinitionDto.setValues( attributeKey.getAttributeValues( ).stream( ).map( DtoConverter::convertAttributeValueToDto ).collect( Collectors.toList( ) ) );
        return attributeDefinitionDto;
    }

    /**
     * returns a serviceContractDto initialized from provided serviceContractDto
     *
     * @param serviceContractDto
     *            business service contract to convert
     * @return serviceContractDto initialized from provided serviceContractDto
     */
    public static ServiceContract convertDtoToContract( final ServiceContractDto serviceContractDto ) throws ResourceNotFoundException
    {
        final ServiceContract serviceContract = new ServiceContract( );
        serviceContract.setId( serviceContractDto.getId( ) );
        serviceContract.setName( serviceContractDto.getName( ) );
        serviceContract.setServiceType( serviceContractDto.getServiceType( ) );
        serviceContract.setMoaContactName( serviceContractDto.getMoaContactName( ) );
        serviceContract.setMoaEntityName( serviceContractDto.getMoaEntityName( ) );
        serviceContract.setMoeResponsibleName( serviceContractDto.getMoeResponsibleName( ) );
        serviceContract.setMoeEntityName( serviceContractDto.getMoeEntityName( ) );
        serviceContract.setStartingDate( serviceContractDto.getStartingDate( ) );
        serviceContract.setEndingDate( serviceContractDto.getEndingDate( ) );
        serviceContract.setAuthorizedCreation( serviceContractDto.isAuthorizedCreation( ) );
        serviceContract.setAuthorizedUpdate( serviceContractDto.isAuthorizedUpdate( ) );
        serviceContract.setAuthorizedSearch( serviceContractDto.isAuthorizedSearch( ) );
        serviceContract.setAuthorizedAccountUpdate( serviceContractDto.isAuthorizedAccountUpdate( ) );
        serviceContract.setAuthorizedDeletion( serviceContractDto.isAuthorizedDeletion( ) );
        serviceContract.setAuthorizedExport( serviceContractDto.isAuthorizedExport( ) );
        serviceContract.setAuthorizedImport( serviceContractDto.isAuthorizedImport( ) );
        serviceContract.setAuthorizedMerge( serviceContractDto.isAuthorizedMerge( ) );
        serviceContract.setAuthorizedDecertification( serviceContractDto.isAuthorizedDecertification( ) );
        serviceContract.setAuthorizedAgentHistoryRead( serviceContractDto.isAuthorizedAgentHistoryRead( ) );
        serviceContract.setDataRetentionPeriodInMonths( serviceContractDto.getDataRetentionPeriodInMonths( ) );
        serviceContract.setCreationDate( serviceContractDto.getCreationDate( ) );
        serviceContract.setLastUpdateDate( serviceContractDto.getLastUpdateDate( ) );
        serviceContract.setAuthorName( serviceContractDto.getAuthorName( ) );

        for ( final AttributeDefinitionDto attributeDefinition : serviceContractDto.getAttributeDefinitions( ) )
        {
            final AttributeKey attributeKey = IdentityAttributeService.instance( ).getAttributeKey( attributeDefinition.getKeyName( ) );
            final AttributeRight attributeRight = new AttributeRight( );
            attributeRight.setMandatory( attributeDefinition.getAttributeRight( ).isMandatory( ) );
            attributeRight.setReadable( attributeDefinition.getAttributeRight( ).isReadable( ) );
            attributeRight.setWritable( attributeDefinition.getAttributeRight( ).isWritable( ) );
            attributeRight.setSearchable( attributeDefinition.getAttributeRight( ).isSearchable( ) );
            attributeRight.setAttributeKey( attributeKey );
            serviceContract.getAttributeRights( ).add( attributeRight );

            if ( attributeDefinition.getAttributeRequirement( ) != null )
            {
                final AttributeRequirement requirement = new AttributeRequirement( );
                requirement.setAttributeKey( attributeKey );
                final Optional<RefCertificationLevel> refCertificationLevel = RefCertificationLevelHome.getRefCertificationLevelsList( ).stream( )
                        .filter( level -> level.getLevel( ).equals( attributeDefinition.getAttributeRequirement( ).getLevel( ) ) ).findFirst( );
                requirement.setRefCertificationLevel( refCertificationLevel.orElseThrow( ( ) -> new ResourceNotFoundException(
                        "No certification level found with value " + attributeDefinition.getAttributeRequirement( ).getLevel( ),
                        Constants.PROPERTY_REST_ERROR_NO_CERTIFICATION_LEVEL_FOUND ) ) );
                serviceContract.getAttributeRequirements( ).add( requirement );
            }

            if ( CollectionUtils.isNotEmpty( attributeDefinition.getAttributeCertifications( ) ) )
            {
                final AttributeCertification certification = new AttributeCertification( );
                certification.setAttributeKey( attributeKey );
                serviceContract.getAttributeCertifications( ).add( certification );
                for ( final CertificationProcessusDto attributeCertification : attributeDefinition.getAttributeCertifications( ) )
                {
                    final RefAttributeCertificationLevel refAttributeCertificationLevel = AttributeCertificationDefinitionService.instance( )
                            .get( attributeCertification.getCode( ), attributeKey.getKeyName( ) );
                    if ( refAttributeCertificationLevel == null )
                    {
                        throw new ResourceNotFoundException(
                                "No processus could be found with code " + attributeCertification.getCode( ) + " for attribute " + attributeKey.getKeyName( ),
                                Constants.PROPERTY_REST_ERROR_NO_CERTIFICATION_PROCESSUS_FOUND );
                    }
                    certification.getRefAttributeCertificationProcessus( ).add( refAttributeCertificationLevel.getRefAttributeCertificationProcessus( ) );
                }
            }

        }

        return serviceContract;
    }

    public static ClientApplicationDto convertClientToDto( final ClientApplication clientApplication )
    {
        final ClientApplicationDto dto = new ClientApplicationDto( );
        dto.setId( clientApplication.getId( ) );
        dto.setName( clientApplication.getName( ) );
        dto.setClientCode( clientApplication.getClientCode( ) );
        dto.setApplicationCode( clientApplication.getApplicationCode( ) );
        return dto;
    }

    public static ClientApplication convertDtoToClient( final ClientApplicationDto clientApplicationDto )
    {
        final ClientApplication clientApplication = new ClientApplication( );
        clientApplication.setId( clientApplicationDto.getId( ) );
        clientApplication.setName( clientApplicationDto.getName( ) );
        clientApplication.setClientCode( clientApplicationDto.getClientCode( ) );
        clientApplication.setApplicationCode( clientApplicationDto.getApplicationCode( ) );
        return clientApplication;
    }

    public static List<LevelDto> convertRefLevelsToListDto( List<RefCertificationLevel> refCertificationLevelsList )
    {
        final List<LevelDto> dtos = new ArrayList<>( );
        for ( final RefCertificationLevel refCertificationLevel : refCertificationLevelsList )
        {
            final LevelDto levelDto = new LevelDto( );
            levelDto.setLevel( refCertificationLevel.getLevel( ) );
            levelDto.setName( refCertificationLevel.getName( ) );
            levelDto.setDescription( refCertificationLevel.getDescription( ) );
            dtos.add( levelDto );
        }
        return dtos;
    }

    public static AttributeCertificationProcessusDto convertProcessusToDto( RefAttributeCertificationProcessus processus,
            List<RefAttributeCertificationLevel> refAttributeCertificationLevels )
    {
        final AttributeCertificationProcessusDto dto = new AttributeCertificationProcessusDto( );
        dto.setCode( processus.getCode( ) );
        dto.setLabel( processus.getLabel( ) );
        for ( final RefAttributeCertificationLevel refAttributeCertificationLevel : refAttributeCertificationLevels )
        {
            if ( StringUtils.isNotEmpty( refAttributeCertificationLevel.getRefCertificationLevel( ).getLevel( ) ) )
            {
                final AttributeCertificationLevelDto levelDto = new AttributeCertificationLevelDto( );
                levelDto.setAttributeKey( refAttributeCertificationLevel.getAttributeKey( ).getKeyName( ) );
                final LevelDto level = new LevelDto( );
                level.setDescription( refAttributeCertificationLevel.getRefCertificationLevel( ).getDescription( ) );
                level.setLevel( refAttributeCertificationLevel.getRefCertificationLevel( ).getLevel( ) );
                level.setName( refAttributeCertificationLevel.getRefCertificationLevel( ).getName( ) );
                levelDto.setLevel( level );
                dto.getAttributeCertificationLevels( ).add( levelDto );
            }
        }
        return dto;
    }

    public static List<AttributeKeyDto> convertRefAttributesToListDto( List<AttributeKey> allAtributeKeys )
    {
        return allAtributeKeys.stream( ).map( DtoConverter::convertRefAttributeToDto ).collect( Collectors.toList( ) );
    }

    public static AttributeKeyDto convertRefAttributeToDto( AttributeKey attributeKey )
    {
        final AttributeKeyDto dto = new AttributeKeyDto( );
        dto.setCertifiable( attributeKey.getCertifiable( ) );
        dto.setDescription( attributeKey.getDescription( ) );
        dto.setKeyName( attributeKey.getKeyName( ) );
        dto.setName( attributeKey.getName( ) );
        dto.setKeyWeight( attributeKey.getKeyWeight( ) );
        dto.setPivot( attributeKey.getPivot( ) );
        dto.setType( AttributeType.valueOf( attributeKey.getKeyType( ).name( ) ) );
        dto.setValidationRegex( attributeKey.getValidationRegex( ) );
        dto.setMandatoryForCreation( attributeKey.isMandatoryForCreation( ) );
        dto.setValidationErrorMessage( attributeKey.getValidationErrorMessage( ) );
        dto.setValidationErrorMessageKey( attributeKey.getValidationErrorMessageKey( ) );
        dto.setValues( attributeKey.getAttributeValues( ).stream( ).map( DtoConverter::convertAttributeValueToDto ).collect( Collectors.toList( ) ) );
        return dto;
    }

    public static AttributeValueDto convertAttributeValueToDto( final AttributeValue attributeValue )
    {
        final AttributeValueDto valueDto = new AttributeValueDto( );
        valueDto.setValue( attributeValue.getValue( ) );
        valueDto.setLabel( attributeValue.getLabel( ) );
        return valueDto;
    }

    public static IdentityAccountHistoryDto convertIdentityAccountHistoryToDto( final IdentityAccountHistory identityAccountHistory )
    {
        final IdentityAccountHistoryDto dto = new IdentityAccountHistoryDto( );
        dto.setConnectionId( identityAccountHistory.getConnectionId( ) );
        dto.setDeletionDate( identityAccountHistory.getDeletionDate( ) );
        dto.setCreationDate( identityAccountHistory.getCreationDate( ) );
        return dto;
    }
}
