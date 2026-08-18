/** 
 * 
 *
 * Created on January 22, 2006, 11:11 AM
 */

package com.jamonapi;



import java.util.List;

 
abstract class FrequencyDistImp extends MonitorImp implements FrequencyDist {


    protected double endValue;
    
     public List getBasicHeader(List header) {
         // Frequencies don't get displayed basic headers.
         return header;
     }

    
    
     public List getHeader(List header) {
    	 super.getHeader(header);
         header.add(monData.name+"AvgActive");
         header.add(monData.name+"AvgPrimaryActive");
         header.add(monData.name+"AvgGlobalActive");
        
         return header;
         
     }   
     
     public List getDisplayHeader(List header) {
         header.add(monData.displayHeader);
         return header;
     }      

    public List getBasicRowData(List rowData) {
        // This is not called as basic rowdata doesn't inlcude frequencydists
         return rowData;
     }
     
     
    public List getRowData(List rowData) {
    	super.getRowData(rowData);
    	rowData.add(new Double(getAvgActive()));
        rowData.add(new Double(getAvgPrimaryActive()));
        rowData.add(new Double(getAvgGlobalActive()));
        
        return rowData;
        

        
    }
    
    public List getRowDisplayData(List rowData) {
          rowData.add(toString());
          return rowData;
          
    }
 
    public double getEndValue() {
            return endValue;
    }   
  
     
     
}
