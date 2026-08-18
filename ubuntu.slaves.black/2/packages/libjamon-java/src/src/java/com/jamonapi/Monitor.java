package com.jamonapi;

/**
 * Used to interact with monitor objects.  I would have preferred to make this an 
 *interface, but didn't do that as jamon 1.0 code would have broken.  Live and learn
 *
 * Created on December 11, 2005, 10:19 PM
 */

import java.util.Date;

import com.jamonapi.utils.ToArray;

// Note this was done as an empty abstract class so a recompile isn't needed
// to go to jamon 2.0. I had originally tried to make Monitor an interface.
// public abstract class Monitor extends BaseStatsImp implements MonitorInt {
public abstract class Monitor implements MonitorInt {

	/** Used in call to addListener(...). i.e. addListener(Monitor.MAX, ...) */
	public static final String VALUE = "value";
	public static final String MAX = "max";
	public static final String MIN = "min";
	public static final String MAXACTIVE = "maxactive";

	// Internal data passed from monitor to monitor.
	MonInternals monData;

	Monitor(MonInternals monData) {
		this.monData = monData;
	}

	Monitor() {
		this(new MonInternals());
	}

	final MonInternals getMonInternals() {
		return monData;
	}

	public MonKey getMonKey() {
		return monData.key;
	}

	/** Returns the label for the monitor */
	public String getLabel() {
		return (String) getMonKey().getValue(MonKey.LABEL_HEADER);
	}

	/** Returns the units for the monitor */
	public String getUnits() {
		return (String) getMonKey().getValue(MonKey.UNITS_HEADER);
	}

	public void setAccessStats(long now) {
		if (monData.enabled) {
			synchronized (monData) {
				// set the first and last access times.
				if (monData.firstAccess == 0)
					monData.firstAccess = now;

				monData.lastAccess = now;
			}
		}
	}

	public void reset() {
		if (monData.enabled) {
			synchronized (monData) {
				monData.reset();
			}
		}

	}

	public double getTotal() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.total;
			}
		} else
			return 0;
	}

	public void setTotal(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.total = value;
			}
		}
	}

	public double getAvg() {
		if (monData.enabled)
			return avg(monData.total);
		else
			return 0;
	}

	public double getMin() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.min;
			}
		} else
			return 0;
	}

	public void setMin(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.min = value;
			}
		}
	}

	public double getMax() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.max;
			}
		} else
			return 0;
	}

	public void setMax(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.max = value;
			}
		}
	}

	public double getHits() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.hits;
			}
		} else
			return 0;
	}

	public void setHits(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.hits = value;
			}
		}
	}

	public double getStdDev() {

		if (monData.enabled) {
			synchronized (monData) {
				double stdDeviation = 0;
				if (monData.hits != 0) {
					double sumOfX = monData.total;
					double n = monData.hits;
					double nMinus1 = (n <= 1) ? 1 : n - 1; // avoid 0 divides;

					double numerator = monData.sumOfSquares
					        - ((sumOfX * sumOfX) / n);
					stdDeviation = java.lang.Math.sqrt(numerator / nMinus1);
				}

				return stdDeviation;
			}
		} else
			return 0;
	}

	public void setFirstAccess(Date date) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.firstAccess = date.getTime();
			}
		}
	}

	private static final Date NULL_DATE = new Date(0);

	public Date getFirstAccess() {
		if (monData.enabled) {
			synchronized (monData) {
				return new Date(monData.firstAccess);
			}
		} else
			return NULL_DATE;

	}

	public void setLastAccess(Date date) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.lastAccess = date.getTime();
			}
		}
	}

	public Date getLastAccess() {
		if (monData.enabled) {
			synchronized (monData) {
				return new Date(monData.lastAccess);
			}
		} else
			return NULL_DATE;
	}

	public double getLastValue() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.lastValue;
			}
		} else
			return 0;

	}

	public void setLastValue(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.lastValue = value;
			}
		}
	}

	// new methods. not sure about them
	public void disable() {
		monData.enabled = false;
	}

	public void enable() {
		monData.enabled = true;

	}

	public boolean isEnabled() {
		return monData.enabled;
	}

	Listeners getListeners() {
		return monData.listeners;
	}

	/** new jamon 2.4 stuff */

	/**
	 * Add a listener that receives notification every time this monitors add
	 * method is called. If null is passed all associated Listeners will be
	 * detached.
	 */

	// Some jamon 2.4 introduced methods. Mostly listener related.
	
	  public ListenerType getListenerType(String listenerType) {
			return getListeners().getListenerType(listenerType);
	   }



	public Monitor start() {
		if (monData.enabled) {

			synchronized (monData) {

				monData.activityStats.allActive.increment();

				if (monData.isPrimary) {
					monData.activityStats.primaryActive.increment();
				}

				// tracking current active/avg active/max active for this
				// instance
				double active = monData.activityStats.thisActive
				        .incrementAndReturn();

				monData.totalActive += active;// allows us to track the
												// average active for THIS
												// instance.
				if (active >= monData.maxActive) {
					monData.maxActive = active;

					if (monData.listeners.listenerArray[Listeners.MAXACTIVE_LISTENER_INDEX].listener!=null && active>1)
						monData.listeners.listenerArray[Listeners.MAXACTIVE_LISTENER_INDEX].listener.processEvent(this);
				}

				// The only way activity tracking need be done is if start has
				// been entered.
				if (!monData.startHasBeenCalled) {
					monData.startHasBeenCalled = true;
					if (monData.range != null)
						monData.range.setActivityTracking(true);
				}

			} // end synchronized
		} // end enabled

		return this;

	}

	public Monitor stop() {
		if (monData.enabled) {
			synchronized (monData) {
				monData.activityStats.thisActive.decrement();

				if (monData.isPrimary) {
					monData.activityStats.primaryActive.decrement();
				}

				monData.activityStats.allActive.decrement();
			}

		}

		return this;

	}

	public Monitor add(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				// Being as TimeMonitors already have the current time and are
				// passing it in
				// the value (casted as long) for last access need not be
				// recalculated.
				// Using this admittedly ugly approach saved about 20%
				// performance
				// overhead on timing monitors.
				if (!monData.isTimeMonitor)
					setAccessStats(System.currentTimeMillis());
				
				// most recent value
				monData.lastValue = value;

				// calculate hits i.e. n
				monData.hits++;

				// calculate total i.e. sumofX's
				monData.total += value;

				// used in std deviation
				monData.sumOfSquares += value * value;


				// tracking activity is only done if start was called on the
				// monitor
				// there is no need to synchronize and perform activity tracking
				// if this
				// monitor doesn't have a start and stop called.
				if (monData.trackActivity) {
                    // total of this monitors active
					monData.thisActiveTotal += monData.activityStats.thisActive.getCount(); 
                    // total of primary actives
                    monData.primaryActiveTotal += monData.activityStats.primaryActive.getCount(); 
                    // total of all monitors actives
                    monData.allActiveTotal += monData.activityStats.allActive.getCount(); 
				}

				// calculate min. note saving min if it is a tie
				// so listener will be called and checking to see if the new
				// min was less than the current min seemed to cost
				// more. Same for max below
				if (value <= monData.min) {
					monData.min = value;

					if (monData.listeners.listenerArray[Listeners.MIN_LISTENER_INDEX].listener!=null)
						monData.listeners.listenerArray[Listeners.MIN_LISTENER_INDEX].listener.processEvent(this);
				}

				// calculate max
				if (value >= monData.max) {
					monData.max = value;
					
					if (monData.listeners.listenerArray[Listeners.MAX_LISTENER_INDEX].listener!=null)
						monData.listeners.listenerArray[Listeners.MAX_LISTENER_INDEX].listener.processEvent(this);
				}
				
				if (monData.listeners.listenerArray[Listeners.VALUE_LISTENER_INDEX].listener!=null)
					monData.listeners.listenerArray[Listeners.VALUE_LISTENER_INDEX].listener.processEvent(this);

				if (monData.range != null)
					monData.range.processEvent(this);

			}

		}

		return this;

	}

	public Range getRange() {
		return monData.range;
	}

	public double getActive() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.activityStats.thisActive.getCount();
			}
		} else
			return 0;
	}

	public void setActive(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.activityStats.thisActive.setCount(value);
			}
		}
	}

	public double getMaxActive() {
		if (monData.enabled) {
			synchronized (monData) {
				return monData.maxActive;
			}
		} else
			return 0;
	}

	public void setMaxActive(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.maxActive = value;
			}
		}
	}

	/** Neeed to reset this to 0.0 to remove avg active numbers */
	public void setTotalActive(double value) {
		if (monData.enabled) {
			synchronized (monData) {
				monData.totalActive = value;
			}
		}
	}

	public boolean isPrimary() {
		return monData.isPrimary;
	}

	public void setPrimary(boolean isPrimary) {
		if (monData.enabled) {
			this.monData.isPrimary = isPrimary;
		}
	}

	public boolean hasListeners() {
			synchronized (monData) {
				return monData.listeners.hasListeners();
			}
	}

	public String toString() {
		if (monData.enabled) {
			// This character string is about 275 characters now, but made
			// the default a little bigger, so the JVM doesn't have to grow
			// the StringBuffer should I add more info.

			StringBuffer b = new StringBuffer(400);
			b.append(getMonKey() + ": (");
			b.append("LastValue=");
			b.append(getLastValue());
			b.append(", Hits=");
			b.append(getHits());
			b.append(", Avg=");
			b.append(getAvg());
			b.append(", Total=");
			b.append(getTotal());
			b.append(", Min=");
			b.append(getMin());
			b.append(", Max=");
			b.append(getMax());
			b.append(", Active=");
			b.append(getActive());
			b.append(", Avg Active=");
			b.append(getAvgActive());
			b.append(", Max Active=");
			b.append(getMaxActive());
			b.append(", First Access=");
			b.append(getFirstAccess());
			b.append(", Last Access=");
			b.append(getLastAccess());
			b.append(")");

			return b.toString();
		} else
			return "";

	}

	/** FROM frequencydistimp */
	public void setActivityTracking(boolean trackActivity) {
		this.monData.trackActivity = trackActivity;
	}

	public boolean isActivityTracking() {
		return monData.trackActivity;
	}

	private double avg(double value) {
		synchronized (monData) {
			if (monData.hits == 0)
				return 0;
			else
				return value / monData.hits;
		}
	}

	public double getAvgActive() {
		if (monData.enabled) {
			// can be two ways to get active. For ranges
			// thisActiveTotal is used and for nonranges
			// totalActive is used.
			if (monData.trackActivity) {
				return avg(monData.thisActiveTotal);
			} else
				return avg(monData.totalActive);
		} else
			return 0;

	}

	public double getAvgGlobalActive() {
		return avg(monData.allActiveTotal);
	}

	public double getAvgPrimaryActive() {
		return avg(monData.primaryActiveTotal);
	}

	public JAMonDetailValue getJAMonDetailRow() {
		if (monData.enabled) {
			synchronized (monData) {
                return new JAMonDetailValue(getMonKey(),
                        monData.lastValue, monData.activityStats.thisActive.getCount(),  monData.lastAccess);                
//				return new JAMonDetailValue(getMonKey().getDetailLabel(),
//				        monData.lastValue, monData.activityStats.thisActive.getCount(),  monData.lastAccess);
			}
		} else
			return JAMonDetailValue.NULL_VALUE;
	}
	


}
