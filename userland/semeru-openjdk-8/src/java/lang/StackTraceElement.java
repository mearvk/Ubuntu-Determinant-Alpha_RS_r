/*
 * Copyright IBM Corp. and others 2002
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

import com.ibm.oti.util.Util;

/**
 * StackTraceElement represents a stack frame.
 *
 * @see Throwable#getStackTrace()
 */
public final class StackTraceElement implements java.io.Serializable {
	private static final long serialVersionUID = 6992337162326171013L;
	/** @serial */
	private final String declaringClass;
	/** @serial */
	private final String methodName;
	/** @serial */
	private final String fileName;
	/** @serial */
	private final int lineNumber;
	transient Object source;

/**
 * Create a StackTraceElement from the parameters.
 *
 * @param cls The class name
 * @param method The method name
 * @param file The file name
 * @param line The line number
 */
public StackTraceElement(String cls, String method, String file, int line) {
	if (cls == null || method == null) throw new NullPointerException();
	declaringClass = cls;
	methodName = method;
	fileName = file;
	lineNumber = line;
}

@SuppressWarnings("unused")
private StackTraceElement() {
	declaringClass = null;
	methodName = null;
	fileName = null;
	lineNumber = 0;
} // prevent instantiation from java code - only the VM creates these

/**
 * Returns true if the specified object is another StackTraceElement instance
 * representing the same execution point as this instance.
 *
 * @param obj the object to compare to
 *
 */
@Override
public boolean equals(Object obj) {
	if (!(obj instanceof StackTraceElement)) return false;
	StackTraceElement castObj = (StackTraceElement) obj;

	// Unknown methods are never equal to anything (not strictly to spec, but spec does not allow null method/class names)
	if ((methodName == null) || (castObj.methodName == null)) return false;

	if (!getMethodName().equals(castObj.getMethodName())) return false;
	if (!getClassName().equals(castObj.getClassName())) return false;
	String localFileName = getFileName();
	if (localFileName == null) {
		if (castObj.getFileName() != null) return false;
	} else {
		if (!localFileName.equals(castObj.getFileName())) return false;
	}
	if (getLineNumber() != castObj.getLineNumber()) return false;

	return true;
}

/**
 * Returns the full name (i.e. including package) of the class where this
 * stack trace element is executing.
 *
 * @return the name of the class where this stack trace element is
 *         executing.
 */
public String getClassName() {
	return (declaringClass == null) ? "<unknown class>" : declaringClass; //$NON-NLS-1$
}

/**
 * If available, returns the name of the file containing the Java code
 * source which was compiled into the class where this stack trace element
 * is executing.
 *
 * @return the name of the Java code source file which was compiled into the
 *         class where this stack trace element is executing. If not
 *         available, a <code>null</code> value is returned.
 */
public String getFileName() {
	return fileName;
}

/**
 * Returns the source file line number for the class where this stack trace
 * element is executing.
 *
 * @return the line number in the source file corresponding to where this
 *         stack trace element is executing.
 */
public int getLineNumber() {
	return lineNumber;
}

/**
 * Returns the name of the method where this stack trace element is
 * executing.
 *
 * @return the method in which this stack trace element is executing.
 *         Returns &lt;<code>unknown method</code>&gt; if the name of the
 *         method cannot be determined.
 */
public String getMethodName() {
	return (methodName == null) ? "<unknown method>" : methodName; //$NON-NLS-1$
}

/**
 * Returns a hash code value for this stack trace element.
 */
@Override
public int hashCode() {
	// either both methodName and declaringClass are null, or neither are null
	if (methodName == null) {
		return 0; // all unknown methods hash the same
	}
	int hashCode = methodName.hashCode() ^ declaringClass.hashCode(); // declaringClass never null if methodName is non-null
	return hashCode;
}

/**
 * Returns <code>true</code> if the method name returned by
 * {@link #getMethodName()} is implemented as a native method.
 *
 * @return true if the method is a native method
 */
public boolean isNativeMethod() {
	return lineNumber == -2;
}

/**
 * Returns a string representation of this stack trace element.
 */
@Override
public String toString() {
	StringBuilder buf = new StringBuilder(80);
	boolean includeExtendedInfo = false;
	Util.printStackTraceElement(this, source, buf, includeExtendedInfo);
	return buf.toString();
}

}
