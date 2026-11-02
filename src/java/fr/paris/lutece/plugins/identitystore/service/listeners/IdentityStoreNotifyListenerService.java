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
package fr.paris.lutece.plugins.identitystore.service.listeners;

import fr.paris.lutece.plugins.identitystore.business.identity.Identity;
import fr.paris.lutece.plugins.identitystore.service.AttributeChangeListener;
import fr.paris.lutece.plugins.identitystore.service.IdentityChangeListener;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.AttributeStatus;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.common.RequestAuthor;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.AttributeChangeType;
import fr.paris.lutece.plugins.identitystore.v3.web.rs.dto.history.IdentityChangeType;
import fr.paris.lutece.portal.service.spring.SpringContextService;
import fr.paris.lutece.portal.service.util.AppLogService;
import fr.paris.lutece.portal.service.util.AppPropertiesService;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 *
 */
public final class IdentityStoreNotifyListenerService
{
    // singleton
    private static IdentityStoreNotifyListenerService _singleton;

    // List
    private final List<AttributeChangeListener> _attributeChangelistListeners;
    private final List<IdentityChangeListener> _identityChangeListListeners;

    private final Integer poolSize = AppPropertiesService.getPropertyInt( "identitystore.listener.pool.size", 3 );

    private final ExecutorService attributeExecutor = Executors.newFixedThreadPool( poolSize );
    private final ExecutorService identityExecutor = Executors.newFixedThreadPool( poolSize );

    /**
     * private constructor
     */
    private IdentityStoreNotifyListenerService( )
    {
        // init attributeChangelistListeners
        _attributeChangelistListeners = SpringContextService.getBeansOfType( AttributeChangeListener.class );

        StringBuilder sbLog = new StringBuilder( );
        sbLog.append( "IdentityStore - loading listeners  : " );

        for ( final AttributeChangeListener listener : _attributeChangelistListeners )
        {
            sbLog.append( "\n\t\t\t\t - " ).append( listener.getName( ) );
        }

        AppLogService.debug( sbLog.toString( ) );

        // init identityChangeListListeners
        _identityChangeListListeners = SpringContextService.getBeansOfType( IdentityChangeListener.class );

        sbLog = new StringBuilder( );
        sbLog.append( "IdentityStore - loading listeners  : " );

        for ( final IdentityChangeListener listener : _identityChangeListListeners )
        {
            sbLog.append( "\n\t\t\t\t - " ).append( listener.getName( ) );
        }

        AppLogService.debug( sbLog.toString( ) );

    }

    /**
     * Returns the unique instance
     *
     * @return The instance
     */
    public static IdentityStoreNotifyListenerService instance( )
    {
        if ( _singleton == null )
        {
            _singleton = new IdentityStoreNotifyListenerService( );
        }
        return _singleton;
    }

    /**
     * Notify an attribute change to all registered listeners
     * 
     * @param changeType
     *            the type of change
     * @param identity
     *            the identity to which the attribute belongs
     * @param attributeStatus
     *            the attribute status
     * @param author
     *            the author of the change
     * @param clientCode
     *            the client code that triggered the change
     */
    public void notifyListenersAttributeChange( AttributeChangeType changeType, Identity identity, AttributeStatus attributeStatus, RequestAuthor author,
            String clientCode )
    {
        _attributeChangelistListeners.stream( ).<Runnable> map( listener -> ( ) -> {
            try
            {
                listener.processAttributeChange( changeType, identity, attributeStatus, author, clientCode );
            }
            catch( Exception e )
            {
                AppLogService.error( "An error occurred when notifying listener " + listener.getName( ) + " : " + e.getMessage( ), e );
            }
        } ).forEach( attributeExecutor::submit );
    }

    /**
     * Notify an identityChange to all registered listeners
     * 
     * @param identityChangeType
     *            the type of change
     * @param identity
     *            the identity that changed
     * @param statusCode
     *            the status code of the change
     * @param statusMessage
     *            the message
     * @param author
     *            the author of the change
     * @param clientCode
     *            the client code that triggered the change
     * @param metadata
     *            additional data
     */
    public void notifyListenersIdentityChange( IdentityChangeType identityChangeType, Identity identity, String statusCode, String statusMessage,
            RequestAuthor author, String clientCode, Map<String, String> metadata )
    {
        _identityChangeListListeners.stream( ).<Runnable> map( listener -> ( ) -> {
            try
            {
                listener.processIdentityChange( identityChangeType, identity, statusCode, statusMessage, author, clientCode, metadata );
            }
            catch( Exception e )
            {
                AppLogService.error( "An error occurred when notifying listener " + listener.getName( ) + " : " + e.getMessage( ), e );
            }
        } ).forEach( identityExecutor::submit );
    }

}
