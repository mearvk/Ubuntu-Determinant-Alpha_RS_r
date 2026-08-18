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

import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Queue;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;

import org.junit.Test;

/**
 * Tests {@code Generics}.
 * 
 * @author Mark Hobson
 * @version $Id: GenericsTest.java 86 2010-11-05 13:23:09Z markhobson $
 * @see Generics
 */
public class GenericsTest
{
	// tests ------------------------------------------------------------------
	
	@Test
	public void comparable()
	{
		assertEquals(new Generic<Comparable<?>>() {/**/}, Generics.comparable());
	}
	
	@Test
	public void comparableWithClass()
	{
		assertEquals(new Generic<Comparable<String>>() {/**/}, Generics.comparable(String.class));
	}
	
	@Test
	public void comparator()
	{
		assertEquals(new Generic<Comparator<?>>() {/**/}, Generics.comparator());
	}
	
	@Test
	public void comparatorWithClass()
	{
		assertEquals(new Generic<Comparator<String>>() {/**/}, Generics.comparator(String.class));
	}
	
	@Test
	public void enumeration()
	{
		assertEquals(new Generic<Enumeration<?>>() {/**/}, Generics.enumeration());
	}
	
	@Test
	public void enumerationWithClass()
	{
		assertEquals(new Generic<Enumeration<String>>() {/**/}, Generics.enumeration(String.class));
	}
	
	@Test
	public void iterable()
	{
		assertEquals(new Generic<Iterable<?>>() {/**/}, Generics.iterable());
	}
	
	@Test
	public void iterableWithClass()
	{
		assertEquals(new Generic<Iterable<String>>() {/**/}, Generics.iterable(String.class));
	}
	
	@Test
	public void iterator()
	{
		assertEquals(new Generic<Iterator<?>>() {/**/}, Generics.iterator());
	}
	
	@Test
	public void iteratorWithClass()
	{
		assertEquals(new Generic<Iterator<String>>() {/**/}, Generics.iterator(String.class));
	}
	
	@Test
	public void listIterator()
	{
		assertEquals(new Generic<ListIterator<?>>() {/**/}, Generics.listIterator());
	}
	
	@Test
	public void listIteratorWithClass()
	{
		assertEquals(new Generic<ListIterator<String>>() {/**/}, Generics.listIterator(String.class));
	}
	
	@Test
	public void collection()
	{
		assertEquals(new Generic<Collection<?>>() {/**/}, Generics.collection());
	}
	
	@Test
	public void collectionWithClass()
	{
		assertEquals(new Generic<Collection<String>>() {/**/}, Generics.collection(String.class));
	}
	
	@Test
	public void set()
	{
		assertEquals(new Generic<Set<?>>() {/**/}, Generics.set());
	}
	
	@Test
	public void setWithClass()
	{
		assertEquals(new Generic<Set<String>>() {/**/}, Generics.set(String.class));
	}
	
	@Test
	public void sortedSet()
	{
		assertEquals(new Generic<SortedSet<?>>() {/**/}, Generics.sortedSet());
	}
	
	@Test
	public void sortedSetWithClass()
	{
		assertEquals(new Generic<SortedSet<String>>() {/**/}, Generics.sortedSet(String.class));
	}
	
	@Test
	public void list()
	{
		assertEquals(new Generic<List<?>>() {/**/}, Generics.list());
	}
	
	@Test
	public void listWithClass()
	{
		assertEquals(new Generic<List<String>>() {/**/}, Generics.list(String.class));
	}
	
	@Test
	public void map()
	{
		assertEquals(new Generic<Map<?, ?>>() {/**/}, Generics.map());
	}
	
	@Test
	public void mapWithClasses()
	{
		assertEquals(new Generic<Map<String, Integer>>() {/**/}, Generics.map(String.class, Integer.class));
	}
	
	@Test
	public void sortedMap()
	{
		assertEquals(new Generic<SortedMap<?, ?>>() {/**/}, Generics.sortedMap());
	}
	
	@Test
	public void sortedMapWithClasses()
	{
		assertEquals(new Generic<SortedMap<String, Integer>>() {/**/}, Generics.sortedMap(String.class, Integer.class));
	}
	
	@Test
	public void queue()
	{
		assertEquals(new Generic<Queue<?>>() {/**/}, Generics.queue());
	}
	
	@Test
	public void queueWithClass()
	{
		assertEquals(new Generic<Queue<String>>() {/**/}, Generics.queue(String.class));
	}
}
