/*
 * Distributed as part of c3p0 v.0.9.1.2
 *
 * Copyright (C) 2005 Machinery For Change, Inc.
 *
 * Author: Steve Waldman <swaldman@mchange.com>
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 2.1, as 
 * published by the Free Software Foundation.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this software; see the file LICENSE.  If not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307, USA.
 */


package com.mchange.v2.util.junit;

import java.util.Iterator;
import java.util.Map;

import com.mchange.v2.util.DoubleWeakHashMap;

import junit.framework.TestCase;

public class DoubleWeakHashMapJUnitTestCase extends TestCase
{
    public void testGetNeverAdded()
    {
        Map m = new DoubleWeakHashMap();
        assertNull( m.get("foo") );
    }
    
    public void testHardAdds()
    {
        Integer a = new Integer(1);
        Integer b = new Integer(2);
        Integer c = new Integer(3);
        
        String poop = new String("poop");
        String scoop = new String("scoop");
        String doop = new String("dcoop");
        
        Map m = new DoubleWeakHashMap();
        m.put(a, poop);
        m.put(b, scoop);
        m.put(c, doop);
        assertEquals("Size should be three, viewed via Map directly.", m.size(), 3);
        assertEquals("Size should be three, viewed via keySet .", m.keySet().size(), 3);
        assertEquals("Size should be three, viewed via values Collection.", m.values().size(), 3);
        
        int count = 0;
        for (Iterator ii = m.keySet().iterator(); ii.hasNext();)
        {
            count += ((Integer) ii.next()).intValue();
        }
        assertEquals("Count should be six, viewed via values Collection.", count, 6);
        
        Integer d = new Integer(4);
        m.put(d, poop);
        m.values().remove(poop);
        assertEquals("After removing a doubled value, size should be 2", m.size(), 2);
    }
}
