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

/**
 * Factory for creating common generics.
 * 
 * @author Mark Hobson
 * @version $Id: Generics.java 86 2010-11-05 13:23:09Z markhobson $
 * @see Generic
 */
@SuppressWarnings("unchecked")
public final class Generics
{
	// constants --------------------------------------------------------------
	
	private static final Generic<Comparable<?>> COMPARABLE = (Generic<Comparable<?>>) Generic.get(Comparable.class,
		Types.unboundedWildcardType());

	private static final Generic<Comparator<?>> COMPARATOR = (Generic<Comparator<?>>) Generic.get(Comparator.class,
		Types.unboundedWildcardType());
	
	private static final Generic<Enumeration<?>> ENUMERATION = (Generic<Enumeration<?>>) Generic.get(Enumeration.class,
		Types.unboundedWildcardType());
	
	private static final Generic<Iterable<?>> ITERABLE = (Generic<Iterable<?>>) Generic.get(Iterable.class,
		Types.unboundedWildcardType());
	
	private static final Generic<Iterator<?>> ITERATOR = (Generic<Iterator<?>>) Generic.get(Iterator.class,
		Types.unboundedWildcardType());
	
	private static final Generic<ListIterator<?>> LIST_ITERATOR = (Generic<ListIterator<?>>) Generic.get(
		ListIterator.class, Types.unboundedWildcardType());
	
	private static final Generic<Collection<?>> COLLECTION = (Generic<Collection<?>>) Generic.get(Collection.class,
		Types.unboundedWildcardType());
	
	private static final Generic<Set<?>> SET = (Generic<Set<?>>) Generic.get(Set.class, Types.unboundedWildcardType());
	
	private static final Generic<SortedSet<?>> SORTED_SET = (Generic<SortedSet<?>>) Generic.get(SortedSet.class,
		Types.unboundedWildcardType());
	
	private static final Generic<List<?>> LIST = (Generic<List<?>>) Generic.get(List.class,
		Types.unboundedWildcardType());
	
	private static final Generic<Map<?, ?>> MAP = (Generic<Map<?, ?>>) Generic.get(Map.class,
		Types.unboundedWildcardType(), Types.unboundedWildcardType());
	
	private static final Generic<SortedMap<?, ?>> SORTED_MAP = (Generic<SortedMap<?, ?>>) Generic.get(SortedMap.class,
		Types.unboundedWildcardType(), Types.unboundedWildcardType());
	
	private static final Generic<Queue<?>> QUEUE = (Generic<Queue<?>>) Generic.get(Queue.class,
		Types.unboundedWildcardType());
	
	// constructors -----------------------------------------------------------
	
	private Generics()
	{
		throw new AssertionError();
	}
	
	// public methods ---------------------------------------------------------
	
	public static Generic<Comparable<?>> comparable()
	{
		return COMPARABLE;
	}
	
	public static <T> Generic<Comparable<T>> comparable(Class<T> type)
	{
		return (Generic<Comparable<T>>) Generic.get(Comparable.class, type);
	}
	
	public static Generic<Comparator<?>> comparator()
	{
		return COMPARATOR;
	}
	
	public static <T> Generic<Comparator<T>> comparator(Class<T> type)
	{
		return (Generic<Comparator<T>>) Generic.get(Comparator.class, type);
	}
	
	public static Generic<Enumeration<?>> enumeration()
	{
		return ENUMERATION;
	}
	
	public static <E> Generic<Enumeration<E>> enumeration(Class<E> elementClass)
	{
		return (Generic<Enumeration<E>>) Generic.get(Enumeration.class, elementClass);
	}
	
	public static Generic<Iterable<?>> iterable()
	{
		return ITERABLE;
	}
	
	public static <T> Generic<Iterable<T>> iterable(Class<T> elementClass)
	{
		return (Generic<Iterable<T>>) Generic.get(Iterable.class, elementClass);
	}
	
	public static Generic<Iterator<?>> iterator()
	{
		return ITERATOR;
	}
	
	public static <E> Generic<Iterator<E>> iterator(Class<E> elementClass)
	{
		return (Generic<Iterator<E>>) Generic.get(Iterator.class, elementClass);
	}
	
	public static Generic<ListIterator<?>> listIterator()
	{
		return LIST_ITERATOR;
	}
	
	public static <E> Generic<ListIterator<E>> listIterator(Class<E> elementClass)
	{
		return (Generic<ListIterator<E>>) Generic.get(ListIterator.class, elementClass);
	}
	
	public static Generic<Collection<?>> collection()
	{
		return COLLECTION;
	}
	
	public static <E> Generic<Collection<E>> collection(Class<E> elementClass)
	{
		return (Generic<Collection<E>>) Generic.get(Collection.class, elementClass);
	}
	
	public static Generic<Set<?>> set()
	{
		return SET;
	}
	
	public static <E> Generic<Set<E>> set(Class<E> elementClass)
	{
		return (Generic<Set<E>>) Generic.get(Set.class, elementClass);
	}
	
	public static Generic<SortedSet<?>> sortedSet()
	{
		return SORTED_SET;
	}
	
	public static <E> Generic<SortedSet<E>> sortedSet(Class<E> elementClass)
	{
		return (Generic<SortedSet<E>>) Generic.get(SortedSet.class, elementClass);
	}
	
	public static Generic<List<?>> list()
	{
		return LIST;
	}
	
	public static <E> Generic<List<E>> list(Class<E> elementClass)
	{
		return (Generic<List<E>>) Generic.get(List.class, elementClass);
	}
	
	public static Generic<Map<?, ?>> map()
	{
		return MAP;
	}
	
	public static <K, V> Generic<Map<K, V>> map(Class<K> keyClass, Class<V> valueClass)
	{
		return (Generic<Map<K, V>>) Generic.get(Map.class, keyClass, valueClass);
	}
	
	public static Generic<SortedMap<?, ?>> sortedMap()
	{
		return SORTED_MAP;
	}
	
	public static <K, V> Generic<SortedMap<K, V>> sortedMap(Class<K> keyClass, Class<V> valueClass)
	{
		return (Generic<SortedMap<K, V>>) Generic.get(SortedMap.class, keyClass, valueClass);
	}
	
	public static Generic<Queue<?>> queue()
	{
		return QUEUE;
	}
	
	public static <E> Generic<Queue<E>> queue(Class<E> elementClass)
	{
		return (Generic<Queue<E>>) Generic.get(Queue.class, elementClass);
	}
}
