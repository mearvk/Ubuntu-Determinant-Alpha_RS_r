/*
 * Copyright (C) 2012 Damien Raude-Morvan <drazzib@debian.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

package org.debian.security;

import java.io.File;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * @author Emmanuel Bourg
 * @version $Revision$, $Date$
 */
public class KeyStoreHandlerTest {

    private String ksFilename = "./target/test-classes/tests-cacerts";
    private char[] ksPassword = "changeit".toCharArray();

    /**
     * Test a simple open then write without any modification.
     */
    @Test
    public void testNoop() throws Exception {
        KeyStoreHandler keystore = new KeyStoreHandler(ksFilename, ksPassword);
        keystore.save();
    }

    /**
     * Test a to open a keystore and write without any modification
     * and then try to open it again with wrong password : will throw a
     * InvalidKeystorePassword
     */
    @Test
    public void testWriteThenOpenWrongPwd() throws Exception {
        try {
            KeyStoreHandler keystore = new KeyStoreHandler(ksFilename, ksPassword);
            keystore.save();
        } catch (InvalidKeystorePasswordException e) {
            fail();
        }

        try {
            KeyStoreHandler keystore = new KeyStoreHandler(ksFilename, "wrongpassword".toCharArray());
            fail();
            keystore.save();
        } catch (InvalidKeystorePasswordException e) {
            assertEquals("Cannot open Java keystore. Is the password correct?", e.getMessage());
        }
    }

    /**
     * Test a to open a keystore then remove its backing File (and replace it
     * with a directory with the same name) and try to write in to disk :
     * will throw an UnableToSaveKeystore
     */
    @Test
    public void testDeleteThenWrite() throws Exception {
        try {
            KeyStoreHandler keystore = new KeyStoreHandler(ksFilename, ksPassword);

            // Replace actual file by a directory !
            File file = new File(ksFilename);
            file.delete();
            file.mkdir();

            // Will fail with some IOException
            keystore.save();
            fail();
        } catch (UnableToSaveKeystoreException e) {
            assertEquals("There was a problem saving the new Java keystore.", e.getMessage());
        }
    }
}
