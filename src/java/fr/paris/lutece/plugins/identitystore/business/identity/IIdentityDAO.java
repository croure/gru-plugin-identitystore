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
package fr.paris.lutece.plugins.identitystore.business.identity;

import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.crud.UpdatedIdentityDto;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChange;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChangeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.SearchAttribute;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.search.SearchUpdatedAttribute;
import fr.paris.lutece.plugins.identitystore.web.exception.IdentityStoreException;
import fr.paris.lutece.portal.service.plugin.Plugin;
import org.apache.commons.lang3.tuple.Pair;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * IIdentityDAO Interface
 */
public interface IIdentityDAO
{
    String BEAN_NAME = "identitystore.identityDAO";

    /**
     * Insert a new record in the table.
     *
     * @param identity
     *            instance of the Identity object to insert
     * @param plugin
     *            the Plugin
     */
    void insert( Identity identity, int dataRetentionPeriodInMonth, Plugin plugin );

    /**
     * Update the record in the table
     *
     * @param identity
     *            the reference of the Identity
     * @param plugin
     *            the Plugin
     */
    void store( Identity identity, Plugin plugin );

    /**
     * Merge identity
     *
     * @param identity
     * @param plugin
     */
    void merge( Identity identity, Plugin plugin );

    /**
     * Cancel identity merge
     *
     * @param identity
     * @param plugin
     */
    void cancelMerge( Identity identity, Plugin plugin );

    /**
     * Delete a record from the table
     *
     * @param nKey
     *            The identifier of the Identity to delete
     * @param plugin
     *            the Plugin
     */
    void hardDelete( int nKey, Plugin plugin );

    /**
     * Modify the columuns is_deleted and date_delete and connection_id to null
     *
     * @param strCuid
     *            The id of the Identity to delete
     * @param plugin
     *            the Plugin
     */
    void softDelete( String strCuid, Plugin plugin );

    // /////////////////////////////////////////////////////////////////////////
    // Finders

    /**
     * Load the data from the table
     *
     * @param nKey
     *            The identifier of the identity
     * @param plugin
     *            the Plugin
     * @return The instance of the identity
     */
    Identity load( int nKey, Plugin plugin );

    List<Identity> selectAll( Plugin plugin );

    /**
     * Find by connection ID
     *
     * @param strConnectionId
     *            The connection ID
     * @param plugin
     *            The plugin
     * @return The identity
     */
    Identity selectByConnectionId( String strConnectionId, Plugin plugin );

    /**
     * Find by customer ID
     *
     * @param strCustomerId
     *            The customerID
     * @param plugin
     *            The plugin
     * @return The identity
     */
    Identity selectByCustomerId( String strCustomerId, Plugin plugin );

    Identity selectNotMergedByCustomerId( String strCustomerId, Plugin plugin );

    Identity selectNotMergedByConnectionId( String strCustomerId, Plugin plugin );

    /**
     * Find an identity ID from the specified customer ID
     *
     * @param strCustomerId
     *            the customer ID
     * @param plugin
     *            the plugin
     * @return The identity ID
     */
    int selectIdByCustomerId( String strCustomerId, Plugin plugin );

    /**
     * Find by a combination of Attribute values. Search for identities that match the conditions defined for each of the selected attributes, that is on each
     * of these attributes the exact value is in a list of expected values (no wildcards).
     *
     * @param searchAttributes
     *            The list of searched attributes selected with the list of values
     * @param maxNbIdentityReturned
     *            The maximum number of Identity returned in the list
     * @param plugin
     *            The plugin
     * @return The identity
     */
    List<Identity> selectByAttributesValueForApiSearch(final List<SearchAttribute> searchAttributes, int maxNbIdentityReturned, Plugin plugin );

    /**
     * Find all identities that have all attributes specified in the list in parameters.<br/>
     * Identities <b>MUST</b> have all those attributes in order to be returned.
     *
     * @param idAttributeList
     *            the attributes id
     * @param notMerged
     *            if the returned identities have to be not merged
     * @param notSuspicious
     *            if the returned identities have to not be suspicious
     * @param rulePriority
     *            when suspicions are not filtered ( notSuspicious = false ), return only lower priority suspicions
     * @param nbFilledAttributes
     *            minimum number of filled attributes over idAttributeList
     * @param plugin
     *            the plugin
     * @return A list of matching identities
     */
    List<String> selectByAttributeExisting( final List<Integer> idAttributeList, final int nbFilledAttributes, final boolean notMerged,
            final boolean notSuspicious, final int rulePriority, final Plugin plugin );

    /**
     * log changes
     *
     * @param identityChange
     * @param plugin
     */
    void addChangeHistory( IdentityChange identityChange, Plugin plugin ) throws IdentityStoreException;

    void addOrUpdateChangeHistory( IdentityChange identityChange, Plugin plugin ) throws IdentityStoreException;

    /**
     * get identity history
     *
     * @param strCustomerId
     * @param plugin
     * @return the list of identity changes
     */
    List<IdentityChange> selectIdentityHistoryByCustomerId( String strCustomerId, Plugin plugin ) throws IdentityStoreException;

    /**
     * get identities that have been updated during the previous `days`.
     *
     * @param days
     *            max number of days since the last update
     * @param identityChangeTypes
     *            filters on specific change types
     * @param updatedAttributes
     *            filters on specific updated attributes
     * @return the list of identities
     */
    List<UpdatedIdentityDto> selectUpdated( final Integer days, final List<IdentityChangeType> identityChangeTypes,
            final List<SearchUpdatedAttribute> updatedAttributes, final Integer max, final Plugin plugin );

    /**
     * get identity IDs that have been updated during the previous `days`.
     *
     * @param days
     *            max number of days since the last update
     * @param identityChangeTypes
     *            filters on specific change types
     * @param updatedAttributes
     *            filters on specific updated attributes
     * @return the list of identities
     */
    List<Integer> selectUpdatedIds( final Integer days, final List<IdentityChangeType> identityChangeTypes,
            final List<SearchUpdatedAttribute> updatedAttributes, final Integer max, final Plugin plugin );

    /**
     * select updated identities from their IDs.
     * 
     * @param identityIds
     *            list of desired identity IDs
     * @param plugin
     *            the plugin
     * @return the list of identities
     */
    List<UpdatedIdentityDto> selectUpdatedFromIds( final List<Integer> identityIds, final Plugin plugin );

    /**
     * Search for history entries that matches the following parameters
     *
     * @param strCustomerId
     *            customer id of the identity
     * @param clientCode
     *            client code that modified the identity
     * @param authorName
     *            name of the author that modified the identity
     * @param changeType
     *            the type of identity change
     * @param metadata
     *            metadata of the identity change
     * @param nbDaysFrom
     *            number of day from the current date
     * @param plugin
     * @return
     */
    List<IdentityChange> selectIdentityHistoryBySearchParameters( String strCustomerId, String clientCode, String authorName, IdentityChangeType changeType,
            String changeStatus, final String authorType, final Date modificationDate, Map<String, String> metadata, Integer nbDaysFrom, Pair<Date, Date> modificationDateInterval, Plugin plugin, int nMaxNbIdentityReturned )
            throws IdentityStoreException;

    /**
     * Search for identities that are not connected, and have a past expirationDate.
     *
     * @param limit
     *            the max number of results
     * @param withGuidOnly 
     * @param plugin
     *            the plugin
     * @return a list of {@link Identity}
     */
    List<Identity> selectExpiredNotMergedAndNotConnectedIdentities( int limit, boolean withGuidOnly, Plugin plugin );

    /**
     * Search for identity customer IDs that are not connected, not merged, and have the specified attribute non-certified.
     *
     * @param attributeKey
     *            the attribute key to be present and non-certified
     * @param limit
     *            the max number of returned identities
     * @return a list of customer IDs
     */
    List<String> selectNotMergedNotConnectedWithNonCertifiedAttributeCustomerIds(String attributeKey, String certProcess, int limit, Plugin plugin);

    /**
     * Search for identities that are merged to the provided identity ID.
     *
     * @param identityId
     *            the 'master' identity ID
     * @param plugin
     *            the plugin
     * @return a list of {@link Identity}
     */
    List<Identity> selectMergedIdentities( int identityId, Plugin plugin );

    /**
     * Delete all attribute history of the identity's provided id.
     *
     * @param identityId
     *            the identity's id
     * @param plugin
     *            the plugin
     */
    void deleteAttributeHistory( int identityId, Plugin plugin );

    /**
     * Get the identity last update date coresponding to the given customer ID
     * 
     * @param customerId
     *            the customer ID
     * @param plugin
     *            the plugin
     * @return the last update date or null if the identity doesn't exist for the provided CUID
     */
    Timestamp getIdentityLastUpdateDate( final String customerId, final Plugin plugin );

    /**
     * Count All Identities.
     */
    Integer getCountIdentities( final Plugin plugin );

    /**
     * Count All identities that has been deleted or not.
     *
     * @param deleted
     *            define if the dao count deleted or not deleted identities
     */
    Integer getCountDeletedIdentities(final boolean deleted, final Plugin plugin );

    /**
     * Count All identities that has been merged or not.
     *
     * @param merged
     *            define if the dao count merged or not merged identities
     */
    Integer getCountMergedIdentities(final boolean merged, final Plugin plugin );

    /**
     * Count All identities that has been connected or not.
     *
     * @param monParisActive
     *            define if the dao count connected or not connected identities
     */
    Integer getCountActiveMonParisdentities(final boolean monParisActive, final Plugin plugin );

    /**
     * Count how many attributes each entity has.
     */
    Map<Integer, Integer> getCountAttributesByIdentities(final Plugin plugin );

    /**
     * Count how many attributes has no attribute and isn't merged.
     */
    Integer getCountUnmergedIdentitiesWithoutAttributes(final Plugin plugin );

    Integer getCountIndexEligibleIdentities(final Plugin plugin);

    Integer getCountIndexNotEligibleIdentities(final Plugin plugin);

    /**
     * Count how many actions and their type were done during an delimited time.
     */
    List<IndicatorsActionsType> getActionsTypesDuringInterval(int interval, final Plugin plugin );

    List<String> getHistoryStatusList( final Plugin plugin );

    /**
     * reset UnicityHashCode when necessary
     */
    void resetUnicityHashCode( Identity identity, Plugin plugin );

    /**
     * Retrieve the identity full account history
     * @param identityId - the identity ID
     * @param plugin - the plugin
     */
    List<IdentityAccountHistory> selectFullIdentityAccountHistory( final int identityId, final Plugin plugin );

    /**
     * Returns the identities having the requested customerId in their account history.
     * @param connectionId - the connection ID
     * @param plugin - the plugin
     */
    List<Identity> searchIdentityFromOldGuid( final String connectionId, final Plugin plugin );

    /**
     * Returns the master identities of the identities having the requested connection ID in their account history.
     * Each master identity is returned only once, even if several identities of its merge tree had this connection ID.
     * @param strConnectionId - the old connection ID
     * @param plugin - the plugin
     * @return the master identities
     */
    List<Identity> selectNotMergedByOldConnectionId( final String strConnectionId, final Plugin plugin );

    /**
     * Delete the identity account history
     * @param identityId - the identity ID
     * @param plugin - the plugin
     */
    void deleteIdentityAccountHistory( final int identityId, final Plugin plugin );

    /**
     * Insert a new identity account history
     * @param identityAccountHistory - the identity account history
     * @param plugin - the plugin
     */
    void insertIdentityAccountHistory( final IdentityAccountHistory identityAccountHistory, final Plugin plugin );

    /**
     * Get the GUID creation date for the identity linked to the provided CUID
     * @param cuid the identity CUID
     * @param guid the GUID
     * @param plugin the plugin
     * @return the GUID creation date for the identity linked to the provided CUID, or null if the GUID was never set to the identity
     */
    Timestamp getIdentityGuidCreationDate( final String cuid, final String guid, final Plugin plugin );
}
