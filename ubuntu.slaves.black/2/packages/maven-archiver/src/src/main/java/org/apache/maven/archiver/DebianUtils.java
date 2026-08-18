package org.apache.maven.archiver;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

class DebianUtils {

    /**
     * Returns the Debian build date specified by the DEB_CHANGELOG_DATETIME environment variable.
     */
    static Date getDebianBuildDate() {
        String envName = "DEB_CHANGELOG_DATETIME";
        String envVariable = System.getenv(envName);
        if (envVariable == null) {
            return null;
        }

        try {
            return new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss zzz", java.util.Locale.ENGLISH).parse(envVariable);
        } catch (ParseException e) {
            throw new IllegalArgumentException("maven-archiver: " + envName + " not in recognised format", e);
        }
    }
}
