package com.jamonapi;


import com.jamonapi.utils.BufferList;


public class JAMonArrayBufferListener extends JAMonBufferListener {

        /**
         * Constructor that creaates this object with its default name (the class
         * name)
         */
        public JAMonArrayBufferListener() {
            super("JAMonArrayBufferListener");
        }

        /** Pass in the jamonListener name */
        public JAMonArrayBufferListener(String name) {
            super(name);
        }

        /** Name the listener and pass in the jamon BufferList to use */
        public JAMonArrayBufferListener(String name, BufferList list) {
            super(name, list);
        }


        /**
         * When this event is fired the monitor will be added to the rolling buffer.
         * If it is a log4j monitor the buffer will be specific to log4j fields
         * (i.e.LoggingEvent info such as threadname, formattedmessage, exception
         * stack trace and a few others. If it is not then the super class's
         * processEvent is called.
         * 
         */
        public void processEvent(Monitor mon) {
            JAMonDetailValue jamDetail=mon.getJAMonDetailRow();
            jamDetail.setKeyToString(false);
            addRow(jamDetail);
        }


        /** Makes a usable copy of this BufferListener */
        public JAMonListener copy() {
            return new JAMonArrayBufferListener(getName(), getBufferList().copy());
        }



}
