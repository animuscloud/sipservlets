/*
 * JBoss, Home of Professional Open Source
 * Copyright 2010, Red Hat Middleware LLC, and individual contributors
 * as indicated by the @authors tag. All rights reserved.
 * See the copyright.txt in the distribution for a full listing
 * of individual contributors.
 * 
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the GNU General Public License, v. 2.0.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License,
 * v. 2.0 along with this distribution; if not, write to the Free 
 * Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 */
package org.jdiameter.common.api.app.cca;

import org.jdiameter.api.app.AppSession;
import org.jdiameter.api.app.StateChangeListener;
import org.jdiameter.api.cca.ClientCCASessionListener;
import org.jdiameter.api.cca.ServerCCASessionListener;
import org.jdiameter.common.api.app.IAppSessionFactory;

/**
 * Session Factory interface for Diameter Credit-Control Application (CCA).
 * 
 * @author <a href="mailto:baranowb@gmail.com"> Bartosz Baranowski </a>
 * @author <a href="mailto:brainslog@gmail.com"> Alexandre Mendonca </a>
 */
public interface ICCASessionFactory extends IAppSessionFactory {

  /**
   * Get stack wide listener for sessions. In local mode it has 
   * similar effect as setting this directly in app session.
   * However clustered session use this value when recreated!
   * 
   * @return the clientSessionListener
   */
  public ClientCCASessionListener getClientSessionListener();

  /**
   * Set stack wide listener for sessions. In local mode it has
   * similar effect as setting this directly in app session.
   * However clustered session use this value when recreated!
   * 
   * @param clientSessionListener
   *          the clientSessionListener to set
   */
  public void setClientSessionListener(ClientCCASessionListener clientSessionListener);

  /**
   * Get stack wide listener for sessions. In local mode it has similar
   * effect as setting this directly in app session.
   * However clustered session use this value when recreated!
   * 
   * @return the serverSessionListener
   */
  public ServerCCASessionListener getServerSessionListener();

  /**
   * Set stack wide listener for sessions. In local mode it has similar
   * effect as setting this directly in app session.
   * However clustered session use this value when recreated!
   * 
   * @param serverSessionListener
   *          the serverSessionListener to set
   */
  public void setServerSessionListener(ServerCCASessionListener serverSessionListener);

  /**
   * @return the serverContextListener
   */
  public IServerCCASessionContext getServerContextListener();

  /**
   * @param serverContextListener
   *          the serverContextListener to set
   */
  public void setServerContextListener(IServerCCASessionContext serverContextListener);

  /**
   * @return the clientContextListener
   */
  public IClientCCASessionContext getClientContextListener();

  /**
   * @return the messageFactory
   */
  public ICCAMessageFactory getMessageFactory();

  /**
   * @param messageFactory
   *          the messageFactory to set
   */
  public void setMessageFactory(ICCAMessageFactory messageFactory);

  /**
   * @param clientContextListener
   *          the clientContextListener to set
   */
  public void setClientContextListener(IClientCCASessionContext clientContextListener);

  /**
   * @return the stateListener
   */
  public StateChangeListener<AppSession> getStateListener();

  /**
   * @param stateListener
   *          the stateListener to set
   */
  public void setStateListener(StateChangeListener<AppSession> stateListener);
}