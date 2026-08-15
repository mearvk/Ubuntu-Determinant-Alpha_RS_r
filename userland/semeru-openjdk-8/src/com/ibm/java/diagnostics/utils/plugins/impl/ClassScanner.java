/*
 * Copyright IBM Corp. and others 2012
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
package com.ibm.java.diagnostics.utils.plugins.impl;

import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Set;

import com.ibm.java.diagnostics.utils.plugins.Annotation;
import com.ibm.java.diagnostics.utils.plugins.ClassInfo;
import com.ibm.java.diagnostics.utils.plugins.ClassListener;

import jdk.internal.org.objectweb.asm.AnnotationVisitor;
import jdk.internal.org.objectweb.asm.ClassReader;
import jdk.internal.org.objectweb.asm.ClassVisitor;
import jdk.internal.org.objectweb.asm.Opcodes;

public final class ClassScanner
		extends ClassVisitor
{

	public static ClassInfo getClassInfo(InputStream file, URL url, Set<ClassListener> listeners) throws IOException {
		ClassScanner scanner = new ClassScanner(url, listeners);
		ClassReader reader = new ClassReader(file);

		reader.accept(scanner, ClassReader.SKIP_CODE | ClassReader.SKIP_DEBUG | ClassReader.SKIP_FRAMES);

		return scanner.info;
	}

	private ClassInfo info;
	private Annotation currentAnnotation;
	private final URL url; // where the class is being scanned from
	private final Set<ClassListener> listeners;

	private ClassScanner(URL url, Set<ClassListener> listeners) {
		super(Opcodes.ASM5, null);
		this.url = url;
		this.listeners = listeners;
	}

	@Override
	public AnnotationVisitor visitAnnotation(String className, boolean visible) {
		final class ClassScannerAnnotation extends AnnotationVisitor {

			ClassScannerAnnotation(int api) {
				super(api);
			}

			@Override
			public void visit(String name, Object value) {
				ClassScanner.this.visitAnnotationValue(name, value);
			}
		}

		currentAnnotation = info.addAnnotation(className);
		for (ClassListener listener : listeners) {
			listener.visitAnnotation(className, visible);
		}
		return new ClassScannerAnnotation(api);
	}

	final void visitAnnotationValue(String name, Object value) {
		currentAnnotation.addEntry(name, value);
		for (ClassListener listener : listeners) {
			listener.visitAnnotationValue(name, value);
		}
	}

	@Override
	public void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
		String dotName = name.replace('/', '.');
		String dotSuperName = superName.replace('/', '.');
		info = new ClassInfo(dotName, url);
		// record all interfaces supplied by this class
		for (String iface : interfaces) {
			info.addInterface(iface);
		}
		for (ClassListener listener : listeners) {
			listener.visit(version, access, dotName, signature, dotSuperName, interfaces);
		}
	}

}
