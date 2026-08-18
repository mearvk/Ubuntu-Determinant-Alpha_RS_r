package com.jamonapi.aop;


import javax.interceptor.AroundInvoke;
import javax.interceptor.InvocationContext;
import com.jamonapi.MonitorFactory;
import com.jamonapi.Monitor;
import com.jamonapi.MonKeyImp;
import com.jamonapi.utils.Misc;

public class JAMonEJBInterceptor {
       private static final String EXCEPTION_STR="JAMonEJBInterceptor.EJBException";
       private static final int EXCEPTION=1;

       @AroundInvoke
       public Object intercept(InvocationContext ctx) throws Exception {
          Object[] details=null;
          Monitor mon=null;
          String label=null;

          try
          { 
             label=new StringBuffer("JAMonEJBInterceptor: ").append(ctx.getTarget().getClass().getName()).append(".").append(ctx.getMethod().getName()).toString();
             details=new Object[] {label, ""};
             mon=MonitorFactory.start(new MonKeyImp(label, details, "ms."));
             return ctx.proceed();
          } catch (Exception e) {
              details[EXCEPTION]=Misc.getExceptionTrace(e);
              MonitorFactory.add(new MonKeyImp(EXCEPTION_STR, details, "Exception"), 1); 
              MonitorFactory.add(new MonKeyImp(MonitorFactory.EXCEPTIONS_LABEL, details, "Exception"), 1);  
              throw e;
          }
          finally
          {
             mon.stop();
          }
       }
       
       public String delme(String hello) throws Exception {
           return "hello";
       }
       public static void main(String[] args) throws Exception {
           JAMonEJBInterceptor o=new JAMonEJBInterceptor();
           System.out.println(o.getClass().getMethod("delme", new Class[]{String.class}));
       }
       
       

}
