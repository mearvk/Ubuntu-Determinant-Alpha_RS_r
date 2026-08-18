# Define useful Java-related variables. May be overridden by the package.
# In particular, JAVA_HOME should be overridden before including this file,
# so that it can give JRE_HOME and the CLIENT/SERVER dirs relative to the
# correct JAVA_HOME
#

# The root of the JDK installation
JAVA_HOME?=/usr/lib/jvm/default-java

DPKG_ARCH=$(shell dpkg-architecture -qDEB_BUILD_ARCH | cut -d- -f2)

# Architecture that sun uses for libjvm.so directory etc
JAVA_ARCH=$(shell /usr/share/javahelper/java-arch.sh $(DPKG_ARCH))

# Location of the JRE (JRE sub-directory or not?)
JRE_HOME=$(shell if [ -d $(JAVA_HOME)/jre ]; then echo $(JAVA_HOME)/jre; else echo $(JAVA_HOME); fi )

# may or may not be set, depends if the JVM ships a server VM or not
JVM_CLIENT_DIR=$(shell if [ -d $(JRE_HOME)/lib/$(JAVA_ARCH)/client ]; then echo $(JRE_HOME)/lib/$(JAVA_ARCH)/client; else if [ -d $(JRE_HOME)/lib/client ]; then echo $(JRE_HOME)/lib/client; fi; fi )
JVM_SERVER_DIR=$(shell if [ -d $(JRE_HOME)/lib/$(JAVA_ARCH)/server ]; then echo $(JRE_HOME)/lib/$(JAVA_ARCH)/server; else if [ -d $(JRE_HOME)/lib/server ]; then echo $(JRE_HOME)/lib/server; fi; fi )

#print-vars:
#	@echo "JAVA_HOME      : $(JAVA_HOME)"
#	@echo "JAVA_ARCH      : $(JAVA_ARCH)"
#	@echo "JRE_HOME       : $(JRE_HOME)"
#	@echo "JVM_CLIENT_DIR : $(JVM_CLIENT_DIR)"
#	@echo "JVM_SERVER_DIR : $(JVM_SERVER_DIR)"
