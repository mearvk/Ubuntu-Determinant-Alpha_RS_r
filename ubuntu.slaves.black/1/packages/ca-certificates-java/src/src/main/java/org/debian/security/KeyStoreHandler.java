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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;

/**
 * Handles read/write operations on a keystore.
 */
class KeyStoreHandler {

    /** The path of the keystore */
    private String filename;

    /** The password of the keystore */
    private char[] password;

    private KeyStore ks;
    
    private CertificateFactory certFactory;

    KeyStoreHandler(String filename, char[] password) throws GeneralSecurityException, IOException, InvalidKeystorePasswordException {
        this.filename = filename;
        this.password = password;
        this.certFactory = CertificateFactory.getInstance("X.509");
        
        load();
    }

    /**
     * Try to open an existing keystore or create an new one.
     */
    public void load() throws GeneralSecurityException, IOException, InvalidKeystorePasswordException {
        KeyStore ks = KeyStore.getInstance("JKS");
        File file = new File(filename);
        FileInputStream in = null;
        if (file.canRead()) {
            in = new FileInputStream(file);
        }
        try {
            ks.load(in, password);
        } catch (IOException e) {
            throw new InvalidKeystorePasswordException("Cannot open Java keystore. Is the password correct?", e);
        } finally {
            if (in != null) {
                in.close();
            }
        }
        this.ks = ks;
    }

    /**
     * Write actual keystore content to disk.
     */
    public void save() throws GeneralSecurityException, UnableToSaveKeystoreException {
        try {
            FileOutputStream certOutputFile = new FileOutputStream(filename);
            ks.store(certOutputFile, password);
            certOutputFile.close();
        } catch (IOException e) {
            throw new UnableToSaveKeystoreException("There was a problem saving the new Java keystore.", e);
        }
    }

    /**
     * Add or replace existing cert in keystore with given alias.
     */
    public void addAlias(String alias, String path) throws KeyStoreException {
        Certificate cert = loadCertificate(path);
        if (cert == null) {
            return;
        }
        addAlias(alias, cert);
    }
    
    /**
     * Add or replace existing cert in keystore with given alias.
     */
    public void addAlias(String alias, Certificate cert) throws KeyStoreException {
        if (contains(alias)) {
            System.out.println("Replacing " + alias);
            ks.deleteEntry(alias);
        } else {
            System.out.println("Adding " + alias);
        }
        ks.setCertificateEntry(alias, cert);
    }

    /**
     * Delete cert in keystore at given alias.
     */
    public void deleteAlias(String alias) throws GeneralSecurityException {
        if (contains(alias)) {
            System.out.println("Removing " + alias);
            ks.deleteEntry(alias);
        }
    }

    /**
     * Returns true when alias exist in keystore.
     */
    public boolean contains(String alias) throws KeyStoreException {
        return ks.containsAlias(alias);
    }

    /**
     * Try to load a certificate instance from given path.
     */
    private Certificate loadCertificate(String path) {
        Certificate certificate = null;
        try {
            FileInputStream in = new FileInputStream(path);
            certificate = certFactory.generateCertificate(in);
            in.close();
        } catch (Exception e) {
            System.err.println("Warning: there was a problem reading the certificate file " +
                    path + ". Message:\n  " + e.getMessage());
        }
        return certificate;
    }
}
