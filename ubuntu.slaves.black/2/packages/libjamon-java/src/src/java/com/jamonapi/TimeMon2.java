package com.jamonapi;

/**
 * Class that keeps time from the Factories but does not save it.  Note this object
 *should not be reused.  You should always get a new instance from MonitorFactory.
 *
 * Created on February 19, 2006, 9:05 AM
 */


import java.util.*;
import com.jamonapi.utils.*;


final class TimeMon2 extends TimeMon {
    
    public TimeMon2() {
    	super(new MonKeyImp("timer","ms."),new MonInternals());
    	monData.activityStats=new ActivityStats();
    	monData.isTimeMonitor=true;
    }

  
    
    public String toString() {
        return getLastValue()+" ms.";
    }
    
    
    private static void testDisplay(String name, JAMonListener listener) {
       System.out.print("\n\n***"+name);
       Object[][] data=((JAMonBufferListener)listener).getDetailData().getData();
       for (int i=0;i<data.length;i++) {
    	   System.out.println();
    	   for (int j=0;j<data[i].length;j++)
    		   System.out.print(data[i][j]+", ");
       }
    }
    
	public static void main(String[] args) throws Exception {
		TimeMon mon=new TimeMon2();
		mon.getListenerType("value").addListener(new JAMonBufferListener("first"));
		mon.getListenerType("value").addListener(new JAMonBufferListener("second"));
		
		mon.getListenerType("value").removeListener("first");
		mon.getListenerType("value").removeListener("second");
		
		mon.add(40);
		System.out.println(mon);

		mon.getListenerType("value").addListener(new JAMonBufferListener("1"));
		mon.getListenerType("max").addListener(new JAMonBufferListener("2"));
		mon.getListenerType("min").addListener(new JAMonBufferListener("3"));
		mon.getListenerType("maxactive").addListener(new JAMonBufferListener("4"));
		
		for (int i=0;i<50;i++) {
			mon.start();
			Thread.sleep(i);
			mon.stop();
		}
		
		mon.start().start().start().stop().stop().stop();

		for (int i=0;i<50;i++) {
			mon.start();
			Thread.sleep(i);
			mon.stop();
		}

		testDisplay("value", mon.getListenerType("value").getListener());
		testDisplay("max", mon.getListenerType("max").getListener());
		testDisplay("min", mon.getListenerType("min").getListener());
		testDisplay("maxactive", mon.getListenerType("maxactive").getListener());

	}
	

    
}
