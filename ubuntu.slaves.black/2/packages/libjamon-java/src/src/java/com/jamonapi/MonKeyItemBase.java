package com.jamonapi;

import java.util.List;
import com.jamonapi.utils.*;

/** Used in MonKeys.  Pass a generalized form to the summaryLabel and a specific form to the 
 * detailLabel.  (i.e. summary=myproc ?,?, detail=myproc 'steve','souza'.  Make sure you 
 * don't pass the arguments in the wrong order as jamon uses the summary label for jamon aggregate
 * stats, and you don't want every non-generalized form to become a jamon record.
 * 
 * @author steve souza
 *
 */
public class MonKeyItemBase implements MonKeyItem {
	private Object summaryLabel;
	private Object details;

	public MonKeyItemBase(Object summaryLabel) {
		this.summaryLabel=(summaryLabel==null) ? "" : summaryLabel;
		this.details=(summaryLabel==null) ? "" : summaryLabel;
	}
	
	public MonKeyItemBase(Object summaryLabel, Object details) {
		this.summaryLabel=(summaryLabel==null) ? "" : summaryLabel;
		this.details=details;
	}
	

	public Object getDetails() {
		return details;
	}
	
	public void setDetails(Object details) {
		this.details=details;
    }


//    public List getDetails(List list) {
//        Misc.addTo(list, details);
//        return list;
//
//    }
    

	/** should call getSummaryLabel */
	public String toString(){
		return summaryLabel.toString();
	}
	
	public boolean equals(Object obj) {
		if (this==obj)
		  return true;
		else if (obj==null)
		  return false;
		else if (!(obj instanceof MonKeyItemBase))
		  return false;
		else {
			MonKeyItemBase mk=(MonKeyItemBase) obj;
			return summaryLabel.equals(mk.summaryLabel);
		}
	}
	
	
	 public int hashCode() { 
	    return summaryLabel.hashCode();  
	 }




}
