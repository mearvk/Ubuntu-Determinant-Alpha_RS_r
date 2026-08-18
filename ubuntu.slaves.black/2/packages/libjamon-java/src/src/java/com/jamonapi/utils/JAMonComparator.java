package com.jamonapi.utils;

import java.util.Comparator;

public class JAMonComparator implements Comparator {
	private static final int LESSTHAN=-1;
	private static final int EQUALTO=0;
	private static final int GREATERTHAN=1;
	private boolean naturalOrder=true;
	private Comparator childComparator=null;// used if JAMonComparator is used as a decorator.
	
	public JAMonComparator() {
	}
	
	public JAMonComparator(boolean naturalOrder) {
		this.naturalOrder=naturalOrder;;

	}
	
	public  JAMonComparator(boolean naturalOrder, Comparator childComparator) {
		this.naturalOrder=naturalOrder;
		this.childComparator=childComparator;

	}
	


	/*
	 * Returns 
	 * this object is less than - returns a negative integer, 
	 * this object equal to - retunrs zero
     * this object greater than - return positive integer 
	 */
	    public int compare(Object newObj, Object existingObj) {
		     // Note the following if condition ensures that nulls may be in the array.  
		     if ((existingObj==null && newObj==null) || 
		    		 !(existingObj instanceof Comparable) || 
		    		 !(newObj instanceof Comparable)) // 2 nulls are considered equal.  if either object is not comparable return that they are equal
		       return EQUALTO;
		     // if either other value is null then we don't want this to return less 
		     // (i.e. true for this conditional) so return 1 (greater than)
		     // When existing is null always replace.
		     else if (existingObj==null) 
		       return GREATERTHAN;
		     else if (newObj==null)  // when new is null never replace
		       return LESSTHAN;
		     
	    	if (childComparator==null) {
	   	     // Note I am using the passed in value as the Comparable type as this seems more flexible.  For example
			     // You may not have control over the array values, but you do over what comparable value you pass in, but being
			     // as the comparison is really asking if the col value is greater than the comparison value I am taking the negative
			     // value.  i.e. The compareTo() test is really asking if the compValue is greater than the colValue so flipping it with a
			     // negative gives us the right answer.   
			  return reverseIfNeeded(compareThis(newObj, existingObj));
	    	}
	    	else
	    	  return reverseIfNeeded(childComparator.compare(newObj, existingObj));
	    	


	    }
	    
	    protected int compareThis(Object newObj, Object existingObj) {
	    	  Comparable comparable=(Comparable) newObj;
			  return comparable.compareTo(existingObj);
	    }
	    
	    private int reverseIfNeeded(int retVal) {
	    	return (naturalOrder) ? retVal : -retVal;
	    }
	    
	    public boolean isNaturalOrder() {
	    	return naturalOrder;
	    }
	     
}
