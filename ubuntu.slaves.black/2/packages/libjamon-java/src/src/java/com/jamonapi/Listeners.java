package com.jamonapi;

final class Listeners {
	public static final String VALUE = "value";
	public static final String MAX = "max";
	public static final String MAXACTIVE = "maxactive";
	public static final String MIN = "min";
	private static final String[] listenerTypes = { VALUE, MAX, MAXACTIVE, MIN };

	static final int VALUE_LISTENER_INDEX=0;
	static final int MAX_LISTENER_INDEX=1;
	static final int MAXACTIVE_LISTENER_INDEX=2;
	static final int MIN_LISTENER_INDEX=3;
	final ListenerType[] listenerArray=new ListenerType[4];
	
	Listeners(Object lockObj) {
		for (int i=0;i<listenerArray.length;i++)
		   listenerArray[i]=new ListenerType(lockObj);
	}

	// return max/value/maxactive/min listener or null
	final ListenerType getListenerType(String listenerType) {
		for (int i = 0; i < listenerArray.length; i++)
			if (listenerTypes[i].equalsIgnoreCase(listenerType))
				return listenerArray[i];

		return null;

	}
	
	final ListenerType getListenerType(int listenerType) {
		return listenerArray[listenerType];
	}



	/** Returns true if any listeners exist */
	public boolean hasListeners() {
		for (int i=0;i<listenerArray.length;i++) {
		if (listenerArray[i].hasListeners())
			  return true;
		}
			
			return false;
	}
		
		


}
