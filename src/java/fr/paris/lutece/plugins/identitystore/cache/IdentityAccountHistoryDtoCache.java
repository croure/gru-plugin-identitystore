package fr.paris.lutece.plugins.identitystore.cache;

import fr.paris.lutece.plugins.identitystore.business.identity.IdentityAccountHistory;
import fr.paris.lutece.plugins.identitystore.business.identity.IdentityHome;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.IdentityDto;
import fr.paris.lutece.portal.service.cache.AbstractCacheableService;
import fr.paris.lutece.portal.service.util.AppLogService;

import java.sql.Timestamp;
import java.util.List;
import java.util.Objects;

public class IdentityAccountHistoryDtoCache extends AbstractCacheableService {

    public static final String SERVICE_NAME = "IdentityAccountHistoryCache";

    public IdentityAccountHistoryDtoCache( )
    {
        this.initCache( );
    }

    public void refresh( )
    {
        AppLogService.debug( "Init Identity Account History cache" );
        this.resetCache( );
    }

    /**
     * Adds the full identity account history to the cache with the following key: <code>${identityId}|${identityLastUpdateDate}</code>
     * @param accountHistory the full account history to store
     * @param identityId the identity ID
     * @param lastUpdateDateFromDb the identity version timestamp
     */
    private void put(final List<IdentityAccountHistory> accountHistory, final int identityId, final Timestamp lastUpdateDateFromDb )
    {
        final String cacheKey = this.computeCacheKey( identityId, lastUpdateDateFromDb );
        if ( this.getKeys( ).contains( cacheKey ) )
        {
            this.removeKey( cacheKey );
        }
        this.putInCache( cacheKey, accountHistory );
        AppLogService.debug( "Identity account history added to cache: " + cacheKey );
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
        AppLogService.debug( "Identity account history removed from cache: " + cacheKey );
    }

    /**
     * Retrieve the identity full account history
     * @param identityId - the identity ID
     * @param identityLastUpdateDate - the identity last update date
     */
    public List<IdentityAccountHistory> getFullIdentityAccountHistory( final int identityId, final Timestamp identityLastUpdateDate )
    {
        final String cacheKey = this.computeCacheKey( identityId, identityLastUpdateDate );
        final List<IdentityAccountHistory> fullAccountHistoryFromCache = ( List<IdentityAccountHistory> ) this.getFromCache( cacheKey );
        if ( fullAccountHistoryFromCache == null || fullAccountHistoryFromCache.isEmpty( ) )
        {
            this.remove( cacheKey );
            final List<IdentityAccountHistory> fullAccountHistoryFromDb = this.getFromDatabase( identityId );
            if ( fullAccountHistoryFromDb == null || fullAccountHistoryFromDb.isEmpty( ) )
            {
                return List.of();
            }
            this.put( fullAccountHistoryFromDb, identityId, identityLastUpdateDate );
            return fullAccountHistoryFromDb;
        }
        return fullAccountHistoryFromCache;
    }

    /**
     * Retrieve the identity full account history from database
     * @param identityId - the identity ID
     */
    private List<IdentityAccountHistory> getFromDatabase( final int identityId )
    {
        final List<IdentityAccountHistory> accountHistory = IdentityHome.selectFullIdentityAccountHistory(identityId);
        if ( accountHistory == null || accountHistory.isEmpty( ) )
        {
            return null;
        }
        return accountHistory;
    }

    /**
     * Compute the cache key as following: <code>${identityId}|${identityLastUpdateDate}</code>
     * @param identityId the ID of the identity
     * @param lastUpdateDateFromDb the identity version timestamp
     * @return the computed key
     */
    private String computeCacheKey( final int identityId, final Timestamp lastUpdateDateFromDb )
    {
        return String.format( "%d|%d", identityId, lastUpdateDateFromDb.getTime( ) );
    }

    @Override
    public String getName() {
        return SERVICE_NAME;
    }
}
