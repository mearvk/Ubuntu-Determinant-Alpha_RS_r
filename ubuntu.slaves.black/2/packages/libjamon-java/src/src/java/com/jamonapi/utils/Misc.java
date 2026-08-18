package com.jamonapi.utils;



/** Difficult to group Utilities **/

import java.util.*;
import java.text.*;

import com.jamonapi.Monitor;


public class Misc extends java.lang.Object {
    /** Returns an Objects ClassName minus the package name
     *  Sample Call:
     *      String className=Misc.getClassName("My Object"); // returns "String"
     **/
    public static String getClassName(Object object) {
        String className = (object==null ? "null" : object.getClass().getName());  // gov.gsa.fss.fim.Misc
        return className.substring(className.lastIndexOf(".")+1);    // Misc
    }
    
	// Return Exception information as a row (1 dim array)
	public static String getExceptionTrace(Throwable exception) {

		// each line of the stack trace will be returned in the array.
		StackTraceElement elements[] = exception.getStackTrace();
		StringBuffer trace = new StringBuffer().append(exception).append("\n");

		for (int i = 0; i < elements.length; i++) {
			trace.append(elements[i]).append("\n");
		}

		return trace.toString();
	}
    
    /** Note if the passed object is a Colleciton itself or an Object[] it will be expanded*/
    public static void addTo(Collection coll, Object objToAdd) {
        if (objToAdd instanceof Collection)
           coll.addAll((Collection)objToAdd);
        else if (objToAdd instanceof Object[])
            coll.addAll(Arrays.asList((Object[])objToAdd));
        else if (objToAdd instanceof ToArray)
            coll.addAll(Arrays.asList(((ToArray)objToAdd).toArray()));
        else 
            coll.add(objToAdd);
    }
    
    public static String getAsString(Object obj) {
        if (obj==null)
          return null;
        else if (obj instanceof Collection)
          return getCollAsString((Collection)obj);
        else if (obj instanceof Object[])
          return getArrAsString((Object[]) obj);
        else if (obj instanceof ToArray)
          return getArrAsString(((ToArray)obj).toArray());
        else if (obj instanceof Throwable)
          return getExceptionTrace((Throwable)obj);
        else    
          return obj.toString();
    }
    
    private static String getCollAsString(Collection coll) {
        int currentElement=1;
        int lastElement=coll.size();
        Iterator iter=coll.iterator();
        StringBuffer buff=new StringBuffer();
        
        // loop through elements creating a comma delimeted list of the values
        while(iter.hasNext()) {
            Object obj=iter.next();
            if (obj instanceof Throwable)
              obj=getExceptionTrace((Throwable)obj);

            buff.append(obj);
            if (currentElement!=lastElement)
                buff.append(",\n");
            
            currentElement++;
        }
        
        return buff.toString();
        
        
    }

    private static String getArrAsString(Object[] arr) {        
        int lastElement=arr.length-1;
        StringBuffer buff=new StringBuffer();
        
        for (int i=0;i<arr.length;i++) {
          Object obj=arr[i];
          if (obj instanceof Throwable)
            obj=getExceptionTrace((Throwable)obj);

          buff.append(obj);
          if (i!=lastElement)
            buff.append(",\n");
        }
        
        return buff.toString();

    }
    
    
    public static void isObjectString(Object arg) {
        if (!(arg instanceof String))
            throw new IllegalArgumentException("Illegal Argument exception: This object must be of type String.");
    }
    
    /** Sort a 2 dimensional array based on 1 columns data in either ascending or descending order.
     *  array - Array to be sorted
     *  sortCol - column to sort by
     *  sortOrder - sort the column in ascending or descending order.  Valid arguments are "asc" and "desc".
     **/
    public static Object[][] sort(Object[][] array, int sortCol, String sortOrder) {
        ArraySorter sorter=new ArraySorter(array, sortCol, sortOrder); 
        return sorter.sort();
    }
    
    public static void disp(Object[][] data) {
    	for (int i=0;i<data.length;i++) {
    		System.out.println();
    		System.out.print("row="+i+", data=");
    		for (int j=0;j<data[i].length;j++)
    			System.out.print(data[i][j]+",");
    	}
    	
		System.out.println();
    	
    }
    
    public static Object[][] allocateArray(int rows, int cols) {
     if (rows<=0 || cols<=0)
    	return null;
     
   	  Object[][] data=new Object[rows][];
	  for(int i=0;i<cols;i++)
	   data[i]=new Object[cols];
		
	  return data;
    }
    
    /** Formats todays date with the passed in date format String.  See the main method for sample Formats */
    public static String getFormattedDateNow(String format) {
        return getFormattedDate(format, new Date());
    }
    
    /** Formats the passed in date with the passed in date format String.  See the main method for 
      * sample Formats.  */
    public static String getFormattedDate(String format, Date date) {
      return new SimpleDateFormat(format).format(date);    // 02
        
    }
    
    private static Format monthFormat=new SimpleDateFormat("MM");
    /** Get the month out of the passed in Date.  It would return 05 if you passed in the date
     *  05/15/2004
     */
    public static String getMonth(Date date) {
        return monthFormat.format(date);
    } 

    /** Return the 2 digit month of todays date     */
    public static String getMonth() {
        return getMonth(new Date());
    }
    
    private static Format dayOfWeekFormat=new SimpleDateFormat("E");
    /** Return the day of week from the passed in Date.  For example Mon for Monday. */
    public static String getDayOfWeek(Date date) {
        return dayOfWeekFormat.format(date);
    }
    /** Get the day of week for today.  For example Mon for Monday. */
    public static String getDayOfWeek() {
        return getDayOfWeek(new Date());
    }
    
    private static Format shortDateFormat=new SimpleDateFormat("MM/dd/yy");
    /** Get the short date for the passed in day.  i.e 05/15/04 */
    public static String getShortDate(Date date) {
        return shortDateFormat.format(date);
    }
    /** Get the short date for Today.  i.e 05/15/04 */
    public static String getShortDate() {
        return getShortDate(new Date());
    }
    
    
    /** Create a case insenstive Tree Map.  More of a standard implementation that I wasn't aware
     * of when creating AppMap.  It may only be able to handle Strings as a key.  That isn't clear */
    public static Map createCaseInsensitiveMap() {
        return new TreeMap(String.CASE_INSENSITIVE_ORDER); 
    }
    
    
    
 public static void main(String[] args) {
    Format formatter;
          // Get today's date
    Date date = new Date();
    
    // examples using shorter functions
    System.out.println("month="+getMonth(date));
    System.out.println("dayofweek="+getDayOfWeek(date));
    System.out.println("shortdate="+getShortDate(date));
    System.out.println("formatteddate="+getFormattedDate("dd-MMM-yy",date));
    System.out.println("month="+getMonth());
    System.out.println("dayofweek="+getDayOfWeek());
    System.out.println("shortdate="+getShortDate());
    // The year
    formatter = new SimpleDateFormat("yy");    // 02
    System.out.println("yy="+formatter.format(date));

    formatter = new SimpleDateFormat("yyyy");  // 2002
    System.out.println("yyyy="+formatter.format(date));
    
    // The month
    formatter = new SimpleDateFormat("M");     // 1
    System.out.println("M="+formatter.format(date));

    formatter = new SimpleDateFormat("MM");    // 01
    System.out.println("MM="+formatter.format(date));

    formatter = new SimpleDateFormat("MMM");   // Jan
    System.out.println("MMM="+formatter.format(date));

    formatter = new SimpleDateFormat("MMMM");  // January
    System.out.println("MMMM="+formatter.format(date));
    
    // The day
    formatter = new SimpleDateFormat("d");     // 9
    System.out.println("d="+formatter.format(date));

    formatter = new SimpleDateFormat("dd");    // 09
    System.out.println("dd="+formatter.format(date));
    
    // The day in week
    formatter = new SimpleDateFormat("E");     // Wed
    System.out.println("E="+formatter.format(date));

    formatter = new SimpleDateFormat("EEEE");  // Wednesday
    System.out.println("EEEE="+formatter.format(date));
    

    
    // Some examples
    formatter = new SimpleDateFormat("MM/dd/yy");
    System.out.println("MM/dd/yy="+formatter.format(date));
    // 01/09/02
    
    formatter = new SimpleDateFormat("dd-MMM-yy");
    System.out.println("dd-MMM-yy="+formatter.format(date));
    // 29-Jan-02
    
    // Examples with date and time; see also
    // e316 Formatting the Time Using a Custom Format
    formatter = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
    System.out.println("yyyy.MM.dd.HH.mm.ss="+formatter.format(date));
    // 2002.01.29.08.36.33
    
    formatter = new SimpleDateFormat("E, dd MMM yyyy HH:mm:ss Z");
    System.out.println("E, dd MMM yyyy HH:mm:ss Z="+formatter.format(date));
    // Tue, 09 Jan 2002 22:14:02 -0500
    
    Map m=createCaseInsensitiveMap();
    m.put("Steve", "Souza");
    m.put("STEVE", "Souza");
    System.out.println("Should return 'Souza': "+m.get("StEvE"));
    System.out.println("Map="+m);

    }
    
}

