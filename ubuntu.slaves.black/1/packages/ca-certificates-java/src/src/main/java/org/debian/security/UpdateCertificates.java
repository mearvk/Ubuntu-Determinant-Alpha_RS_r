/*
 * Copyright (C) 2011 Torsten Werner <twerner@debian.org>
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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.security.GeneralSecurityException;
import java.security.cert.Certificate;

/**
 * This code is a re-implementation of the idea from Ludwig Nussel found in
 * https://github.com/openSUSE/ca-certificates/blob/41917f5a/keystore.java
 * for the Debian operating system. It updates the global JVM keystore.
 *
 * @author Torsten Werner
 * @author Damien Raude-Morvan
 */
public class UpdateCertificates {

    private KeyStoreHandler keystore;

    public static void main(String[] args) throws IOException, GeneralSecurityException {
        String passwordString = "changeit";
        if (args.length == 2 && args[0].equals("-storepass")) {
            passwordString = args[1];
        } else if (args.length > 0) {
            System.err.println("Usage: java org.debian.security.UpdateCertificates [-storepass <password>]");
            System.exit(1);
        }

        try {
            UpdateCertificates uc = new UpdateCertificates("/etc/ssl/certs/java/cacerts", passwordString);
            // Force reading of inputstream in UTF-8
            uc.processChanges(new InputStreamReader(System.in, "UTF8"));
            uc.finish();
        } catch (InvalidKeystorePasswordException e) {
            e.printStackTrace(System.err);
            System.exit(1);
        } catch (UnableToSaveKeystoreException e) {
            e.printStackTrace(System.err);
            System.exit(1);
        }
    }

    public UpdateCertificates(String keystoreFile, String password) throws IOException, GeneralSecurityException, InvalidKeystorePasswordException {
        this.keystore = new KeyStoreHandler(keystoreFile, password.toCharArray());
    }

    /**
     * Until reader EOF, try to read changes and send each to {@link #parseLine(String)}.
     */
    protected void processChanges(Reader reader) throws IOException, GeneralSecurityException {
        String line;
        BufferedReader in = new BufferedReader(reader);
        while ((line = in.readLine()) != null) {
            try {
                parseLine(line);
            } catch (UnknownInputException e) {
                System.err.println("Unknown input: " + line);
                // Keep processing for others lines
            }
        }
    }

    /**
     * Parse given line to choose between {@link #addAlias(String, Certificate)}
     * or {@link #deleteAlias(String)}.
     */
    protected void parseLine(final String line) throws GeneralSecurityException, IOException, UnknownInputException {
        String path = line.substring(1);
        String filename = path.substring(path.lastIndexOf("/") + 1);
        String alias = "debian:" + filename;
        if (line.startsWith("+")) {
            keystore.addAlias(alias, path);
        } else if (line.startsWith("-")) {
            keystore.deleteAlias(alias);
            // Remove old non-prefixed aliases, too. This code should be
            // removed after the release of Wheezy.
            keystore.deleteAlias(filename);
        } else {
            throw new UnknownInputException(line);
        }
    }

    /**
     * Write the pending changes to the keystore file.
     */
    protected void finish() throws GeneralSecurityException, UnableToSaveKeystoreException {
        keystore.save();
    }
}
