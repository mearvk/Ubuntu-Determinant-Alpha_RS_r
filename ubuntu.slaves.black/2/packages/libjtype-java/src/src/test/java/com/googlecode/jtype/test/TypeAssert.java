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

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.lang.reflect.GenericArrayType;
import java.lang.reflect.GenericDeclaration;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;

/**
 * Provides custom assertions for testing types.
 * 
 * @author Mark Hobson
 * @version $Id: TypeAssert.java 115 2011-11-25 18:17:40Z markhobson@gmail.com $
 */
public final class TypeAssert
{
	// constructors -----------------------------------------------------------
	
	private TypeAssert()
	{
		throw new AssertionError();
	}
	
	// public methods ---------------------------------------------------------
	
	public static <D extends GenericDeclaration> void assertTypeVariable(D expectedGenericDeclaration,
		String expectedName, Type[] expectedBounds, TypeVariable<D> actual)
	{
		assertNotNull(actual);
		assertEquals("Generic declaration", expectedGenericDeclaration, actual.getGenericDeclaration());
		assertEquals("Name", expectedName, actual.getName());
		assertArrayEquals("Bounds", expectedBounds, actual.getBounds());
	}
	
	public static void assertGenericArrayType(Type expectedComponentType, GenericArrayType actual)
	{
		assertNotNull(actual);
		assertEquals("Component type", expectedComponentType, actual.getGenericComponentType());
	}
	
	public static void assertParameterizedType(Class<?> expectedRawType, Type[] expectedActualTypeArguments,
		ParameterizedType actual)
	{
		assertParameterizedType(null, expectedRawType, expectedActualTypeArguments, actual);
	}
	
	public static void assertParameterizedType(Type expectedOwnerType, Class<?> expectedRawType,
		Type[] expectedActualTypeArguments, ParameterizedType actual)
	{
		assertNotNull(actual);
		assertEquals("Owner type", expectedOwnerType, actual.getOwnerType());
		assertEquals("Raw type", expectedRawType, actual.getRawType());
		assertArrayEquals("Actual type arguments", expectedActualTypeArguments, actual.getActualTypeArguments());
	}
	
	public static void assertWildcardType(Type[] expectedUpperBounds, Type[] expectedLowerBounds, WildcardType actual)
	{
		assertNotNull(actual);
		assertArrayEquals("Upper bounds", expectedUpperBounds, actual.getUpperBounds());
		assertArrayEquals("Lower bounds", expectedLowerBounds, actual.getLowerBounds());
	}
}
