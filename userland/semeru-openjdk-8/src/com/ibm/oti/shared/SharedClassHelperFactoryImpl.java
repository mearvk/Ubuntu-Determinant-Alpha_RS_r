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
package com.ibm.oti.shared;

import java.net.URL;
import java.util.WeakHashMap;

import com.ibm.oti.util.Msg;

/**
 * Implementation of SharedClassHelperFactory.
 *
 * @see SharedClassHelperFactory
 * @see SharedAbstractHelperFactory
 */
final class SharedClassHelperFactoryImpl extends SharedAbstractHelperFactory implements SharedClassHelperFactory {

	private static final WeakHashMap<ClassLoader, SharedHelper> helpers = new WeakHashMap<>();

	private static SharedClassFilter globalSharingFilter;
	private static final String GLOBAL_SHARING_FILTER = "com.ibm.oti.shared.SharedClassGlobalFilterClass"; //$NON-NLS-1$

	private static SharedClassFilter getGlobalSharingFilter() {
		if (globalSharingFilter == null) {
			try {
				String className = com.ibm.oti.vm.VM.internalGetProperties().getProperty(GLOBAL_SHARING_FILTER);
				if (null != className) {
					Class<?> filterClass = Class.forName(className);
					globalSharingFilter = SharedClassFilter.class.cast(filterClass.getDeclaredConstructor().newInstance());
				}
			} catch (Exception e) {
				return null;
			}
		}
		return globalSharingFilter;
	}

	@Override
	public SharedClassHelper findHelperForClassLoader(ClassLoader loader) {
		return (SharedClassHelper) helpers.get(loader);
	}

	@Override
	public SharedClassTokenHelper getTokenHelper(ClassLoader loader, SharedClassFilter filter)
			throws HelperAlreadyDefinedException
	{
		SharedClassTokenHelper helper = getTokenHelper(loader);
		if (helper != null) {
			helper.setSharingFilter(filter);
		}
		return helper;
	}

	@Override
	public SharedClassTokenHelper getTokenHelper(ClassLoader loader)
			throws HelperAlreadyDefinedException
	{
		if (loader == null) {
			return null;
		}

		synchronized (helpers) {
			SharedClassHelper helper = findHelperForClassLoader(loader);

			if (helper != null) {
				if (helper instanceof SharedClassTokenHelper) {
					return (SharedClassTokenHelper) helper;
				}
				// K059d = A different type of helper already exists for this classloader
				throw new HelperAlreadyDefinedException(Msg.getString("K059d")); //$NON-NLS-1$
			} else {
				boolean canFind = canFind(loader);
				boolean canStore = canStore(loader);

				if (canFind || canStore) {
					SharedClassTokenHelper result = new SharedClassTokenHelperImpl(loader, getNewID(), canFind, canStore);
					SharedClassFilter filter = getGlobalSharingFilter();
					if (filter != null) {
						result.setSharingFilter(filter);
					}
					helpers.put(loader, result);
					return result;
				}
				return null;
			}
		}
	}

	@Override
	public SharedClassURLHelper getURLHelper(ClassLoader loader, SharedClassFilter filter)
			throws HelperAlreadyDefinedException
	{
		SharedClassURLHelper helper = getURLHelper(loader);
		if (helper != null) {
			helper.setSharingFilter(filter);
		}
		return helper;
	}

	@Override
	public SharedClassURLHelper getURLHelper(ClassLoader loader)
			throws HelperAlreadyDefinedException
	{
		if (loader == null) {
			return null;
		}
		synchronized (helpers) {
			SharedClassHelper helper = findHelperForClassLoader(loader);

			if (helper != null) {
				if (helper instanceof SharedClassURLHelper) {
					return (SharedClassURLHelper)helper;
				}
				// K059d = A different type of helper already exists for this classloader
				throw new HelperAlreadyDefinedException(Msg.getString("K059d")); //$NON-NLS-1$
			} else {
				boolean canFind = canFind(loader);
				boolean canStore = canStore(loader);

				if (canFind || canStore) {
					SharedClassURLHelper result = new SharedClassURLHelperImpl(loader, getNewID(), canFind, canStore);
					SharedClassFilter filter = getGlobalSharingFilter();
					if (filter != null) {
						result.setSharingFilter(filter);
					}
					helpers.put(loader, result);
					return result;
				}
				return null;
			}
		}
	}

	@Override
	public SharedClassURLClasspathHelper getURLClasspathHelper(
			ClassLoader loader, URL[] classpath, SharedClassFilter filter) throws HelperAlreadyDefinedException {
		SharedClassURLClasspathHelper helper = getURLClasspathHelper(loader, classpath);
		if (helper != null) {
			helper.setSharingFilter(filter);
		}
		return helper;
	}

	@Override
	public SharedClassURLClasspathHelper getURLClasspathHelper(
			ClassLoader loader, URL[] classpath)  throws HelperAlreadyDefinedException {
		if (loader == null || classpath == null) {
			return null;
		}

		synchronized (helpers) {
			SharedClassHelper helper = findHelperForClassLoader(loader);
			SharedClassURLClasspathHelperImpl result;
			boolean found = true;
			if (helper != null) {
				if (helper instanceof SharedClassURLClasspathHelper) {
					result = (SharedClassURLClasspathHelperImpl) helper;
					URL[] testCP = result.getClasspath();
					for (int j = 0; j < classpath.length; j++) {
						if (!classpath[j].equals(testCP[j])) {
							found = false;
							break;
						}
					}
					if (found) {
						return result;
					} else {
						// K059e = A SharedClassURLClasspathHelper already exists for this classloader with a different classpath
						throw new HelperAlreadyDefinedException(Msg.getString("K059e")); //$NON-NLS-1$
					}
				} else {
					// K059d = A different type of helper already exists for this classloader
					throw new HelperAlreadyDefinedException(Msg.getString("K059d")); //$NON-NLS-1$
				}
			} else {
				boolean canFind = canFind(loader);
				boolean canStore = canStore(loader);

				if (canFind || canStore) {
					result = new SharedClassURLClasspathHelperImpl(loader, classpath, getNewID(), canFind, canStore);
					SharedClassFilter filter = getGlobalSharingFilter();
					if (filter != null) {
						result.setSharingFilter(filter);
					}
					helpers.put(loader, result);
					return result;
				}
				return null;
			}
		}
	}

}
