package com.jamonapi.log4j;

import java.util.Properties;

import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.Logger;
import com.jamonapi.MonitorFactory;

import com.jamonapi.utils.Misc;

public class Log4jTester {

    private static Properties getDefaultProps() {
        // # Set root logger level to DEBUG and its only appender to A1.
        Properties properties = new Properties();
        properties.put("log4j.logger.com.jamonapi.log4j", "DEBUG, A1, jamonAppender");

        // # A1 is set to be a ConsoleAppender, and A2 uses JAMonAppender.
        properties.put("log4j.appender.A1", "org.apache.log4j.ConsoleAppender");

        properties.put("log4j.appender.jamonAppender", "com.jamonapi.log4j.JAMonAppender");

        properties.put("log4j.appender.jamonAppender.units", "testlog4jUnits");
        properties.put("log4j.appender.jamonAppender.enableDefaultGeneralizer", "true");

        properties.put("log4j.appender.jamonAppender.EnableListeners", "BASIC");
        properties.put("log4j.appender.jamonAppender.EnableListenerDetails", "true");

        properties.put("log4j.appender.jamonAppender.EnableLevelMonitoring", "true");
        properties.put("log4j.appender.jamonAppender.ListenerBufferSize", "200");

        // # jamonAppender uses PatternLayout.
        properties.put("log4j.appender.A1.layout", "org.apache.log4j.PatternLayout");
        properties.put("log4j.appender.A1.layout.ConversionPattern",
                "%-4r steve [%t] %-5p %c %x - %m%n");

        // # A1 uses PatternLayout.
        properties.put("log4j.appender.jamonAppender.layout", "org.apache.log4j.PatternLayout");
        properties.put("log4j.appender.jamonAppender.layout.ConversionPattern", "%p.%c.%m");

        return properties;
    }

    public static void main(String[] args) throws Exception {
        PropertyConfigurator.configure(getDefaultProps());
        Logger log1 = Logger.getLogger("com.jamonapi.log4j");

        for (int i = 0; i < 5; i++) {
            log1.debug("message " + i);
            log1.error("message " + i);
            log1.info("message " + i);
        }

        Misc.disp(MonitorFactory.getRootMonitor().getData());

        for (int i = 0; i < 5; i++) {
            log1.debug("message " + i);
            log1.error("message " + i);
            log1.info("message " + i);
        }
        Misc.disp(MonitorFactory.getRootMonitor().getData());

    }
}
