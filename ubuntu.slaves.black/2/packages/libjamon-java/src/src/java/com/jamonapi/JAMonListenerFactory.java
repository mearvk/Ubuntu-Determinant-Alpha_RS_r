package com.jamonapi;

import java.util.*;

import com.jamonapi.utils.*;

/** <p>Factory used to hold JAMonListeners.  Developers may put any listeners that implement
 * JAMonBufferListeners.</p>
 * 
 * <p>Any listener may be retrieved by passing in the JAMonListener name.  At this time JAMon ships
 * with the following listeners that can be referenced by name.  Every buffer has a shared counterpart 
 * that allows different montiors to share the same buffer.  In every other way they are 
 * the same as their similarly named counterparts.
 * </p>
 * 
 * <p>
 * FIFOBuffer - Holds most recent objects in the buffer<br>
 * NLargestValueBuffer - Keeps the largest values in the buffer<br>
 * NSmallestValueBuffer - Keeps the smallest values in the buffer<br>
 * NLargestValueBuffer7Days - When buffer is full the oldest data in buffer that is over 7 days is removed.  If no data 
 *  is older than 7 days then the smallest is removed. <br>
 * NLargestValueBuffer24Hrs - When buffer is full the oldest data in buffer that is over 24 hours is removed.  If no data 
 *  is older than 7 days then the smallest is removed. <br>
 * NSmallestValueBuffer7Days - When buffer is full the oldest data in buffer that is over 7 days is removed.  If no data 
 *  is older than 7 days then the largest is removed. <br>
 * NSmallestValueBuffer24Hrs - When buffer is full the oldest data in buffer that is over 24 hours is removed.  If no data 
 *  is older than 7 days then the largest is removed. <br>
 * SharedFIFOBuffer - Holds most recent objects in the buffer<br>
 * SharedNLargestValueBuffer - Keeps the largest values in the buffer<br>
 * SharedNSmallestValueBuffer - Keeps the smallest values in the buffer<br>
 * SharedNLargestValueBuffer7Days - When buffer is full the oldest data in buffer that is over 7 days is removed.  If no data 
 *  is older than 7 days then the smallest is removed. <br>
 * SharedNLargestValueBuffer24Hrs - When buffer is full the oldest data in buffer that is over 24 hours is removed.  If no data 
 *  is older than 7 days then the smallest is removed. <br>
 * SharedNSmallestValueBuffer7Days - When buffer is full the oldest data in buffer that is over 7 days is removed.  If no data 
 *  is older than 7 days then the largest is removed. <br>
 * SharedNSmallestValueBuffer24Hrs - When buffer is full the oldest data in buffer that is over 24 hours is removed.  If no data 
 *  is older than 7 days then the largest is removed. <br>
 *  HTTPBufferListener - Buffer that holds data specific to http requests.<br>
 *  ExceptionBufferListener - Buffer that holds data specific to monitors that track exceptions in the detail buffer<br>
 *  
* </p>
	
 * @author steve souza
 *
 */

public class JAMonListenerFactory {
	private static final boolean NATURAL_ORDER=true;
	private static final boolean REVERSE_ORDER=false;
	
	private static String[] HEADER={"ListenerName", "Listener"};
	private static Map map=Misc.createCaseInsensitiveMap();
	
	static {
		// put factory instances into the JAMonListenerFactory
		put(getFIFO());
		put(getNLargest());
		put(getNSmallest());
		put(getNLargest7Days());
		put(getNLargest24Hrs());
		put(getNSmallest7Days());
		put(getNSmallest24Hrs());	
		
		// allows sharing buffers between monitors!
		put(getSharedFIFO());
		put(getSharedNLargest());
		put(getSharedNSmallest());
		put(getSharedNLargest7Days());
		put(getSharedNLargest24Hrs());
		put(getSharedNSmallest7Days());
		put(getSharedNSmallest24Hrs());	
        
        put(getExceptionBufferListener());
        put(getHTTPBufferListener());
		
	}
	
	/** Developers may register their own listeners to be made available for use in JAMon */
	public static void put(JAMonListener jamonListener) {
		map.put(jamonListener.getName(), jamonListener);
	}
	
	/** Returns an array of all registered JAMonListeners in the format: key, JamonListener factory instance */
	public static Object[][] getData() {
		Iterator iter=map.entrySet().iterator();
		Object[][] data=new Object[map.size()][];
		
		int i=0;
		while (iter.hasNext()) {
			data[i]=new Object[2];
			Map.Entry entry=(Map.Entry) iter.next();
			data[i][0]=entry.getKey();
			data[i][1]=entry.getValue();
			i++;
		}
		
		return data;
	}
	
	/** Returns the header for display of JAMonListeners */
	public static String[] getHeader() {
		return HEADER;
	}
	
	/** Get an instance of the named factory instance.  If the Liistener implements 
	 * CopyJAMonListener then copy will be called.  If not then the default constructor will
	 * be called.
	 * 
	 * @param listenerName
	 * @return
	 */
	public static JAMonListener get(String listenerName) {
		try {
		 JAMonListener factoryInstance =(JAMonListener)map.get(listenerName);
		 if (factoryInstance instanceof CopyJAMonListener) {
			 return ((CopyJAMonListener)factoryInstance).copy();
		 }  else {
		   JAMonListener newInst = (JAMonListener)factoryInstance.getClass().newInstance(); 
		   newInst.setName(factoryInstance.getName());
		   return newInst;
		 }
		 
		} catch (Exception e) {
			throw new RuntimeException("Error getting listener from factory: "+listenerName+", "+e);
		}
		
	}
	
	// Various factory methods used to populate the JAMonListenerFactory with default
	// JAMonBufferListeners
	
	private static BufferHolder getBufferHolderNLargest7Days() {
		// Keeps only the largest values within 7 days.
		JAMonArrayComparator jac=new JAMonArrayComparator();
		DateMathComparator dmc=new DateMathComparator(Calendar.DAY_OF_YEAR, -7);
		jac.addCompareCol(JAMonBufferListener.DATE_COL, dmc);
		jac.addCompareCol(JAMonBufferListener.VALUE_COL, NATURAL_ORDER);
		
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(jac);
		return bufferHolder;
	}
	
	private static BufferHolder getBufferHolderNLargest24Hrs() {
		// Keeps only the largest values within 24 hrs.
		JAMonArrayComparator jac=new JAMonArrayComparator();
		DateMathComparator dmc=new DateMathComparator(Calendar.HOUR_OF_DAY, -24);
		jac.addCompareCol(JAMonBufferListener.DATE_COL, dmc);
		jac.addCompareCol(JAMonBufferListener.VALUE_COL, NATURAL_ORDER);
		
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(jac);
		return bufferHolder;
	}
	

	private static BufferHolder getBufferHolderNSmallest7Days() {
		// Keeps only the smallest values within 7 days.
		JAMonArrayComparator jac=new JAMonArrayComparator();
		DateMathComparator dmc=new DateMathComparator(Calendar.DAY_OF_YEAR, -7);
		jac.addCompareCol(JAMonBufferListener.DATE_COL, dmc);
		jac.addCompareCol(JAMonBufferListener.VALUE_COL, REVERSE_ORDER);
		
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(jac);
		return bufferHolder;
	
	}

	private static BufferHolder getBufferHolderNSmallest24Hrs() {
		// Keeps only the smallest values within 24 hrs.
		JAMonArrayComparator jac=new JAMonArrayComparator();
		DateMathComparator dmc=new DateMathComparator(Calendar.HOUR_OF_DAY, -24);
		jac.addCompareCol(JAMonBufferListener.DATE_COL, dmc);
		jac.addCompareCol(JAMonBufferListener.VALUE_COL, REVERSE_ORDER);
		
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(jac);
		return bufferHolder;
		
	}

	
	private static JAMonBufferListener getFIFO() {
		BufferHolder bufferHolder=new FIFOBufferHolder();
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER,bufferHolder);
		return new JAMonBufferListener("FIFOBuffer", bufferList);
	}

	private static JAMonBufferListener getNLargest() {
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(NATURAL_ORDER, JAMonBufferListener.VALUE_COL);
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, bufferHolder);
		return new JAMonBufferListener("NLargestValueBuffer", bufferList);
		
	}
	
	private static JAMonBufferListener getNSmallest() {
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(REVERSE_ORDER, JAMonBufferListener.VALUE_COL);
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, bufferHolder);
		return new JAMonBufferListener("NSmallestValueBuffer", bufferList);
		
	}

	
	private static JAMonBufferListener getNLargest7Days() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNLargest7Days());
		return new JAMonBufferListener("NLargestValueBuffer7Days", bufferList);
	
	}
	
	private static JAMonBufferListener getNLargest24Hrs() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNLargest24Hrs());
		return new JAMonBufferListener("NLargestValueBuffer24Hrs", bufferList);
		
	}	
	

	
	private static JAMonBufferListener getNSmallest7Days() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNSmallest7Days());
		return new JAMonBufferListener("NSmallestValueBuffer7Days", bufferList);

	}	
	
	private static JAMonBufferListener getNSmallest24Hrs() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNSmallest24Hrs());
		return new JAMonBufferListener("NSmallestValueBuffer24Hrs", bufferList);
		
	}
	
	private static JAMonBufferListener getSharedFIFO() {
		BufferHolder bufferHolder=new FIFOBufferHolder();
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER,bufferHolder);
		return new SharedJAMonBufferListener("SharedFIFOBuffer", bufferList);
	}

	private static JAMonBufferListener getSharedNSmallest() {
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(REVERSE_ORDER, JAMonBufferListener.VALUE_COL);
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, bufferHolder);
		return new SharedJAMonBufferListener("SharedNSmallestValueBuffer", bufferList);
		
	}
	
	
	private static JAMonBufferListener getSharedNLargest()  {
		BufferHolder bufferHolder=new NExtremeArrayBufferHolder(NATURAL_ORDER, JAMonBufferListener.VALUE_COL);
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, bufferHolder);
		return new SharedJAMonBufferListener("SharedNLargestValueBuffer", bufferList);
		
	}
	
	private static JAMonBufferListener getSharedNLargest7Days() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNLargest7Days());
		return new SharedJAMonBufferListener("SharedNLargestValueBuffer7Days", bufferList);
	
	}
	
	private static JAMonBufferListener getSharedNLargest24Hrs() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNLargest24Hrs());
		return new SharedJAMonBufferListener("SharedNLargestValueBuffer24Hrs", bufferList);
		
	}	

	private static JAMonBufferListener getSharedNSmallest7Days() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNSmallest7Days());
		return new SharedJAMonBufferListener("SharedNSmallestValueBuffer7Days", bufferList);

	}	
	
	private static JAMonBufferListener getSharedNSmallest24Hrs() {
		BufferList bufferList=new BufferList(JAMonBufferListener.DEFAULT_HEADER, getBufferHolderNSmallest24Hrs());
		return new SharedJAMonBufferListener("SharedNSmallestValueBuffer24Hrs", bufferList);
		
	}

    
    private static JAMonBufferListener getExceptionBufferListener() {
        String[] header=new String[] {"Label","Exception", "LastValue","Active","Date"};
        BufferHolder bufferHolder=new FIFOBufferHolder();
        BufferList bufferList=new BufferList(header,bufferHolder);
        return new JAMonArrayBufferListener("ExceptionBufferListener", bufferList);
    }
    
    private static JAMonBufferListener getHTTPBufferListener() {
        String[] header=new String[] {"Label","Exception", "LastValue","Active","Date"};
        BufferHolder bufferHolder=new FIFOBufferHolder();
        BufferList bufferList=new BufferList(header,bufferHolder);
        return new JAMonArrayBufferListener("HTTPBufferListener", bufferList);
    }

	// called from main method for testing purposes
    private static void testArray(String label, int dateToAdd, boolean increase) {
    	  System.out.print("\n\n****"+label);
    	  JAMonBufferListener jbl=(JAMonBufferListener)get(label);
    	  BufferList bl=jbl.getBufferList();


       	  Calendar cal=new GregorianCalendar();
       	  if (increase) {
    	    for (int i=1,j=-50;i<=100;i++,j++) {
    		  cal.setTime(new Date());
  		      cal.add(dateToAdd, j);
    	      bl.addRow(new Object[]{"label"+i,new Integer(i),"Active"+i,cal.getTime()});
    	    }
    	    
       	  } else {
         	for (int i=100,j=50;i>=1;i--,j--) {
          	  cal.setTime(new Date());
        	  cal.add(dateToAdd, j);
          	  bl.addRow(new Object[]{"label"+i,new Integer(i),"Active"+i,cal.getTime()});
          	}
     	
       	  }
	  
       	    // firstVal will be under date threshold, and secondVal will exceed it.
       	    int firstVal=-5;
       	    int secondVal=-10;
       	    
       	    if (dateToAdd==Calendar.HOUR_OF_DAY) {
       	    	firstVal=-12;
       	    	secondVal=-36;
       	    }
       	    	
    	    cal.setTime(new Date());
    	    cal.add(dateToAdd, firstVal);
  	        bl.addRow(new Object[]{"label",new Integer(1000),"Active",cal.getTime()});
  		 	
      	    cal.setTime(new Date());
    	    cal.add(dateToAdd, firstVal);
  	        bl.addRow(new Object[]{"label",new Integer(-1000),"Active",cal.getTime()});
  		 	
     	    cal.setTime(new Date());
    	    cal.add(dateToAdd, secondVal);
  	        bl.addRow(new Object[]{"label",new Integer(1000),"Active",cal.getTime()});
  		 	
      	    cal.setTime(new Date());
    	    cal.add(dateToAdd, secondVal);
  	        bl.addRow(new Object[]{"label",new Integer(-1000),"Active",cal.getTime()});
  		 	
    	    Misc.disp(bl.getData());
    	  
    	  
      }
      


	
	public static void main(String[] args) {
		System.out.println("/n*****Testing JAMonListenerFactory.main()");
		put(new CompositeListener("tester"));
		put(new JAMonBufferListener("helloListener", new BufferList(new String[]{"hey"},200)));
		String[] header=getHeader();
		Object[][] data=getData();
		for (int i=0;i<data.length;i++)
			for (int j=0;j<data[i].length;j++)
				System.out.println(header[j]+"="+data[i][j]);
		
		System.out.println("\ngetting listener="+get("FIFOBuffer"));
		JAMonBufferListener jbl=(JAMonBufferListener)get("helloListener");
		System.out.println("name="+jbl.getName()+", buffer="+jbl.getBufferList().getBufferSize());
		
		// The following tests run buffers with data inserted in natural, and 
		// reverse order to see if both work.
		testArray("FIFOBuffer", Calendar.DAY_OF_YEAR, true);
		testArray("FIFOBuffer", Calendar.DAY_OF_YEAR,false);
		testArray("NLargestValueBuffer", Calendar.DAY_OF_YEAR,true);
		testArray("NLargestValueBuffer", Calendar.DAY_OF_YEAR,false);
		testArray("NSmallestValueBuffer", Calendar.DAY_OF_YEAR,true);
		testArray("NSmallestValueBuffer", Calendar.DAY_OF_YEAR,false);
		testArray("NLargestValueBuffer7Days", Calendar.DAY_OF_YEAR,true);
		testArray("NLargestValueBuffer7Days", Calendar.DAY_OF_YEAR,false);
		testArray("NSmallestValueBuffer7Days", Calendar.DAY_OF_YEAR,true);
		testArray("NSmallestValueBuffer7Days",Calendar.DAY_OF_YEAR, false);
		testArray("NLargestValueBuffer24Hrs", Calendar.HOUR_OF_DAY,false);
		testArray("NSmallestValueBuffer24Hrs", Calendar.HOUR_OF_DAY,true);

		}
	
    
 
   
}
