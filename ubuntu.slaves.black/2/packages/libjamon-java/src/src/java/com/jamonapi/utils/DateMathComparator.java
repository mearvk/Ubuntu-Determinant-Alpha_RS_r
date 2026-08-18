package com.jamonapi.utils;

import java.util.*;

/** Comparator that allows you to pass Calendar fields and a negative number for the number 
 * of this filed (i.e. hours/days) that a Date should not exceed.  Use fields like Calendar.DATE, HOUR_OF_DAY, DAY_OF_MONTH, DAY_OF_WEEK, DAY_OF_YEAR ETC.
 * .  Values to b used for dateToAdd in the constructor could be -7 for 7 days ago, or -24 for 24 hours ago depending on what 
 * was passed in the dateField.
 * 
 * @author steve souza
 *
 */
public class DateMathComparator extends JAMonComparator {
	private int dateField;
	private int dateToAdd;
	/**Use fields like Calendar.DATE, HOUR_OF_DAY, DAY_OF_MONTH, DAY_OF_WEEK, DAY_OF_YEAR ETC.*/
	private Calendar calendar=new GregorianCalendar();


	private static final boolean NATURAL_ORDER=true;

	public DateMathComparator(int dateField, int dateToAdd) {
		super(NATURAL_ORDER);
		this.dateField=dateField;
		this.dateToAdd=dateToAdd;
	}
	
	protected int compareThis(Object o1, Object o2) {
		int retVal=0;
		if (o1 instanceof Date && o2 instanceof Date) {
			Date d1=(Date)o1;
			Date d2=(Date)o2;
			
			calendar.setTime(new Date());
		    calendar.add(dateField, dateToAdd);// i.e. todays date -7 days
		    Date dateAddValue=calendar.getTime();
		    
		    // 2 dates are equal if they are both above or below the Calendar field threshold
		    // else date1 is greater if it is greater than threshold and date2 isn't
		    // and date1 is less than the threshold than it is greater than date2.
		    int d1CompNum=d1.compareTo(dateAddValue);
		    int d2CompNum=d2.compareTo(dateAddValue);
		    
		    if (d1CompNum<=-1 && d2CompNum<=-1)
		    	return 0;
		    else if (d1CompNum>=1 && d2CompNum>=1)
		    	return 0;
		    else if (d1CompNum==1)
		    	return 1;
		    else if (d1CompNum==-1)
		    	return -1;
		}

		return retVal;
			
		
	}
	
	/** Test code */
	public static void main(String[] arg) {
		//7 DAYS
		//24 HOURS
		Date today=new Date();
		
		Calendar calendar=new GregorianCalendar();
		calendar.setTime(today);
		calendar.add(Calendar.DAY_OF_YEAR, -8);
		Date minus8Days=calendar.getTime();
		System.out.println(new DateMathComparator(Calendar.DAY_OF_YEAR, -7).compare(today, minus8Days));
	
		calendar.setTime(today);
		calendar.add(Calendar.DAY_OF_YEAR, -6);
		Date minus6Days=calendar.getTime();
		System.out.println(new DateMathComparator(Calendar.DAY_OF_YEAR, -7).compare(today, minus6Days));

		calendar.setTime(today);
		calendar.add(Calendar.HOUR_OF_DAY, -6);
		Date minus6Hours=calendar.getTime();
		System.out.println(new DateMathComparator(Calendar.HOUR_OF_DAY, -7).compare(today, minus6Hours));

		calendar.setTime(today);
		calendar.add(Calendar.HOUR_OF_DAY, -8);
		Date minus8Hours=calendar.getTime();
		System.out.println(new DateMathComparator(Calendar.HOUR_OF_DAY, -7).compare(today, minus8Hours));

	}

}
