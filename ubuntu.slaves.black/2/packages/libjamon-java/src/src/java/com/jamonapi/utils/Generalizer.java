package com.jamonapi.utils;

/** This class interface will return a detail form in the getDetailLabel method which
 * is appropriate for logging.  getSummaryLabel returns a label that is appropriate for jamon
 * (i.e. not too unique).  toString() should always return the more general/summary label.
 * Example:  getDetailLabel()=select * from table where key=100 and name='mindy'
 *           getLabel()=select * from table where key=? and name=?
 *           toString()=getLabel()
 * @author steve souza
 *
 */
public interface Generalizer {
	public String generalize(String detail);
}
