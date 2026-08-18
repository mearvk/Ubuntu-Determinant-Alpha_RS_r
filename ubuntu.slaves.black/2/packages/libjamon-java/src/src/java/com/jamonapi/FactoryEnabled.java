package com.jamonapi;

/**
 * Main workhorse for creating monitors.  
 *
 */



import java.util.*;

import com.jamonapi.utils.DetailData;

/** Factory that creates Monitors.  This can be created directly.  MonitorFactory is simply 
 * a wrapper that makes calling this class simpler.   MonitorFactory contains a static reference to
 * a FactoryEnabled class.
 * 
 * @author steve souza
 *
 */

public class FactoryEnabled implements MonitorFactoryInterface {
    
    /** Creates a new instance of MonFactoryEnabled.  Also initializes the standard 
     * JAMon time monitor range (ms.)
     */
    public FactoryEnabled() {
    	initialize();
    }
    
    // note the default capacity for a HashMap is 16 elements with a load factor of
    // .75.  This means that after 12 elements have been loaded the HashMap doubles, 
    // and doubles again at 24 etc.  By setting the HashMap to a higher value it need not
    // grow as often.  You can also have jamon use a different map type via the setMap method.
    private Map map;
    private Counter allActive;
    private Counter primaryActive;
    private RangeFactory rangeFactory;// Builds Range objects
    private static final boolean PRIMARY=true;
    private static final boolean NOT_PRIMARY=false;    
    private static final boolean TIME_MONITOR=true;
    private static final boolean NOT_TIME_MONITOR=false;
    private static final String VERSION="2.7";

    

    private synchronized void initialize() {
        map = Collections.synchronizedMap(new HashMap(500));
        allActive=new Counter();
        primaryActive=new Counter();
        rangeFactory=new RangeFactory();// Builds Range objects
       
    	setRangeDefault("ms.", RangeHolder.getMSHolder());
    	setRangeDefault("percent", RangeHolder.getPercentHolder());
    }
    
    public Monitor add(MonKey key, double value) {
       return getMonitor(key).add(value);
    }
    
    public Monitor add(String label, String units, double value) {
        return getMonitor(new MonKeyImp(label, units)).add(value);
    }
    
    public Monitor start(MonKey key) {
        return getTimeMonitor(key, NOT_PRIMARY).start();
    }
    
    public Monitor start(String label) {
        return getTimeMonitor(new MonKeyImp(label, "ms."), NOT_PRIMARY).start();
    }
    
    public Monitor startPrimary(MonKey key) {
        return getTimeMonitor(key, PRIMARY).start();
    }
     
    
    public Monitor startPrimary(String label) {
        return getTimeMonitor(new MonKeyImp(label, "ms."), PRIMARY).start();
    }    

    public Monitor start() {
         return new TimeMon2().start();
    }    
    
	public Monitor getMonitor() {
	    return new MonitorImp(new MonKeyImp("defaultMon","defaultMon"), null, new ActivityStats(), false);
    }

   
   
    /** allows for using a faster/open source map */
    public void setMap(Map map) {
        this.map=map; 
    }
    
    
    public Monitor getMonitor(MonKey key) {
        return getMonitor(key, NOT_PRIMARY, NOT_TIME_MONITOR);
    }
    
    
    public Monitor getMonitor(String label, String units) {
        return getMonitor(new MonKeyImp(label, units));
    }    
    
    public Monitor getTimeMonitor(MonKey key) {
        return getTimeMonitor(key, NOT_PRIMARY);
    }

    public Monitor getTimeMonitor(String label) {
        return getTimeMonitor(new MonKeyImp(label, "ms."), NOT_PRIMARY);
    }

    
    
    // Range methods
    
   
    // logical should be < or <= to determine how to use range values.
    // if it is neither it defaults to <=
    /** Note if a null is passed in it will have the same effect as an empty
     * RangeHolder (i.e. it will perform null operations)
     */
    public void setRangeDefault(String key, RangeHolder rangeHolder) {
    	RangeImp range=null;
    	if (rangeHolder!=null || rangeHolder.getSize()>0)
          range=new RangeBase(rangeHolder);

    	rangeFactory.setRangeDefault(key, range );
    }
    
    public String[] getRangeHeader() {
        return rangeFactory.getHeader();
    }
    
    public Object[][] getRangeNames() {
        return rangeFactory.getData();
    }
    
    
    public void remove(MonKey key) {
        map.remove(key);
    }
    
        
    public void remove(String label, String units) {
        map.remove(new MonKeyImp(label, units));
    }
    
    
    public boolean exists(MonKey key) {
      return map.containsKey(key);  
    }
    
    
    public boolean exists(String label, String units) {
        return map.containsKey(new MonKeyImp(label, units));
    }
    

    
    public int getNumRows() {
        return map.size();
    }
    
 
    
    // MonitorComposite methods
    /** getComposite("AllMonitors") is the same as getRootMonitor() */
    public MonitorComposite getRootMonitor() {
        return new MonitorComposite(getMonitors());
    }
    
    /** Pass in the units (or range type) and return all monitors of that
     * type.  'AllMonitors' is a special argument returns a composite of surprise surprise all monitors
     *getComposite("AllMonitors") is the same as getRootMonitor() ;
     **/
    public MonitorComposite getComposite(String units) {
        return new MonitorComposite(getMonitors(units));
    }
    
    public String getVersion() {
       return VERSION;
    }
   

    // INTERNALS/PRIVATES FOLLOW
    private MonitorImp getTimeMonitor(MonKey key, boolean isPrimary) {
       return getMonitor(key, isPrimary, TIME_MONITOR);
    }
    
    /***This was changed 11/24/06 to fix syncronization problems reported as bug */    
    private synchronized MonitorImp getMonitor(MonKey key, boolean isPrimary, boolean isTimeMonitor) {
      // note using MonKey over String concatenation doubled the speed
      // of the code, and was only slightly slower than using just the label
      // as the key
      MonitorImp mon=getExistingMonitor(key);
      // chance of 2 threads going into the next code simultaneously
      if (mon==null) { 
        mon=createMon(key, isPrimary, isTimeMonitor);
        putMon(key, mon);          
      }
   
      if (mon.isEnabled()) {
         mon = (isTimeMonitor) ?  new TimeMon(key, mon.getMonInternals()) : new DecoMon(key, mon.getMonInternals());
       } 
      
      return mon;
          
        
    }
    
    
   
    
    private MonitorImp createMon(MonKey key, boolean isPrimary, boolean isTimeMonitor)  {
          ActivityStats activityStats=new ActivityStats(new Counter(), primaryActive, allActive);
          // get default range for this type and assign it to the monitor
          RangeImp range=rangeFactory.getRangeDefault(key.getRangeKey(), activityStats);
          MonitorImp mon=new MonitorImp(key, range, activityStats, isTimeMonitor); 
                  
          mon.setPrimary(isPrimary);
          return mon;
    }

    private MonitorImp[] getMonitors(String units) {
        MonitorImp[] monitors=getMonitors();
        if (monitors==null || units==null)
          return null;
        else if ("AllMonitors".equalsIgnoreCase(units))
          return monitors;
        
        List rows=new ArrayList(500);
        
        int size=monitors.length;
        for (int i=0;i<size;i++) {
            // if units of range match units of this monitor then 
            if (units.equalsIgnoreCase(monitors[i].getMonKey().getRangeKey()))
              rows.add(monitors[i]);
        }
        
        if (rows.size()==0)
           return null;
        else
           return (MonitorImp[]) rows.toArray(new MonitorImp[0]);
        
    }
    
    private Collection getAllMonitors() {
        Collection monitors=map.values();
        if (monitors==null || monitors.size()==0)
          return null;
        else 
          return monitors;
        
    }
    
    
    private MonitorImp[] getMonitors() {
        Collection monitors=getAllMonitors();
        if (monitors==null || monitors.size()==0)
          return null;
        else 
          return (MonitorImp[]) monitors.toArray(new MonitorImp[0]);
    }
    
   
    private MonitorImp getExistingMonitor(MonKey key) {
       return (MonitorImp) map.get(key);
    }
    
    private void putMon(MonKey key, MonitorImp mon) {
       map.put(key, mon);
    }
    
    
    

    /** Builds ranges */
    private static class RangeFactory  implements DetailData {
       private Map rangeFactoryMap=Collections.synchronizedMap(new HashMap(50));
      
       
       private void setRangeDefault(String key, RangeImp range) {
        rangeFactoryMap.put(key, range);
        // at this point we could set primary and all active counters
       }
       
              
           /** null or range doesn't exists returns a null range object */
       private RangeImp getRangeDefault(String key, ActivityStats activityStats) {
         RangeImp range=(RangeImp) rangeFactoryMap.get(key);
         if (range!=null)
           range=range.copy(activityStats);
         
         return range;
           
       }
       
       public String[] getHeader() {
           return new String[]{"RangeName"};
       }
       
       public Object[][] getData() {
           return getRangeNames(getSortedRangeNames());
      }
       
       // Returns a choice of ranges.
       private Object[][] getRangeNames(Object[] rangeNames) {
           int len=(rangeNames==null) ? 0 : rangeNames.length;
           Object[][] data=new Object[len+1][];
           // always populate first entry with 'AllMonitors'
           data[0]=new Object[] {"AllMonitors"};

           for (int i=0;i<len;i++) 
               data[i+1]=new Object[]{rangeNames[i]};
               
           return data;
           
       }

       // returns sorted array of all the unit types
       private Object[] getSortedRangeNames() {
           Object[] rangeNames=rangeFactoryMap.keySet().toArray();
         
           if (rangeNames==null)
             return null;
           else {
             Arrays.sort(rangeNames);
             return rangeNames;
           }
       }

       
    }




    /** Wipe out existing jamon data.  Same as instantiating a new FactoryEnabled object. */
	public synchronized void reset() {
		initialize();		
	}
	
	public void enableGlobalActive(boolean enable) {
	    allActive.enable(enable);
	    
    }
	public boolean isGlobalActiveEnabled() {
	    return allActive.isEnabled();
    }

	public Iterator iterator() {
	    // TODO Auto-generated method stub
	    return map.values().iterator();
    }


    
    

    

    
}
