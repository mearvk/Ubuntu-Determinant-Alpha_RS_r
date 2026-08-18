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
package com.googlecode.jtype;

import static com.googlecode.jtype.Types.parameterizedType;
import static com.googlecode.jtype.Types.typeVariable;
import static org.junit.Assert.assertEquals;

import java.lang.reflect.Type;
import java.util.Set;

import com.googlecode.jtype.test.AbstractTypeTest;

import org.junit.Test;

/**
 * Tests {@code TypeUtils.getResolvedSupertype}.
 * 
 * @author Mark Hobson
 * @version $Id: TypeUtilsGetResolvedSupertypeTest.java 115 2011-11-25 18:17:40Z markhobson@gmail.com $
 * @see TypeUtils#getResolvedSupertype(Class, Class)
 */
public class TypeUtilsGetResolvedSupertypeTest extends AbstractTypeTest
{
	// types ------------------------------------------------------------------
	
	private static class DummyClass
	{
		// simple subtype
	}
	
	private static interface IFake<T>
	{
		// simple subtype
	}
	
	private static class Fake implements IFake<DummyClass>
	{
		// simple subtype
	}
	
	private static class ParameterizedTypeFake implements IFake<IFake<?>>
	{
		// simple subtype
	}
	
	private static class TypeVariableFake<T> implements IFake<T>
	{
		// simple subtype
	}
	
	private static class SubFake extends Fake
	{
		// simple subtype
	}
	
	private static interface IFake2<T> extends IFake<T>
	{
		// simple subtype
	}
	
	private static class Fake2 implements IFake2<DummyClass>
	{
		// simple subtype
	}
	
	// AbstractTypeTest methods -----------------------------------------------
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void addImports(Set<Class<?>> imports)
	{
		imports.add(DummyClass.class);
		imports.add(IFake.class);
	}
	
	// tests ------------------------------------------------------------------
	
	@Test
	public void getResolvedSupertypeWithClassImplementation()
	{
		Type actual = TypeUtils.getResolvedSupertype(Fake.class, IFake.class);
		
		assertEquals(type("IFake<DummyClass>"), actual);
	}
	
	@Test
	public void getResolvedSupertypeWithParameterizedTypeImplementation()
	{
		Type actual = TypeUtils.getResolvedSupertype(ParameterizedTypeFake.class, IFake.class);
		
		assertEquals(type("IFake<IFake<?>>"), actual);
	}
	
	@Test
	public void getResolvedSupertypeWithTypeVariableImplementation()
	{
		Type actual = TypeUtils.getResolvedSupertype(TypeVariableFake.class, IFake.class);
		
		Type expected = parameterizedType(IFake.class, typeVariable(TypeVariableFake.class, "T"));
		assertEquals(expected, actual);
	}

	@Test
	public void getResolvedSupertypeWithSuperclassClassImplementation()
	{
		Type actual = TypeUtils.getResolvedSupertype(SubFake.class, IFake.class);
		
		assertEquals(type("IFake<DummyClass>"), actual);
	}
	
	@Test
	public void getResolvedSupertypeWithSuperinterfaceClassImplementation()
	{
		Type actual = TypeUtils.getResolvedSupertype(Fake2.class, IFake.class);
		
		assertEquals(type("IFake<DummyClass>"), actual);
	}
}
