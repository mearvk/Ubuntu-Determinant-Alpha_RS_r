/*
 * Copyright IBM Corp. and others 2011
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
package java.lang.invoke;

import sun.misc.Cleaner;

import static java.lang.invoke.MethodHandleResolver.UNSAFE;

/**
 * A MutableCallSite acts as though its target MethodHandle were a normal variable.
 * <p>
 * Because it is an ordinary variable, other threads may not immediately observe the value of a
 * {@link #setTarget(MethodHandle)} unless external synchronization is used.  If the result of
 * a {@link #setTarget(MethodHandle)} call must be observed by other threads, the {@link #syncAll(MutableCallSite[])}
 * method may be used to force it to be synchronized.
 * <p>
 * The {@link #syncAll(MutableCallSite[])} call is likely to be expensive and should be used sparingly.  Calls to
 * {@link #syncAll(MutableCallSite[])} should be batched whenever possible.
 *
 * @since 1.7
 */
public class MutableCallSite extends CallSite {
	private static native void registerNatives();
	static {
		registerNatives();
	}
	private MutableCallSiteDynamicInvokerHandle cachedDynamicInvoker;

	final private GlobalRefCleaner globalRefCleaner;

	/* Field bypassBase is dependent on field targetFieldOffset */
	private static final long targetFieldOffset = initializeTargetFieldOffset();
	private static long initializeTargetFieldOffset(){
		try{
			return UNSAFE.objectFieldOffset(MutableCallSite.class.getDeclaredField("target")); //$NON-NLS-1$
		} catch (Exception e) {
			InternalError ie = new InternalError();
			ie.initCause(e);
			throw ie;
		}
	}

	private volatile MethodHandle target;
	private volatile MethodHandle epoch;  // A previous target that was equivalent to target, in the sense of StructuralComparator.handlesAreEquivalent

	/**
	 * Create a MutableCallSite permanently set to the same type as the <i>mutableTarget</i> and using
	 * the <i>mutableTarget</i> as the initial target value.
	 *
	 * @param mutableTarget - the initial target of the CallSite
	 * @throws NullPointerException - if the <i>mutableTarget</i> is null.
	 */
	public MutableCallSite(MethodHandle mutableTarget) throws NullPointerException {
		// .type provides the NPE if volatileTarget null
		super(mutableTarget.type());
		target = epoch = mutableTarget;
		freeze();
		globalRefCleaner = new GlobalRefCleaner();
		Cleaner.create(this, globalRefCleaner);
	}

	/**
	 * Create a MutableCallSite with the MethodType <i>type</i> and an
	 * initial target that throws IllegalStateException.
	 *
	 * @param type - the permanent type of this CallSite.
	 * @throws NullPointerException - if the type is null.
	 */
	public MutableCallSite(MethodType type) throws NullPointerException {
		super(type);
		// install a target that throws IllegalStateException
		target = CallSite.initialTarget(type);
		epoch = null; // Seems unlikely we really want the jit to commit itself to optimizing a throw
		freeze();
		globalRefCleaner = new GlobalRefCleaner();
		Cleaner.create(this, globalRefCleaner);
	}

	@Override
	public final MethodHandle dynamicInvoker() {
		if (null == cachedDynamicInvoker) {
			cachedDynamicInvoker = new MutableCallSiteDynamicInvokerHandle(this);
		}
		return cachedDynamicInvoker;
	}

	@Override
	public final MethodHandle getTarget() {
		return target;
	}

	// Allow jitted code to bypass the CallSite table in order to load the target.
	private static final Object bypassBase = initializeBypassBase();
	private static Object initializeBypassBase() {
		try{
			return UNSAFE.staticFieldBase(MutableCallSite.class.getDeclaredField("targetFieldOffset")); //$NON-NLS-1$
		} catch (Exception e) {
			InternalError ie = new InternalError();
			ie.initCause(e);
			throw ie;
		}
	}

	@Override
	public void setTarget(MethodHandle newTarget) {
		// newTarget.type provides NPE if null
		if (type() != newTarget.type) {
			throw WrongMethodTypeException.newWrongMethodTypeException(type(), newTarget.type);
		}

		// no op if target and newTarget are the same
		MethodHandle oldTarget = target;
		if (oldTarget != newTarget) {
			if (--equivalenceCounter <= 0) {
				if (StructuralComparator.get().handlesAreEquivalent(oldTarget, newTarget)) {
					// Equivalence check saved us a thaw, so it's worth doing them every time.
					equivalenceInterval = 1;
					UNSAFE.compareAndSwapObject(this, targetFieldOffset, oldTarget, newTarget);
				} else {
					thaw(oldTarget, newTarget);
					// Equivalence check was useless; wait longer before doing another one.
					equivalenceInterval = Math.min(1 + equivalenceInterval + (equivalenceInterval >> 2), 1000);
				}
				equivalenceCounter = equivalenceInterval;
			} else {
				// Equivalence check has failed recently; don't bother doing one this time.
				thaw(oldTarget, newTarget);
			}
			if (globalRefCleaner.bypassOffset != 0) {
				UNSAFE.putObject(bypassBase, globalRefCleaner.bypassOffset, newTarget);
			}
		}
	}

	// Not thread safe - allow racing updates
	private int equivalenceInterval = 0;
	private int equivalenceCounter = 0;

	// Invalidate any assumptions based on the MCS.target in compiled code
	private synchronized void thaw(MethodHandle oldTarget, MethodHandle newTarget) {
		epoch  = null;
		invalidate(new long[]{this.invalidationCookie});
		target = newTarget;
		epoch  = newTarget;
	}

	// Currently no-op.  May be implemented in the future.
	private void freeze() {
	}

	private static native void invalidate(long[] cookies);
	private long invalidationCookie;

	/**
	 * Forces the current target MethodHandle of each of the MutableCallSites in the <i>sites</i> array to be seen by all threads.
	 * Loads of the target from any of the CallSites that has already begun will continue to use the old value.
	 * <p>
	 * If any of the elements in the <i>sites</i> array is null, a NullPointerException will be raised.  It is undefined whether any
	 * of the sites may have been synchronized.
	 * <p>
	 * Note: it is valid for an implementation to use a volatile variable for the target value of MutableCallSite.  In that case,
	 * the {@link #syncAll(MutableCallSite[])} call becomes a no-op.
	 *
	 * @param sites - the array of MutableCallSites to force to be synchronized.
	 * @throws NullPointerException - if sites or any of its elements are null.
	 */
	public static void syncAll(MutableCallSite[] sites) throws NullPointerException {
		for (int i = 0; i < sites.length; i++) {
			sites[i].freeze(); // Throws NPE if null
		}
	}

	/*
	 * Native that releases the globalRef allocated during JIT compilation.
	 */
	static native void freeGlobalRef(long offset);

}

/*
 * A Runnable used by the sun.misc.Cleaner that will free the JNI
 * GlobalRef allocated during compilation if required.
 */
final class GlobalRefCleaner implements Runnable {
	// Will be updated during JIT compilation.  'bypassOffset' is treated
	// as though it were returned from Unsafe.staticFieldOffset(bypassBase, ...).
	long bypassOffset = 0;

	public void run() {
		if (bypassOffset != 0) {
			MutableCallSite.freeGlobalRef(bypassOffset);
		}
	}
}
