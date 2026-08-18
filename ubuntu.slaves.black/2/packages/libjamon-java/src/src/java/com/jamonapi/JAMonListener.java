package com.jamonapi;

import java.util.EventListener;

/** Interface that can be implemented if you want to code something to listen for JAMon events
 *  such as a new max/min/max active have occured, or even if the monitor has fired.  It also implements
 *  the java EventListener tag interface.
 *  
 * @author steve souza
 *
 */

public interface JAMonListener extends EventListener {
	 public String getName();
	 public void setName(String name);
	 public void processEvent(Monitor mon);
}
