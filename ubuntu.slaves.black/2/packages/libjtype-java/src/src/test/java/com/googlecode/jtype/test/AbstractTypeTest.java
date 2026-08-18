/*
 * Copyright 2011 IIZUKA Software Technologies Ltd
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.googlecode.jtype.test;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.googlecode.jtype.Types;

import org.junit.Before;

/**
 * Provides support for testing with types.
 * 
 * @author Mark Hobson
 * @version $Id: AbstractTypeTest.java 115 2011-11-25 18:17:40Z markhobson@gmail.com $
 */
public abstract class AbstractTypeTest
{
	// fields -----------------------------------------------------------------
	
	private Set<String> imports;
	
	// public methods ---------------------------------------------------------
	
	@Before
	public final void setUpAbstractTypeTest()
	{
		imports = Collections.unmodifiableSet(new HashSet<String>(createImports()));
	}
	
	// protected methods ------------------------------------------------------
	
	protected void addImports(Set<Class<?>> imports)
	{
		// no-op
	}
	
	protected final Type type(String typeName)
	{
		return Types.valueOf(typeName, imports);
	}
	
	// private methods --------------------------------------------------------
	
	private Set<String> createImports()
	{
		Set<Class<?>> classImports = new HashSet<Class<?>>();
		addImports(classImports);
		return toClassNames(classImports);
	}
	
	private static Set<String> toClassNames(Collection<Class<?>> classes)
	{
		Set<String> names = new HashSet<String>();
		
		for (Class<?> klass : classes)
		{
			names.add(klass.getName());
		}
		
		return names;
	}
}
