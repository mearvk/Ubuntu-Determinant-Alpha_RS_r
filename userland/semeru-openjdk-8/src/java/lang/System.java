/*
 * Copyright IBM Corp. and others 1998
 *
 * This program and the accompanying materials are made available under
 * the terms of the Eclipse Public License 2.0 which accompanies this
 * distribution and is available at https://www.eclipse.org/legal/epl-2.0/
 * or the Apache License, Version 2.0 which accompanies this distribution and
 * is available at https://www.apache.org/licenses/LICENSE-2.0.
 *
 * This Source Code may also be made available under the following
 * Secondary Licenses when the conditions for such availability set
 * forth in the Eclipse Public License, v. 2.0 are satisfied: GNU
 * General Public License, version 2 with the GNU Classpath
 * Exception [1] and GNU General Public License, version 2 with the
 * OpenJDK Assembly Exception [2].
 *
 * [1] https://www.gnu.org/software/classpath/license.html
 * [2] https://openjdk.org/legal/assembly-exception.html
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0-only WITH Classpath-exception-2.0 OR GPL-2.0-only WITH OpenJDK-assembly-exception-1.0
 */
package java.lang;

import com.ibm.oti.util.Msg;

import java.io.*;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Properties;
import java.util.PropertyPermission;
import java.security.*;
import java.lang.reflect.Method;
import java.lang.reflect.Constructor;

import sun.misc.Unsafe;
import sun.misc.SharedSecrets;
import sun.misc.VM;
import sun.reflect.CallerSensitive;

/**
 * Class System provides a standard place for programs
 * to find system related information. All System API
 * is static.
 *
 * @author		OTI
 * @version		initial
 */
public final class System {

	// The standard input, output, and error streams.
	// Typically, these are connected to the shell which
	// ran the Java program.
	/**
	 * Default input stream
	 */
	public static final InputStream in = null;

	/**
	 * Default output stream
	 */
	public static final PrintStream out = null;
	/**
	 * Default error output stream
	 */
	public static final PrintStream err = null;

	//Get a ref to the Runtime instance for faster lookup
	private static final Runtime RUNTIME = Runtime.getRuntime();
	/**
	 * The System Properties table.
	 */
	private static Properties systemProperties;

	/**
	 * The System default SecurityManager.
	 */
	private static SecurityManager security;

	private static volatile Console console;
	private static volatile boolean consoleInitialized;

	private static String lineSeparator;

	private static boolean propertiesInitialized;

	private static final int sysPropID_PlatformEncoding = 1;
	private static String platformEncoding;

	private static final int sysPropID_FileEncoding = 2;
	private static String fileEncoding;

	private static final int sysPropID_OSEncoding = 3;
	private static String osEncoding;

	// Initialize all the slots in System on first use.
	static {
		/* Get following system properties in clinit and make it available via static variables
		 * at early boot stage in which System is not fully initialized
		 * os.version, os.encoding, ibm.system.encoding/sun.jnu.encoding, file.encoding
		 */
		platformEncoding = getSysPropBeforePropertiesInitialized(sysPropID_PlatformEncoding);
		String definedOSEncoding = getSysPropBeforePropertiesInitialized(sysPropID_OSEncoding);
		String definedFileEncoding = getSysPropBeforePropertiesInitialized(sysPropID_FileEncoding);
		if (definedFileEncoding != null) {
			fileEncoding = definedFileEncoding;
			// if file.encoding is defined, and os.encoding is not, use the detected
			// platform encoding for os.encoding
			if (definedOSEncoding == null) {
				osEncoding = platformEncoding;
			}
		} else {
			fileEncoding = platformEncoding;
		}
		// if os.encoding is not defined, file.encoding will be used
		if (osEncoding == null) {
			osEncoding = definedOSEncoding;
		}

	}

	/*
	 * Return the Charset name of the primary encoding, if different from the default.
	 */
	private static String getCharsetName(String primary, Charset defaultCharset) {
		if (primary != null) {
			try {
				Charset newCharset = Charset.forName(primary);
				if (newCharset.equals(defaultCharset)) {
					return null;
				} else {
					return newCharset.name();
				}
			} catch (IllegalArgumentException e) {
				// ignore unsupported or invalid encodings
			}
		}
		return null;
	}

	/*
	 * Return the appropriate System console using the pre-validated encoding.
	 */
	private static PrintStream createConsole(FileDescriptor desc, String encoding) {
		BufferedOutputStream bufStream = new BufferedOutputStream(new FileOutputStream(desc));
		if (encoding == null) {
			return new PrintStream(bufStream, true);
		} else {
			try {
				return new PrintStream(bufStream, true, encoding);
			} catch (UnsupportedEncodingException e) {
				// not possible when the Charset name is validated first
				throw new InternalError("For encoding " + encoding, e); //$NON-NLS-1$
			}
		}
	}

	static void afterClinitInitialization() {
		/* Multitenancy change: only initialize VMLangAccess once as it's non-isolated */
		if (null == com.ibm.oti.vm.VM.getVMLangAccess()) {
			com.ibm.oti.vm.VM.setVMLangAccess(new VMAccess());
		}
		SharedSecrets.setJavaLangAccess(new Access());

		// Fill in the properties from the VM information.
		ensureProperties(true);

		try {
			java.lang.reflect.Field f1 = J9VMInternals.class.getDeclaredField("jitHelpers"); //$NON-NLS-1$
			java.lang.reflect.Field f2 = String.class.getDeclaredField("helpers"); //$NON-NLS-1$

			Unsafe unsafe = Unsafe.getUnsafe();

			unsafe.putObject(unsafe.staticFieldBase(f1), unsafe.staticFieldOffset(f1), com.ibm.jit.JITHelpers.getHelpers());
			unsafe.putObject(unsafe.staticFieldBase(f2), unsafe.staticFieldOffset(f2), com.ibm.jit.JITHelpers.getHelpers());
		} catch (NoSuchFieldException e) { }

		/**
		 * When the System Property == true, then disable sharing (i.e. arraycopy the underlying value array) in
		 * String.substring(int) and String.substring(int, int) methods whenever offset is zero. Otherwise, enable
		 * sharing of the underlying value array.
		 */
		String enableSharingInSubstringWhenOffsetIsZeroProperty = internalGetProperties().getProperty("java.lang.string.substring.nocopy"); //$NON-NLS-1$
		String.enableSharingInSubstringWhenOffsetIsZero = enableSharingInSubstringWhenOffsetIsZeroProperty == null || enableSharingInSubstringWhenOffsetIsZeroProperty.equalsIgnoreCase("false"); //$NON-NLS-1$

		// Check the default encoding
		StringCoding.encode(new char[1], 0, 1);

		// Set up standard in, out, and err.
		Properties props = internalGetProperties();
		Charset consoleCharset = Charset.defaultCharset();
		String stdoutCharset = getCharsetName(props.getProperty("sun.stdout.encoding"), consoleCharset); //$NON-NLS-1$
		String stderrCharset = getCharsetName(props.getProperty("sun.stderr.encoding"), consoleCharset); //$NON-NLS-1$

		setErr(createConsole(FileDescriptor.err, stderrCharset));
		setOut(createConsole(FileDescriptor.out, stdoutCharset));

	}

native static void startSNMPAgent();

static void completeInitialization() {

	InputStream tempIn = new BufferedInputStream(new FileInputStream(FileDescriptor.in));
	setIn(tempIn);

	Terminator.setup();

}

/**
 * Sets the value of the static slot "in" in the receiver
 * to the passed in argument.
 *
 * @param		newIn 		the new value for in.
 */
public static void setIn(InputStream newIn) {
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(com.ibm.oti.util.RuntimePermissions.permissionSetIO);
	}
	setFieldImpl("in", newIn); //$NON-NLS-1$
}

/**
 * Sets the value of the static slot "out" in the receiver
 * to the passed in argument.
 *
 * @param		newOut 		the new value for out.
 */
public static void setOut(java.io.PrintStream newOut) {
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(com.ibm.oti.util.RuntimePermissions.permissionSetIO);
	}
	setFieldImpl("out", newOut); //$NON-NLS-1$
}

/**
 * Sets the value of the static slot "err" in the receiver
 * to the passed in argument.
 *
 * @param		newErr  	the new value for err.
 */
public static void setErr(java.io.PrintStream newErr) {
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(com.ibm.oti.util.RuntimePermissions.permissionSetIO);
	}
	setFieldImpl("err", newErr); //$NON-NLS-1$
}

/**
 * Prevents this class from being instantiated.
 */
private System() {
}

/**
 * Copies the contents of <code>array1</code> starting at offset <code>start1</code>
 * into <code>array2</code> starting at offset <code>start2</code> for
 * <code>length</code> elements.
 *
 * @param		array1 		the array to copy out of
 * @param		start1 		the starting index in array1
 * @param		array2 		the array to copy into
 * @param		start2 		the starting index in array2
 * @param		length 		the number of elements in the array to copy
 */
public static native void arraycopy(Object array1, int start1, Object array2, int start2, int length);

/**
 * Private version of the arraycopy method used by the jit for reference arraycopies
 */
private static void arraycopy(Object[] A1, int offset1, Object[] A2, int offset2, int length) {
	if (A1 == null || A2 == null) throw new NullPointerException();
	if (offset1 >= 0 && offset2 >= 0 && length >= 0 &&
		length <= A1.length - offset1 && length <= A2.length - offset2)
	{
		// Check if this is a forward or backwards arraycopy
		if (A1 != A2 || offset1 > offset2 || offset1+length <= offset2) {
			for (int i = 0; i < length; ++i) {
				A2[offset2+i] = A1[offset1+i];
			}
		} else {
			for (int i = length-1; i >= 0; --i) {
				A2[offset2+i] = A1[offset1+i];
			}
		}
	} else throw new ArrayIndexOutOfBoundsException();
}

/**
 * Answers the current time expressed as milliseconds since
 * the time 00:00:00 UTC on January 1, 1970.
 *
 * @return		the time in milliseconds.
 */
public static native long currentTimeMillis();

private static native Properties initProperties(Properties props);

/**
 * If systemProperties is unset, then create a new one based on the values
 * provided by the virtual machine.
 */
@SuppressWarnings("nls")
private static void ensureProperties(boolean isInitialization) {
	Properties jclProps = new Properties();
	initProperties(jclProps);

	Properties initializedProperties = new Properties();

	if (osEncoding != null) {
		initializedProperties.put("os.encoding", osEncoding); //$NON-NLS-1$
	}
	initializedProperties.put("ibm.system.encoding", platformEncoding); //$NON-NLS-1$
	initializedProperties.put("java.specification.name", "Java Platform API Specification"); //$NON-NLS-1$ //$NON-NLS-2$
	initializedProperties.put("com.ibm.oti.configuration", "scar"); //$NON-NLS-1$

	String[] list = getPropertyList();
	for (int i = 0; i < list.length; i += 2) {
		String key = list[i];
		if (key == null) {
			break;
		}
		initializedProperties.put(key, list[i+1]);
	}
	for (Map.Entry<?, ?> entry : jclProps.entrySet()) {
		initializedProperties.putIfAbsent(entry.getKey(), entry.getValue());
	}

	/* java.lang.VersionProps.init() eventually calls into System.setProperty() where propertiesInitialized needs to be true */
	propertiesInitialized = true;

	/* VersionProps.init requires systemProperties to be set */
	systemProperties = initializedProperties;

	sun.misc.Version.init();

	StringBuffer.initFromSystemProperties(systemProperties);
	StringBuilder.initFromSystemProperties(systemProperties);

	String javaRuntimeVersion = initializedProperties.getProperty("java.runtime.version"); //$NON-NLS-1$
	if (null != javaRuntimeVersion) {
		String fullVersion = initializedProperties.getProperty("java.fullversion"); //$NON-NLS-1$
		if (null != fullVersion) {
			initializedProperties.put("java.fullversion", (javaRuntimeVersion + "\n" + fullVersion)); //$NON-NLS-1$ //$NON-NLS-2$
		}
		rasInitializeVersion(javaRuntimeVersion);
	}

	lineSeparator = initializedProperties.getProperty("line.separator", "\n"); //$NON-NLS-1$

	if (isInitialization) {
		VM.saveAndRemoveProperties(initializedProperties);
	}

	/* create systemProperties from properties Map */
	systemProperties = initializedProperties;

	/* Preload system property jdk.serialFilter to prevent later modification */
	jdk.internal.util.StaticProperty.jdkSerialFilter();
}

private static native void rasInitializeVersion(String javaRuntimeVersion);

/**
 * Causes the virtual machine to stop running, and the
 * program to exit.
 *
 * @param		code		the return code.
 *
 * @throws		SecurityException 	if the running thread is not allowed to cause the vm to exit.
 *
 * @see			SecurityManager#checkExit
 */
public static void exit(int code) {
	RUNTIME.exit(code);
}

/**
 * Indicate to the virtual machine that it would be a
 * good time to collect available memory. Note that, this
 * is a hint only.
 */
public static void gc() {
	RUNTIME.gc();
}

/**
 * Returns an environment variable.
 *
 * @param 		var			the name of the environment variable
 * @return		the value of the specified environment variable
 */
@SuppressWarnings("dep-ann")
public static String getenv(String var) {
	if (var == null) throw new NullPointerException();
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(new RuntimePermission("getenv." + var)); //$NON-NLS-1$
	}
	return ProcessEnvironment.getenv(var);
}

/**
 * Answers the system properties. Note that this is
 * not a copy, so that changes made to the returned
 * Properties object will be reflected in subsequent
 * calls to {@code getProperty()} and {@code getProperties()}.
 * <p>
 * Security managers should restrict access to this
 * API if possible.
 *
 * @return		the system properties
 */
public static Properties getProperties() {
	if (!propertiesInitialized) throw new Error("bootstrap error, system property access before init"); //$NON-NLS-1$
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPropertiesAccess();
	}
	return systemProperties;
}

/**
 * Answers the system properties without any security
 * checks. This is used for access from within java.lang.
 *
 * @return		the system properties
 */
static Properties internalGetProperties() {
	if (!propertiesInitialized) throw new Error("bootstrap error, system property access before init");	 //$NON-NLS-1$

	return systemProperties;
}
/**
 * Answers the value of a particular system property.
 * Answers null if no such property exists.
 * <p>
 * The properties currently provided by the virtual
 * machine are:
 * <pre>
 *     file.separator
 *     java.class.path
 *     java.class.version
 *     java.home
 *     java.vendor
 *     java.vendor.url
 *     java.version
 *     line.separator
 *     os.arch
 *     os.name
 *     os.version
 *     path.separator
 *     user.dir
 *     user.home
 *     user.name
 *     user.timezone
 * </pre>
 *
 * @param		prop		the system property to look up
 * @return		the value of the specified system property, or null if the property doesn't exist
 */
@SuppressWarnings("nls")
public static String getProperty(String prop) {
	return getProperty(prop, null);
}

/**
 * Answers the value of a particular system property.
 * If no such property is found, answers the defaultValue.
 *
 * @param		prop			the system property to look up
 * @param		defaultValue	return value if system property is not found
 * @return		the value of the specified system property, or defaultValue if the property doesn't exist
 */
public static String getProperty(String prop, String defaultValue) {
	if (prop.length() == 0) throw new IllegalArgumentException();

	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPropertyAccess(prop);
	}

	if (!propertiesInitialized
			&& !prop.equals("com.ibm.IgnoreMalformedInput") //$NON-NLS-1$
			&& !prop.equals("sun.nio.cs.map") //$NON-NLS-1$
	) {
		if (prop.equals("os.encoding")) { //$NON-NLS-1$
			return osEncoding;
		} else if (prop.equals("ibm.system.encoding")) { //$NON-NLS-1$
			return platformEncoding;
		} else if (prop.equals("file.encoding")) { //$NON-NLS-1$
			return fileEncoding;
		}
		throw new Error("bootstrap error, system property access before init: " + prop); //$NON-NLS-1$
	}

	return systemProperties.getProperty(prop, defaultValue);
}

/**
 * Sets the value of a particular system property.
 *
 * @param		prop		the system property to change
 * @param		value		the value to associate with prop
 * @return		the old value of the property, or null
 */
public static String setProperty(String prop, String value) {
	if (!propertiesInitialized) throw new Error("bootstrap error, system property access before init: " + prop); //$NON-NLS-1$

	if (prop.length() == 0) throw new IllegalArgumentException();

	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(new PropertyPermission(prop, "write")); //$NON-NLS-1$
	}

	return (String)systemProperties.setProperty(prop, value);
}

/**
 * Answers an array of Strings containing key..value pairs
 * (in consecutive array elements) which represent the
 * starting values for the system properties as provided
 * by the virtual machine.
 *
 * @return		the default values for the system properties.
 */
private static native String [] getPropertyList();

/**
 * Before propertiesInitialized is set to true,
 * this returns the requested system property according to sysPropID:
 *   0 - os.version
 *   1 - platform encoding
 *   2 - file.encoding
 *   3 - os.encoding
 *   Reserved for future
 */
private static native String getSysPropBeforePropertiesInitialized(int sysPropID);

/**
 * Answers the active security manager.
 *
 * @return		the system security manager object.
 */
public static SecurityManager getSecurityManager() {
	return security;
}

/**
 * Answers an integer hash code for the parameter.
 * The hash code returned is the same one that would
 * be returned by java.lang.Object.hashCode(), whether
 * or not the object's class has overridden hashCode().
 * The hash code for null is 0.
 *
 * @param		anObject	the object
 * @return		the hash code for the object
 *
 * @see			java.lang.Object#hashCode
 */
public static int identityHashCode(Object anObject) {
	if (anObject == null) {
		return 0;
	}
	return J9VMInternals.fastIdentityHashCode(anObject);
}

/**
 * Loads the specified file as a dynamic library.
 *
 * @param pathName the path of the file to be loaded
 *
 * @throws UnsatisfiedLinkError if the library could not be loaded
 * @throws NullPointerException if pathName is null
 * @throws SecurityException if the library was not allowed to be loaded
 */
@CallerSensitive
public static void load(String pathName) {
	@SuppressWarnings("removal")
	SecurityManager smngr = System.getSecurityManager();
	if (smngr != null) {
		smngr.checkLink(pathName);
	}
	ClassLoader.loadLibraryWithPath(pathName, ClassLoader.callerClassLoader(), null);
}

/**
 * Loads and links the library specified by the argument.
 *
 * @param libName the name of the library to load
 *
 * @throws UnsatisfiedLinkError if the library could not be loaded
 * @throws NullPointerException if libName is null
 * @throws SecurityException if the library was not allowed to be loaded
 */
@CallerSensitive
public static void loadLibrary(String libName) {

	if (libName.indexOf(File.pathSeparator) >= 0) {
		// K0B01 = Library name must not contain a file path: {0}
		throw new UnsatisfiedLinkError(Msg.getString("K0B01", libName)); //$NON-NLS-1$
	}
	if (internalGetProperties().getProperty("os.name").startsWith("Windows")) { //$NON-NLS-1$ //$NON-NLS-2$
		if ((libName.indexOf('/') >= 0) || ((libName.length() > 1) && (libName.charAt(1) == ':'))) {
			// K0B01 = Library name must not contain a file path: {0}
			throw new UnsatisfiedLinkError(Msg.getString("K0B01", libName)); //$NON-NLS-1$
		}
	}
	@SuppressWarnings("removal")
	SecurityManager smngr = System.getSecurityManager();
	if (smngr != null) {
		smngr.checkLink(libName);
	}
	ClassLoader callerClassLoader = ClassLoader.callerClassLoader();
	try {
		ClassLoader.loadLibraryWithClassLoader(libName, callerClassLoader);
	} catch (UnsatisfiedLinkError ule) {
		String errorMessage = ule.getMessage();
		if ((errorMessage != null) && errorMessage.contains("already loaded in another classloader")) { //$NON-NLS-1$
			// attempt to unload the classloader, and retry
			gc();
			ClassLoader.loadLibraryWithClassLoader(libName, callerClassLoader);
		} else {
			throw ule;
		}
	}
}

/**
 * Provides a hint to the virtual machine that it would
 * be useful to attempt to perform any outstanding
 * object finalizations.
 */
public static void runFinalization() {
	RUNTIME.runFinalization();
}

/**
 * Throws {@code UnsupportedOperationException}.
 *
 * @deprecated 	This method is unsafe.
 */
@Deprecated
public static void runFinalizersOnExit(boolean flag) {
	Runtime.runFinalizersOnExit(flag);
}

/**
 * Sets the system properties. Note that the object which is passed in
 * is not copied, so that subsequent changes made to it will be reflected
 * in calls to {@code getProperty()} and {@code getProperties()}.
 * <p>
 * Security managers should restrict access to this
 * API if possible.
 *
 * @param		p			the properties to set
 */
public static void setProperties(Properties p) {
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPropertiesAccess();
	}
	if (p == null) {
		ensureProperties(false);
	} else {
		systemProperties = p;
	}
}

static void checkTmpDir() {
}

/**
 * Sets the active security manager. Note that once
 * the security manager has been set, it can not be
 * changed. Attempts to do so will cause a security
 * exception.
 *
 * @param		s			the new security manager
 *
 * @throws		SecurityException 	if the security manager has already been set and its checkPermission method doesn't allow it to be replaced.
 */
public static void setSecurityManager(final SecurityManager s) {
	@SuppressWarnings("removal")
	final SecurityManager currentSecurity = security;

	if (s != null) {
		if (currentSecurity == null) {
			// only preload classes when current security manager is null
			// not adding an extra static field to preload only once
			try {
				// Preload classes used for checkPackageAccess(),
				// otherwise we could go recursive
				s.checkPackageAccess("java.lang"); //$NON-NLS-1$
			} catch (Exception e) {
				// ignore any potential exceptions
			}
		}

		try {
			AccessController.doPrivileged(new PrivilegedAction<Void>() {
				@Override
				public Void run() {
					if (currentSecurity == null) {
						// initialize external messages and
						// also load security sensitive classes
						Msg.getString("K002c"); //$NON-NLS-1$
					}
					ProtectionDomain pd = s.getClass().getPDImpl();
					if (pd != null) {
						// initialize the protection domain, which may include preloading the
						// dynamic permissions from the policy before installing
						pd.implies(sun.security.util.SecurityConstants.ALL_PERMISSION);
					}
					return null;
				}});
		} catch (Exception e) {
			// ignore any potential exceptions
		}
	}
	if (currentSecurity != null) {
		currentSecurity.checkPermission(com.ibm.oti.util.RuntimePermissions.permissionSetSecurityManager);
	}
	security = s;
}

/**
 * Answers the platform-specific filename for the shared
 * library named by the argument.
 *
 * @param		userLibName 	the name of the library to look up.
 * @return		the platform-specific filename for the library
 */
public static native String mapLibraryName(String userLibName);

/**
 * Sets the value of the named static field in the receiver
 * to the passed in argument.
 *
 * @param		fieldName 	the name of the field to set, one of in, out, or err
 * @param		stream 		the new value of the field
 */
private static native void setFieldImpl(String fieldName, Object stream);

@CallerSensitive
static Class getCallerClass() {
	return Class.getStackClass(2);
}

/**
 * Return the channel inherited by the invocation of the running vm. The channel is
 * obtained by calling SelectorProvider.inheritedChannel().
 *
 * @return the inherited channel or null
 *
 * @throws IOException if an IO error occurs getting the inherited channel
 */
public static java.nio.channels.Channel inheritedChannel() throws IOException {
	return java.nio.channels.spi.SelectorProvider.provider().inheritedChannel();
}

/**
 * Returns the current tick count in nanoseconds. The tick count
 * only reflects elapsed time.
 *
 * @return		the current nanosecond tick count, which may be negative
 */
public static native long nanoTime();

/**
 * Removes the property.
 *
 * @param 		prop		the name of the property to remove
 * @return		the value of the property removed
 */
public static String clearProperty(String prop) {
	if (!propertiesInitialized) throw new Error("bootstrap error, system property access before init: " + prop); //$NON-NLS-1$

	if (prop.length() == 0) throw new IllegalArgumentException();
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(new PropertyPermission(prop, "write")); //$NON-NLS-1$
	}
	return (String)systemProperties.remove(prop);
}

/**
 * Returns all of the system environment variables in an unmodifiable Map.
 *
 * @return	an unmodifiable Map containing all of the system environment variables.
 */
public static Map<String, String> getenv() {
	@SuppressWarnings("removal")
	SecurityManager security = System.getSecurityManager();
	if (security != null) {
		security.checkPermission(new RuntimePermission("getenv.*")); //$NON-NLS-1$
	}
	return ProcessEnvironment.getenv();
}

/**
 * Return the Console or null.
 *
 * @return the Console or null
 */
public static Console console() {
	if (consoleInitialized) return console;
	synchronized(System.class) {
		if (consoleInitialized) return console;
		console = SharedSecrets.getJavaIOAccess().console();
		consoleInitialized = true;
	}
	return console;
}

/**
 * JIT Helper method
 */
private static void longMultiLeafArrayCopy(Object src, int srcPos,
		Object dest, int destPos, int length, int elementSize, int leafSize) {

	// Check if this is a forward or backwards arraycopy
	boolean isFwd;
	if (src != dest || srcPos > destPos || srcPos+length <= destPos)
		isFwd = true;
	else
		isFwd = false;

	int newSrcPos;
	int newDestPos;
	int numOfElemsPerLeaf = leafSize / elementSize;
	int srcLeafPos;
	int destLeafPos;
	int L1, L2, L3;
	int offset;

	if (isFwd)
	{
		newSrcPos = srcPos;
		newDestPos = destPos;
	}
	else
	{
		newSrcPos = srcPos + length - 1;
		newDestPos = destPos + length - 1;
	}

	srcLeafPos = newSrcPos % numOfElemsPerLeaf;
	destLeafPos = newDestPos % numOfElemsPerLeaf;
	if (srcLeafPos < destLeafPos)
	{
		if (isFwd)
		{
			// align dst to leaf boundary first
			L1 = numOfElemsPerLeaf - destLeafPos;
			L2 = numOfElemsPerLeaf - (srcLeafPos + L1);
		}
		else
		{
			L1 = srcLeafPos + 1;
			L2 = destLeafPos - srcLeafPos;
		}
	}
	else
	{
		if (isFwd)
		{
			// align src to leaf boundary first
			L1 = numOfElemsPerLeaf - srcLeafPos;
			L2 = numOfElemsPerLeaf - (destLeafPos + L1);
		}
		else
		{
			L1 = destLeafPos + 1;
			L2 = srcLeafPos - destLeafPos;
		}
	}

	L3 = numOfElemsPerLeaf - L2;

	// begin copying
	offset = isFwd ? 0 : L1 - 1;
	System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, L1);
	newSrcPos = isFwd ? newSrcPos + L1 : newSrcPos - L1;
	newDestPos = isFwd ? newDestPos + L1 : newDestPos - L1;
	length -= L1;

	// now one of newSrcPos and newDestPos is aligned on an arraylet
	// leaf boundary, so copies of L2 and L3 can be repeated until there
	// is less than a full leaf left to copy
	while (length >= numOfElemsPerLeaf) {
		offset = isFwd ? 0 : L2 - 1;
		System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, L2);
		newSrcPos = isFwd ? newSrcPos + L2 : newSrcPos - L2;
		newDestPos = isFwd ? newDestPos + L2 : newDestPos - L2;

		offset = isFwd ? 0 : L3 - 1;
		System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, L3);
		newSrcPos = isFwd ? newSrcPos + L3 : newSrcPos - L3;
		newDestPos = isFwd ? newDestPos + L3 : newDestPos - L3;

		length -= numOfElemsPerLeaf;
	}

	// next L2 elements of each array must be on same leaf
	if (length > L2) {
		offset = isFwd ? 0 : L2 - 1;
		System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, L2);
		newSrcPos = isFwd ? newSrcPos + L2 : newSrcPos - L2;
		newDestPos = isFwd ? newDestPos + L2 : newDestPos - L2;
		length -= L2;
	}

	// whatever is left of each array must be on the same leaf
	if (length > 0) {
		offset = isFwd ? 0 : length - 1;
		System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, length);
	}
}

/**
 * JIT Helper method
 */
private static void simpleMultiLeafArrayCopy(Object src, int srcPos,
		Object dest, int destPos, int length, int elementSize, int leafSize)
{
	int count = 0;

	// Check if this is a forward or backwards arraycopy
	boolean isFwd;
	if (src != dest || srcPos > destPos || srcPos+length <= destPos)
		isFwd = true;
	else
		isFwd = false;

	int newSrcPos;
	int newDestPos;
	int numOfElemsPerLeaf = leafSize / elementSize;
	int srcLeafPos;
	int destLeafPos;
	int iterLength;

	if (isFwd)
	{
		 newSrcPos = srcPos;
		 newDestPos = destPos;
	}
	else
	{
		 newSrcPos = srcPos + length - 1;
		 newDestPos = destPos + length - 1;
	}

	for (count = 0; count < length; count += iterLength)
	{
		srcLeafPos = (newSrcPos % numOfElemsPerLeaf);
		 destLeafPos = newDestPos % numOfElemsPerLeaf;
		 int offset;
		if ((isFwd && (srcLeafPos >= destLeafPos)) ||
		(!isFwd && (srcLeafPos < destLeafPos)))
		{
			if (isFwd)
				iterLength = numOfElemsPerLeaf - srcLeafPos;
			 else
				iterLength = srcLeafPos + 1;
		 }
		 else
		 {
			 if (isFwd)
				iterLength = numOfElemsPerLeaf - destLeafPos;
			 else
				iterLength = destLeafPos + 1;
		 }

		 if (length - count < iterLength)
			 iterLength = length - count;

		 if (isFwd)
			offset = 0;
		 else
			offset = iterLength - 1;

		 System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, iterLength);

		 if (isFwd)
		 {
			 newSrcPos += iterLength;
			 newDestPos += iterLength;
		 }
		 else
		 {
			 newSrcPos -= iterLength;
			 newDestPos -= iterLength;
		 }
	}
}

/**
 * JIT Helper method
 */
private static void multiLeafArrayCopy(Object src, int srcPos, Object dest,
		int destPos, int length, int elementSize, int leafSize) {
	int count = 0;

	// Check if this is a forward or backwards arraycopy
	boolean isFwd;
	if (src != dest || srcPos > destPos || srcPos+length <= destPos)
		isFwd = true;
	else
		isFwd = false;

	int newSrcPos;
	int newDestPos;
	int numOfElemsPerLeaf = leafSize / elementSize;
	int srcLeafPos;
	int destLeafPos;

	if (isFwd)
	{
		newSrcPos = srcPos;
		newDestPos = destPos;
	}
	else
	{
		 newSrcPos = srcPos + length - 1;
		 newDestPos = destPos + length - 1;
	}

	int iterLength1 = 0;
	int iterLength2 = 0;
	while (count < length)
	{
		srcLeafPos = (newSrcPos % numOfElemsPerLeaf);
		destLeafPos = (newDestPos % numOfElemsPerLeaf);

		int firstPos, secondPos;

		if ((isFwd && (srcLeafPos >= destLeafPos)) ||
				(!isFwd && (srcLeafPos < destLeafPos)))
		{
			firstPos = srcLeafPos;
			secondPos = newDestPos;
		}
		else
		{
			firstPos = destLeafPos;
			secondPos = newSrcPos;
		}

		int offset = 0;
		if (isFwd)
			iterLength1 = numOfElemsPerLeaf - firstPos;
		else
			iterLength1 = firstPos + 1;

		if (length - count < iterLength1)
			iterLength1 = length - count;

		if (isFwd)
			iterLength2 = numOfElemsPerLeaf - ((secondPos + iterLength1) % numOfElemsPerLeaf);
		else
		{
			iterLength2 = ((secondPos - iterLength1) % numOfElemsPerLeaf) + 1;
			offset = iterLength1 - 1;
		}

		if (length - count - iterLength1 < iterLength2)
			iterLength2 = length - count - iterLength1;

		System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, iterLength1);

		offset = 0;
		if (isFwd)
		{
			newSrcPos += iterLength1;
			newDestPos += iterLength1;
		}
		else
		{
			newSrcPos -= iterLength1;
			newDestPos -= iterLength1;
			offset = iterLength2 - 1;
		}

		if (iterLength2 <= 0) break;

		System.arraycopy(src, newSrcPos - offset, dest, newDestPos - offset, iterLength2);

		if (isFwd)
		{
			newSrcPos += iterLength2;
			newDestPos += iterLength2;
		}
		else
		{
			newSrcPos -= iterLength2;
			newDestPos -= iterLength2;
		}

		count += iterLength1 + iterLength2;
	}
}

/**
 * Return platform specific line separator character(s).
 * Unix is \n while Windows is \r\n as per the prop set by the VM.
 *
 * @return platform specific line separator string
 */
//  Refer to Jazz 30875
public static String lineSeparator() {
	 return lineSeparator;
}

}
