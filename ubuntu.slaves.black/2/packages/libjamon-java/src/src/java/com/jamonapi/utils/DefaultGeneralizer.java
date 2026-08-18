package com.jamonapi.utils;

import com.jamonapi.proxy.SQLDeArger;;

public class DefaultGeneralizer implements Generalizer {

	
	/** Replaces numbers and quoted strings with '?'.  For example
	 *     Original=ERROR Invalid login name:  'ssouza', 404
	 *     becomes=ERROR Invalid login name:  ?,?
	 *     
	 *     Original=ERROR Invalid login name:  ssouza, _404
	 *     becomes (no change)=ERROR Invalid login name:  ssouza, _404
	 */
	public String generalize(String detail) {
	    return new SQLDeArger(detail).getParsedSQL();
    }



}
