/*
 * Copyright 2009 IIZUKA Software Technologies Ltd
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

import static org.junit.Assert.assertEquals;

import org.junit.Test;

/**
 * Tests {@code ClassUtils}.
 * 
 * @author Mark Hobson
 * @version $Id: ClassUtilsTest.java 82 2010-11-01 11:22:10Z markhobson $
 * @see ClassUtils
 */
public class ClassUtilsTest
{
	// test methods -----------------------------------------------------------
	
	@Test
	public void getSimpleClassNameWithClass()
	{
		assertEquals("A", ClassUtils.getSimpleClassName("A"));
	}
	
	@Test
	public void getSimpleClassNameWithClassInPackage()
	{
		assertEquals("B", ClassUtils.getSimpleClassName("a.B"));
	}
	
	@Test
	public void getSimpleClassNameWithClassInDeepPackage()
	{
		assertEquals("C", ClassUtils.getSimpleClassName("a.b.C"));
	}
	
	@Test
	public void getSimpleClassNameWithMemberClass()
	{
		assertEquals("B", ClassUtils.getSimpleClassName("A$B"));
	}
	
	@Test
	public void getSimpleClassNameWithMemberClassInPackage()
	{
		assertEquals("C", ClassUtils.getSimpleClassName("a.B$C"));
	}

	@Test
	public void getSimpleClassNameWithMemberClassInDeepPackage()
	{
		assertEquals("D", ClassUtils.getSimpleClassName("a.b.C$D"));
	}
	
	@Test
	public void getSimpleClassNameWithDeepMemberClass()
	{
		assertEquals("C", ClassUtils.getSimpleClassName("A$B$C"));
	}
	
	@Test
	public void getSimpleClassNameWithDeepMemberClassInPackage()
	{
		assertEquals("D", ClassUtils.getSimpleClassName("a.B$C$D"));
	}
	
	@Test
	public void getSimpleClassNameWithDeepMemberClassInDeepPackage()
	{
		assertEquals("E", ClassUtils.getSimpleClassName("a.b.C$D$E"));
	}
	
	@Test
	public void valueOfWithBooleanPrimitive()
	{
		assertEquals(Boolean.TYPE, ClassUtils.valueOf("boolean"));
	}
	
	@Test
	public void valueOfWithBytePrimitive()
	{
		assertEquals(Byte.TYPE, ClassUtils.valueOf("byte"));
	}
	
	@Test
	public void valueOfWithCharPrimitive()
	{
		assertEquals(Character.TYPE, ClassUtils.valueOf("char"));
	}
	
	@Test
	public void valueOfWithDoublePrimitive()
	{
		assertEquals(Double.TYPE, ClassUtils.valueOf("double"));
	}
	
	@Test
	public void valueOfWithFloatPrimitive()
	{
		assertEquals(Float.TYPE, ClassUtils.valueOf("float"));
	}
	
	@Test
	public void valueOfWithIntPrimitive()
	{
		assertEquals(Integer.TYPE, ClassUtils.valueOf("int"));
	}
	
	@Test
	public void valueOfWithLongPrimitive()
	{
		assertEquals(Long.TYPE, ClassUtils.valueOf("long"));
	}
	
	@Test
	public void valueOfWithShortPrimitive()
	{
		assertEquals(Short.TYPE, ClassUtils.valueOf("short"));
	}
	
	@Test
	public void valueOfWithClass()
	{
		assertEquals(Integer.class, ClassUtils.valueOf("java.lang.Integer"));
	}
}
