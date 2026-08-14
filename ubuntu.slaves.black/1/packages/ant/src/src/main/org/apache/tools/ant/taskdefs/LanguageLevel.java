package org.apache.tools.ant.taskdefs;

import java.util.ArrayList;
import java.util.List;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.util.JavaEnvUtils;

class LanguageLevel {

    /** Detect if a Debian build is in process */
    static boolean isDebianBuild() {
        return System.getenv("DEB_BUILD_ARCH") != null;
    }

    /**
     * Tells if the specified language level is supported by the current javac.
     */
    static boolean isLevelSupported(String level) {
        List<String> unsupportedLevels = new ArrayList<>();
        if (JavaEnvUtils.isAtLeastJavaVersion("9")) {
            unsupportedLevels.add("1.1");
            unsupportedLevels.add("1.2");
            unsupportedLevels.add("1.3");
            unsupportedLevels.add("1.4");
            unsupportedLevels.add("1.5");
            unsupportedLevels.add("5");
        }
        if (JavaEnvUtils.isAtLeastJavaVersion("12")) {
            unsupportedLevels.add("1.6");
            unsupportedLevels.add("6");
        }

        return !unsupportedLevels.contains(level);
    }

    /**
     * Returns the minimum language level supported by the current javac.
     */
    static String getMinimumLevel() {
        if (JavaEnvUtils.isAtLeastJavaVersion("12")) {
            return "7";
        }

        return "6";
    }

    /**
     * Adjust the source/target level automatically for Debian builds with Java 9 or later.
     *
     * @param level    the source/target level to be adjusted
     * @param location the command or property referring to the specified level
     * @param logger   the calling task used for logging purpose
     */
    static String adjust(String level, String location, Task logger) {
        if (level == null) {
            return level;
        }

        if (!isDebianBuild()) {
            // only do this is it's a Debian package build
            return level;
        }

        if (isLevelSupported(level)) {
            return level;
        }

	String minLevel = getMinimumLevel();
        if (logger != null) {
            logger.log("Using " + location + " "  + level + " is no longer supported, switching to " + minLevel, Project.MSG_WARN);
        }

        return minLevel;
    }
}
