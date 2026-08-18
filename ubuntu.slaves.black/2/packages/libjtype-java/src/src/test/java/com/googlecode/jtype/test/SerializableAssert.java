/*
 * Copyright 2010 IIZUKA Software Technologies Ltd
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

import static org.junit.Assert.assertEquals;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

/**
 * Provides custom assertions for testing serializable objects.
 * 
 * @author Mark Hobson
 * @version $Id: SerializableAssert.java 115 2011-11-25 18:17:40Z markhobson@gmail.com $
 */
public final class SerializableAssert
{
	// constructors -----------------------------------------------------------
	
	private SerializableAssert()
	{
		throw new AssertionError();
	}

	// public methods ---------------------------------------------------------
	
	public static void assertSerializable(Object object) throws IOException, ClassNotFoundException
	{
		byte[] bytes = serialize(object);
		Object actual = deserialize(bytes);
		
		assertEquals("Serialized object", object, actual);
	}
	
	// private methods --------------------------------------------------------
	
	private static byte[] serialize(Object object) throws IOException
	{
		ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
		ObjectOutputStream objectOut = new ObjectOutputStream(byteOut);
		
		try
		{
			objectOut.writeObject(object);
		}
		finally
		{
			objectOut.close();
		}
		
		return byteOut.toByteArray();
	}
	
	private static Object deserialize(byte[] bytes) throws IOException, ClassNotFoundException
	{
		ByteArrayInputStream byteIn = new ByteArrayInputStream(bytes);
		ObjectInputStream objectIn = new ObjectInputStream(byteIn);
		
		try
		{
			return objectIn.readObject();
		}
		finally
		{
			objectIn.close();
		}
	}
}
