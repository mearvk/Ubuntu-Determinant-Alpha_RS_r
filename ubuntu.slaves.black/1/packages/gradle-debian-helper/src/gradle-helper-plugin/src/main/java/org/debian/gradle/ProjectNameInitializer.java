/**
 * Copyright 2016 Emmanuel Bourg
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.debian.gradle;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

import org.gradle.BuildAdapter;
import org.gradle.api.initialization.Settings;
import org.gradle.api.invocation.Gradle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Build listener initializing the name of the root project if necessary.
 *
 * Gradle uses the rootProject.name property in the settings.gradle file,
 * but if the property isn't defined the name of the directory is used instead.
 * Thus the name of the artifacts created depends on the name of the base
 * directory, and this can lead to build failures during the install phase
 * because the files don't have the expected name.
 *
 * To work around this issue this build listener changes the project name
 * on the fly and uses the name of the source package if the settings.gradle
 * file is missing, or if it doesn't define the rootProject.name property.
 */
class ProjectNameInitializer extends BuildAdapter {

    private final Logger log = LoggerFactory.getLogger(ProjectNameInitializer.class);

    @Override
    public void settingsEvaluated(Settings settings) {
        if ("buildSrc".equals(settings.getRootProject().getName())) {
            return;
        }

        File settingsFile = new File(settings.getSettingsDir(), "settings.gradle");
        if (!settingsFile.exists()) {
            log.info("\tSettings file not found (" + settingsFile + ")");
        } else if (!contains(settingsFile, "rootProject.name")) {
            log.info("\tSettings file found (" + settingsFile + "), but rootProject.name isn't defined");
        } else {
            return;
        }

        String name = System.getProperty("debian.package");
        log.info("\tRoot project name not defined in settings.gradle, defaulting to '" + name + "' instead of the name of the root directory '" + settings.getRootProject().getName() + "'");
        settings.getRootProject().setName(name);
    }

    private boolean contains(File file, String s) {
        try (Scanner scanner = new Scanner(file, "ISO-8859-1")) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line != null && line.trim().startsWith(s)) {
                    return true;
                }
            }
        } catch (IOException e) {
            log.warn("Couldn't look for " + s + " in " + file, e);
        }

        return false;
    }

}
