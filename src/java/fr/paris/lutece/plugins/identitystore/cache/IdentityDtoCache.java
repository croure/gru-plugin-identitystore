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
package fr.paris.lutece.plugins.identitystore.cache;

import fr.paris.lutece.plugins.identitystore.business.contract.ServiceContract;
import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityHome;
import fr.paris.lutece.plugins.identitystore.service.identity.IdentityQualityService;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.DtoConverter;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.IdentityDto;
import fr.paris.lutece.portal.service.cache.AbstractCacheableService;
import fr.paris.lutece.portal.service.util.AppLogService;
import org.apache.commons.lang3.StringUtils;

import java.sql.Timestamp;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * Cache sur les requêtes d'identité (par <code>${customerId}</code> ou <code>${connectionId}</code>), qui cache :
 * <ul>
 * <li>Les attributs autorisés en lecture, définis dans le contrat de service</li>
 * <li>Le score de qualité</li>
 * <li>Le score de couverture</li>
 * <li>Les données de suspicions de doublons si l'identité est marquée comme suspecte</li>
 * <li>Les données d'exclusion si l'identité a été exclue d'une ou plusieurs suspicions de doublon avec d'autres identités</li>
 * </ul>
 * <br>
 * L'identité elle-même sera récupérée de la DB à chaque fois, afin de vérifier la date de dernière modification :<br/>
 * <ul>
 * <li>Si la date est la même dans l'objet caché et en DB, l'objet caché est retourné</li>
 * <li>Sinon, on supprime l'objet caché du cache, on récupère toutes les infos de la DB et on recache.</li>
 * </ul>
 * La clé de cache est calculée comme suit: <code>${customerId}|${serviceContractId}|${timestamp}</code>
 */
public class IdentityDtoCache extends AbstractCacheableService
{
    public static final String SERVICE_NAME = "IdentityCache";

    public IdentityDtoCache( )
    {
        this.initCache( );
    }

    public void refresh( )
    {
        AppLogService.debug( "Init Identity cache" );
        this.resetCache( );
    }

    /**
     * Add an identity to the cache with the following key: <code>${cuid}|${serviceContractId}|${timestamp}</code>
     * @param identity the identity to store
     * @param serviceContractId the service contract of the client
     * @param lastUpdateDateFromDb the identity version timestamp
     */
    private void put( final IdentityDto identity, final int serviceContractId, final Timestamp lastUpdateDateFromDb )
    {
        final String cacheKey = this.computeCacheKey( identity.getCustomerId( ), serviceContractId, lastUpdateDateFromDb );
        if ( this.getKeys( ).contains( cacheKey ) )
        {
            this.removeKey( cacheKey );
        }
        this.putInCache( cacheKey, identity );
        AppLogService.debug( "Identity added to cache: " + cacheKey );
    }

    /**
     * Delete the given cacheKey from the cache
     * @param cacheKey the key to delete
     */
    private void remove( final String cacheKey )
    {
        if ( this.getKeys( ).contains( cacheKey ) )
        {
            this.removeKey( cacheKey );
        }
        AppLogService.debug( "Identity removed from cache: " + cacheKey );
    }

    /**
     * Get the master identity from a given <code>connectionId</code>. The master identity is search recursively over the <code>masterIdentityId</code>.
     * It means that id identity A is merged into identity B, if A is found with the given <code>connectionId</code>, it will return B.
     * @param connectionId the connection ID to search for
     * @param serviceContract the client service contract
     * @return the master @{@link IdentityDto} found or <code>null</code> if no match
     */
    public IdentityDto getMasterIdentityByConnectionId( final String connectionId, final ServiceContract serviceContract )
    {
        final Identity identity = IdentityHome.findMasterIdentityByConnectionId( connectionId, false );
        if ( identity == null || StringUtils.isBlank( identity.getCustomerId( ) ) || identity.getLastUpdateDate( ) == null )
        {
            return null;
        }
        return this.get( identity.getCustomerId( ), identity.getLastUpdateDate( ), serviceContract );
    }

    /**
     * Get the master identities from a given old <code>connectionId</code>.
     * This means the given <code>connectionId</code> is not the identities current <code>connectionId</code>, but must be present in their account history.
     * The master identity is search recursively over the <code>masterIdentityId</code>.
     * It means that if identity A is merged into identity B, if A is found with the given old <code>connectionId</code>, it will return B.
     * @param connectionId the old connection ID to search for
     * @param serviceContract the client service contract
     * @return the master {@link IdentityDto} found or <code>null</code> if no match
     */
    public List<IdentityDto> getMasterIdentitiesByOldConnectionId( final String connectionId, final ServiceContract serviceContract )
    {
        final List<Identity> identityList = IdentityHome.findMasterIdentitiesByOldConnectionId(connectionId, false).stream()
                .filter(i -> i != null && StringUtils.isNotBlank(i.getCustomerId()) && i.getLastUpdateDate() != null).collect(Collectors.toList());
        if ( identityList.isEmpty( ) )
        {
            return List.of( );
        }
        return identityList.stream().map(i -> this.get( i.getCustomerId( ), i.getLastUpdateDate( ), serviceContract ) ).collect(Collectors.toList());
    }

    /**
     * Get the master identity from a given <code>customerId</code>. The master identity is search recursively over the <code>masterIdentityId</code>.
     * It means that id identity A is merged into identity B, if A is found with the given <code>customerId</code>, it will return B.
     * @param customerId the customerId ID to search for
     * @param serviceContract the client service contract
     * @return the master @{@link IdentityDto} found or <code>null</code> if no match
     */
    public IdentityDto getMasterIdentityByCustomerId( final String customerId, final ServiceContract serviceContract )
    {
        final Identity identity = IdentityHome.findMasterIdentityByCustomerId( customerId, false );
        if ( identity == null || StringUtils.isBlank( identity.getCustomerId( ) ) || identity.getLastUpdateDate( ) == null )
        {
            return null;
        }
        return this.get( identity.getCustomerId( ), identity.getLastUpdateDate( ), serviceContract );
    }

    /**
     * Get the identity from a given <code>customerId</code>, even if the identity is merged.
     * @param customerId the customerId ID to search for
     * @param serviceContract the client service contract
     * @return the @{@link IdentityDto} found or <code>null</code> if no match
     */
    public IdentityDto getIdentityByCustomerId( final String customerId, final ServiceContract serviceContract )
    {
        final Identity identity = IdentityHome.findByCustomerId( customerId, false );
        if ( identity == null || StringUtils.isBlank( identity.getCustomerId( ) ) || identity.getLastUpdateDate( ) == null )
        {
            return null;
        }
        return this.get( identity.getCustomerId( ), identity.getLastUpdateDate( ), serviceContract );
    }

    /**
     * Get the identity from the cache based on the given <code>customerId</code>, <code>lastUpdateDateFromDb</code> and <code>serviceContract</code>.
     * If the identity is in the cache, it is returned directly. If not, it is fetched from the database, stored in the cache, and then returned.
     * @param customerId the customerId ID to search for
     * @param lastUpdateDateFromDb the version timestamp of the identity to find
     * @param serviceContract the client service contract
     * @return the @{@link IdentityDto} found or <code>null</code> if no match
     */
    private IdentityDto get( final String customerId, final Timestamp lastUpdateDateFromDb, final ServiceContract serviceContract )
    {
        final String cacheKey = this.computeCacheKey( customerId, serviceContract.getId( ), lastUpdateDateFromDb );
        final IdentityDto identityDtoFromCache = (IdentityDto) this.getFromCache( cacheKey );
        if ( identityDtoFromCache == null || !Objects.equals( identityDtoFromCache.getLastUpdateDate( ), lastUpdateDateFromDb ) )
        {
            this.remove( cacheKey );
            final IdentityDto enrichedIdentity = this.getFromDatabaseAndEnrich( customerId, serviceContract );
            if ( enrichedIdentity == null )
            {
                return null;
            }
            this.put( enrichedIdentity, serviceContract.getId( ), lastUpdateDateFromDb );
            return enrichedIdentity;
        }
        return identityDtoFromCache;
    }

    /**
     * Get the master identity from the database and enrich it with quality information.
     * @param customerId the customerId ID to search for
     * @param serviceContract the client service contract
     * @return the @{@link IdentityDto} found or <code>null</code> if no match
     */
    public IdentityDto getFromDatabaseAndEnrich( final String customerId, final ServiceContract serviceContract )
    {
        final Identity identity = IdentityHome.findMasterIdentityByCustomerId( customerId, true );
        if ( identity == null )
        {
            return null;
        }
        return this.convertAndEnrich( identity, serviceContract );
    }

    /**
     * Compute quality information based on the <code>identity</code> and the <code>service contract</code>
     * @param identity the identity to enrich
     * @param serviceContract the client service contract
     * @return the enriched @{@link IdentityDto}
     */
    private IdentityDto convertAndEnrich( final Identity identity, final ServiceContract serviceContract )
    {
        final IdentityDto identityDto = DtoConverter.convertIdentityToDto( identity );
        IdentityQualityService.instance( ).enrich( null, identityDto, serviceContract, identity );
        return identityDto;
    }

    /**
     * Compute the cache key as following: <code>${cuid}|${serviceContractId}|${timestamp}</code>
     * @param customerId the customerId ID to search for
     * @param serviceContractId the ID of the client service contract
     * @param lastUpdateDate the identity version timestamp
     * @return the computed key
     */
    private String computeCacheKey( final String customerId, final int serviceContractId, final Timestamp lastUpdateDate )
    {
        return String.format( "%s|%s|%d", customerId, serviceContractId, lastUpdateDate.getTime( ) );
    }

    @Override
    public String getName( )
    {
        return SERVICE_NAME;
    }
}
