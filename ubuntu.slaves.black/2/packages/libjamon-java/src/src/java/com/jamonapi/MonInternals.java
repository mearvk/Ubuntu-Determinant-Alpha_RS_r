package com.jamonapi;

import java.util.Iterator;

import com.jamonapi.utils.Misc;

/**
 * Contains the data associated with a monitor. These internals can be passed
 * around and shared by other monitor instances that are tracking aggregate
 * stats for the same MonKey. It mostly acts as a Struct with the exception of
 * the reset() method.
 * 
 * Created on December 11, 2005, 10:19 PM
 */

final class MonInternals {

	/** seed value to ensure that the first value always sets the max */
	static final double MAX_DOUBLE = -Double.MAX_VALUE;
	/** seed value to ensure that the first value always sets the min */
	static final double MIN_DOUBLE = Double.MAX_VALUE;

	MonKey key;

	/** the total for all values */
	double total = 0.0;
	/** The minimum of all values */
	double min = MIN_DOUBLE;
	/** The maximum of all values */
	double max = MAX_DOUBLE;
	/** The total number of occurrences/calls to this object */
	double hits = 0.0;
	/** Intermediate value used to calculate std dev */
	double sumOfSquares = 0.0;
	/** The most recent value that was passed to this object */
	double lastValue = 0.0;
	/** The first time this object was accessed */
	long firstAccess = 0;
	/** The last time this object was accessed */
	long lastAccess = 0;
	/** Is this a time monitor object? Used for performance optimizations */
	boolean isTimeMonitor = false;


	/** * jamon 2.4 from BaseMon enable/disable */

	boolean enabled = true;
	boolean trackActivity = false;
	String name = "";// for regular monitors empty. For range monitors
						// "Range1_"
	String displayHeader = "";// for regular monitors empty. rangeholder name
								// for ranges (i.e. 0_20ms)

	/** * added for jamon 2.4 from Mon */
	double maxActive = 0.0;
	double totalActive = 0.0;
	boolean isPrimary = false;
	boolean startHasBeenCalled = true;
	ActivityStats activityStats;
	// from MonitorImp
	RangeImp range;
	double allActiveTotal; // used to calculate the average active total
							// monitors for this distribution
	double primaryActiveTotal;
	double thisActiveTotal;
	
	Listeners listeners;
	
	MonInternals() {
		listeners=new Listeners(this);
	}



	public void reset() {

		hits = total = sumOfSquares = lastValue = 0.0;
		firstAccess = lastAccess = 0;
		min = MIN_DOUBLE;
		max = MAX_DOUBLE;

		// added from mon class
		maxActive = totalActive = 0.0;
		activityStats.thisActive.setCount(0);

		// added from frequencydistbase
		allActiveTotal = primaryActiveTotal = thisActiveTotal = 0;
		if (range != null)
			range.reset();
	}



}
