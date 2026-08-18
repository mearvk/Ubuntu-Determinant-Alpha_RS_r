/**
 * Treats groups of monitors the same way you treat one monitor.  i.e. you can enable/disable/reset
 * etc a group of monitors.
 */

package com.jamonapi;


import java.util.*;
import com.jamonapi.utils.*;

public class MonitorComposite extends Monitor  implements DetailData  {
 
    private final Monitor[] monitors;// the monitors in the composite
    private final int numRows; // rows in the composite
    private final static int TYPICAL_NUM_CHILDREN=200;// hopefully makes it so the monitor need not grow all the time
    
    /** Creates a new instance of MonitorComposite */
    public MonitorComposite(Monitor[] monitors) {
        this.monitors=monitors;
        numRows=(monitors==null) ? 0 : monitors.length;
    }
    

    
    MonitorComposite() {
        this(null);
    }
    
    public Monitor[] getMonitors() {
        return monitors;
    }
    
    /** Pass in an array with col1=lables, and col2=units and then call methods */ 
    public static MonitorComposite getMonitors(String[][] labels) {
    	int numRows=(labels==null) ? 0 : labels.length;
    	int numCols=(labels[0]==null) ? 0 : labels[0].length;
    	
    	Monitor[] monArray=new Monitor[numRows];

    	for (int i=0; i<numRows; i++) {
    		MonKey key=null;
    	    if (numCols==2)// i.e 2 columns - summary, units (ex: sp_proc ?, ms.)
    	      key=new MonKeyImp(labels[i][0],labels[i][1]);
    	    else if (numCols==3) // 3 columns - summary, detail, units (ex: sp_proc ?, sp_proc 'steve', ms.)
      	      key=new MonKeyImp(labels[i][0],labels[i][1], labels[i][2]);
		    
    	    monArray[i]=MonitorFactory.getMonitor(key);
 	 	} 
		
		return new MonitorComposite(monArray);
        
    }
    
    public int getNumRows() {
        return numRows;
    }

    /** Return the header that applies to all monitors.  It does not include range column headers.
     ** It will contain label, hits, total, avg, min, max and active among other columns
     **/
    public String[] getBasicHeader() {
        List header=new ArrayList();
        if (hasData()) {
          // being as all monitors in the composite should have the same range 
          //  getting the first one should suffice to get the header 
          getFirstMon().getBasicHeader(header);
          return (String[]) header.toArray(new String[0]);        
        } else 
          return null;
    }
    
    /** Return the header with basic data and columns for each field within the range. note getHeader only works if the range of all monitors in the composite are the same.
     **/
    public String[] getHeader() {
        List header=new ArrayList();
        if (hasData()) {
          // being as all monitors in the composite should have the same range 
          //  getting the first one should suffice to get the header 
          getFirstMon().getHeader(header);
          return (String[]) header.toArray(new String[0]);        
        } else 
          return null;
    }
    

    /** Return the header with basic data and one column for each range.  Note this only will work with ranges of the same type */
    public String[] getDisplayHeader() {
        List header=new ArrayList();
        if (hasData()) {
          // being as all monitors in the composite should have the same range 
          //  getting the first one should suffice to get the header
          getFirstMon().getDisplayHeader(header);
          return (String[]) header.toArray(new String[0]);        
        } else 
          return null;
    }

    
 
    // Various get data methods (for all data, basic data, and display data
    // note getData will only return an array with the same number of columns in every row 
    // if the range of all monitors in the composite are the same.
    /** Get all data including basic data as well as each element within the range */
    public Object[][] getData() {
     if (!hasData())
       return null;
     
     Object[][] data=new Object[getNumRows()][];
     for (int i=0;i<numRows;i++) {
        data[i]=getRowData((MonitorImp)monitors[i]);
     }
     
     return data;
        
    }

    
    /** Get basic data (which excludes range data) */
   public Object[][] getBasicData() {
     if (!hasData())
       return null;
     
     Object[][] data=new Object[getNumRows()][];
     for (int i=0;i<numRows;i++) {
        data[i]=getBasicRowData((MonitorImp)monitors[i]);
     }
     
     return data;
        
   }


   /** Get display data including 1 column for each range */
    public Object[][] getDisplayData() {
     if (!hasData())
       return null;
     
     Object[][] data=new Object[getNumRows()][];
     for (int i=0;i<numRows;i++) {
        data[i]=getRowDisplayData((MonitorImp)monitors[i]);
     }
     
     return data;        
        
    }

    /** A basic report in html format.  It has summary info for all monitors but 
     * no range info 
     */
    public String getReport() {
        return getReport(0, "asc");
    }
    
    /** A basic report in html format that is sorted.  It has summary info for all monitors but 
     * no range info 
     */
    public String getReport(int sortCol, String sortOrder) {
        if (!hasData())
          return "";
        
       String[] header=getBasicHeader();
       Object[][] data=Misc.sort(getBasicData(), sortCol, sortOrder);
       int rows=data.length;
       int cols=header.length;

       StringBuffer html=new StringBuffer(100000);// guess on report size
       html.append("\n<table border='1' rules='all'>\n");
       
       for (int i=0;i<cols;i++)
          html.append("<th>"+header[i]+"</th>");
       
       html.append("<th>"+header[0]+"</th>");//repeat first header
       html.append("\n");
       
       for (int i=0;i<rows;i++) {
          html.append("<tr>");
          for (int j=0;j<cols;j++) {
             html.append("<td>"+data[i][j]+"</td>");
          }
          html.append("<td>"+data[i][0]+"</td>");// repeat first column
          html.append("</tr>\n");
       }
       
       
       html.append("</table>");
       
       return html.toString();
    }
    
    /** Does this have data? */
    public boolean hasData() {
        return (getNumRows()==0) ? false : true;
    }

    // Various get row data methods (for full row, basic row, and display row
    private Object[] getRowData(MonitorImp mon) {
        List row=new ArrayList(TYPICAL_NUM_CHILDREN);
        mon.getRowData(row);
        return row.toArray();
        
    }

    private Object[] getBasicRowData(MonitorImp mon) {
        List row=new ArrayList();
        mon.getBasicRowData(row);
        return row.toArray();
        
    }
    
    
    private Object[] getRowDisplayData(MonitorImp mon) {
        List row=new ArrayList(TYPICAL_NUM_CHILDREN);
        mon.getRowDisplayData(row);
        return row.toArray();
        
    }
    

    public void reset() {
     for (int i=0;i<numRows;i++) 
       monitors[i].reset();
    }
 
    
    public void disable() {
      for (int i=0;i<numRows;i++) 
       monitors[i].disable();        
    }
    
    public void enable() {
     for (int i=0;i<numRows;i++) 
       monitors[i].enable();        
    }
    
    public double getActive() {
     double value=0;
     for (int i=0;i<numRows;i++) {
       value+=monitors[i].getActive(); 
     }
     
     return value;
    }
    
    public double getAvg() { 
     double hits=getHits();
     double total=0;
     
     for (int i=0;i<numRows;i++) {
       total+=monitors[i].getTotal(); 
     }
     
     if (hits==0)
        return 0;
     else
        return total/hits;
        
    }
    
    /** This returns a weighted average */
    public double getAvgActive() {
     double weightedActive=0;
     double totalHits=0;
     
     for (int i=0;i<numRows;i++) {
       double hits=monitors[i].getHits(); 
       weightedActive=hits*monitors[i].getAvgActive();
       totalHits+=hits;
     }
        
     if (totalHits==0)
        return 0;
     else
        return weightedActive/totalHits;
    
    }
    
    public Date getFirstAccess() {
     Date firstAccess=null;
     for (int i=0;i<numRows;i++) {
       Date thisDate=monitors[i].getFirstAccess(); 
       if (firstAccess==null || thisDate.compareTo(firstAccess)<0) // thisDate<firstDate
         firstAccess=thisDate;
       
     }
     
     return firstAccess;
        
    }
    
    public double getHits() {
     double value=0;
     for (int i=0;i<numRows;i++) {
       value+=monitors[i].getHits(); 
     }
     
     return value;
        
    }
    
    public MonKey getMonKey() {
      if (!hasData())
        return null;
        
      return getFirstMon().getMonKey();
    }
    
    public Date getLastAccess() {
     Date lastAccess=null;
     for (int i=0;i<numRows;i++) {
       Date thisDate=monitors[i].getLastAccess(); 
       if (lastAccess==null || thisDate.compareTo(lastAccess)>0) // thisDate>lastAccess
         lastAccess=thisDate;
       
     }
     
     return lastAccess;

        
    }
    
    public double getLastValue() {
     Date date=getLastAccess();
     for (int i=0;i<numRows;i++) {
       if (date.compareTo(monitors[i].getLastAccess())>=0) // date>=getLastAccess)
          return monitors[i].getLastValue(); 
     }
     
     return 0;
        
    }
    
    public double getMax() {
     double max=MonInternals.MAX_DOUBLE;
     
     for (int i=0;i<numRows;i++) {
       double thisMax=monitors[i].getMax();
       
       if (thisMax>max)
         max=thisMax;
     }

     return max;
    }
    
    public double getMaxActive() {
     double max=MonInternals.MAX_DOUBLE;
     
     for (int i=0;i<numRows;i++) {
       double thisMax=monitors[i].getMaxActive();
       
       if (thisMax>max)
         max=thisMax;
     }

     return max;        
    }
    
    public double getMin() {
     double min=MonInternals.MIN_DOUBLE;
     
     for (int i=0;i<numRows;i++) {
       double thisMin=monitors[i].getMin();
       
       if (thisMin<min)
         min=thisMin;
     }

     return min;        
    }
    
    public Range getRange() {
        // Composite range???
        // if they all have the same range then return the range. else return the nullrange
        return null;
    }
    
    /** This is not a true standard deviation but a average weighted std deviation. However
      * individual monitors do have a true standard deviation
     */
    public double getStdDev() {

     double weightedStdDev=0;
     double totalHits=0;
     
     for (int i=0;i<numRows;i++) {
       double hits=monitors[i].getHits(); 
       weightedStdDev=hits*monitors[i].getStdDev();
       totalHits+=hits;
     }
        
     if (totalHits==0)
        return 0;
     else
        return weightedStdDev/totalHits;

        
    }
    
    public double getTotal() {
     double value=0;
     for (int i=0;i<numRows;i++) {
       value+=monitors[i].getTotal(); 
     }
     
     return value;        
    }
    
    
    /** It just takes one of the monitors to not be enabled for the composite to be false */
    public boolean isEnabled() {
     for (int i=0;i<numRows;i++) {
       if (!monitors[i].isEnabled()) 
         return false;
     }
     
     return true;        
    }
    
    /** It just takes one of the monitors to not be primary for the composite to be false */
    public boolean isPrimary() {
     for (int i=0;i<numRows;i++) {
       if (!monitors[i].isPrimary()) 
         return false;
     }
     
     return true;        
    }
    
    public void setActive(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setActive(0);        
    }
    
    public void setFirstAccess(java.util.Date date) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setFirstAccess(date);        
        
    }
    
    public void setHits(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setHits(value);        
    }
    
    public void setLastAccess(java.util.Date date) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setLastAccess(date);            
    }
    
    public void setLastValue(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setLastValue(value);      
    }
    
    public void setMax(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setMax(value);           
    }

    
    public void setMaxActive(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setMaxActive(value);             
        
    }
    
    public void setMin(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setMin(value);            
    }
    
    public void setPrimary(boolean isPrimary) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setPrimary(isPrimary);            
    }
    
    public void setTotal(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setTotal(value);            
    }
    
    public void setTotalActive(double value) {
     for (int i=0;i<numRows;i++) 
       monitors[i].setTotalActive(value);            
    }
    
    public Monitor start() {
     for (int i=0;i<numRows;i++) 
       monitors[i].start();   
     
     return this;
    }
    
    public Monitor stop() {
     for (int i=0;i<numRows;i++) 
       monitors[i].stop();     
     
     return this;
    } 
  
 
    private MonitorImp getFirstMon() {
        return (MonitorImp)monitors[0];
    }



	public Monitor add(double value) {
       for (int i=0;i<numRows;i++) 
          monitors[i].add(value);   
	        
	   return this;
	}


	
//	
// 	  public void addListener(String listenerType, JAMonListener listener) {
// 		 super.addListener(listenerType, listener);
//	     for (int i=0;i<numRows;i++) 
//		    monitors[i].addListener(listenerType, listener);    
//	  }
//	  
//	  public JAMonListener getListener(String listenerType) {
//			// Technically these methods of returning Listeners aren't required as tehy do default behaviours, however it makes 
//			// the behaviour more explicit now.
//		    return super.getListener(listenerType);
//	  }
//
//	public void removeListener(String listenerType) {
//		 super.removeListener(listenerType);
//	     for (int i=0;i<numRows;i++) 
//		    monitors[i].removeListener(listenerType);    	
//	}
//


//	public void addMaxListener(JAMonListener maxListener) {
//		 super.addMaxListener(maxListener);
//	     for (int i=0;i<numRows;i++) 
//		    monitors[i].addMaxListener(maxListener);               
//    }



//	public void addMinListener(JAMonListener minListener) {
//		 super.addMinListener(minListener);
//	     for (int i=0;i<numRows;i++) 
//			monitors[i].addMinListener(minListener);       
//	    
//    }



//	public void addValueListener(JAMonListener valueListener) {
//		 super.addValueListener(valueListener);
//	     for (int i=0;i<numRows;i++) 
//		    monitors[i].addMinListener(valueListener);       
//	    
//    }

	public boolean hasListeners() {
		 if (super.hasListeners())
		   return true;
		 
	     for (int i=0;i<numRows;i++) {
		    if (monitors[i].hasListeners())
		      return true;
	     }
	     
	     return false;
	    
   }


	public JAMonDetailValue getJAMonDetailRow() {
	    return JAMonDetailValue.NULL_VALUE;
    }


	public void setActivityTracking(boolean trackActivity) {
		 super.setActivityTracking(trackActivity);
	     for (int i=0;i<numRows;i++) 
			monitors[i].setActivityTracking(trackActivity);    
	    
   }




	public boolean isActivityTracking() {
	    return super.isActivityTracking();
    }




    
    
     
}
