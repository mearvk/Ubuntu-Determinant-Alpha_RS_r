package com.jamonapi;

/** Used for MonKey to allow jamon to have the generalized form of the key for aggregation, and the
 * more specific form for writing out details say to a buffer.
 * 
 * For example the generalized form of a query would be something like:  select * from table where 
 * name=?.  The detail form would be something like:  select * from table where name='steve'
 * 
 * MonKeyItems can be placed as objects in MonKeyImp, and MonKeyBase
 * 
 * Note toString() should always return the more generalized form.
 * @author steve souza
 *
 */

import java.util.List;

public interface MonKeyItem {
	public Object getDetails();
	public void setDetails(Object details);
}
