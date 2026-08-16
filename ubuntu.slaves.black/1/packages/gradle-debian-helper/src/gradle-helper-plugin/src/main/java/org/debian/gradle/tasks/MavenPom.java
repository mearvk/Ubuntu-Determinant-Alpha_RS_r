/**
 * Copyright 2016 Kai-Chung Yan (殷啟聰)
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

package org.debian.gradle.tasks;

import org.codehaus.groovy.runtime.MethodClosure;
import org.codehaus.groovy.runtime.NullObject;
import org.gradle.api.DefaultTask;
import org.gradle.api.plugins.BasePluginConvention;
import org.gradle.api.plugins.MavenPluginConvention;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.OutputFile;
import org.gradle.api.tasks.TaskAction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.Collections;
import java.util.Comparator;

public class MavenPom extends DefaultTask {

    private final Logger log = LoggerFactory.getLogger(MavenPom.class);

    /* Since the Groovy in Gradle scripts are dynamically typed and due to
       Gradle's own class loading mechanism, we couldn't cast the type of
       org.apache.maven.model.Dependency. So we have to use Reflections. */
    private String getMavenDependencyProperty(Object dependency, String property) {
        String result = null;
        try {
            result = ((String)dependency.getClass()
                                        .getMethod("get" + property.substring(0, 1).toUpperCase() + property.substring(1))
                                        .invoke(dependency));
        } finally {
            return (result == null) ? "" : result;
        }
    }

    private void setMavenDependencyProperty(Object dependency, String property, String value) {
        try {
           dependency.getClass()
                     .getMethod("set" + property.substring(0, 1).toUpperCase() + property.substring(1), String.class)
                     .invoke(dependency, value);
        } catch (Exception e) {
            throw new RuntimeException("Unable to set the property '" + property + "' to '" + value + "' on " + dependency);
        }
    }

    private String getMavenDependencyScope(Object dependency) {
        return getMavenDependencyProperty(dependency, "scope");
    }

    private String getMavenDependencyGroupId(Object dependency) {
        return getMavenDependencyProperty(dependency, "groupId");
    }

    private String getMavenDependencyArtifactId(Object dependency) {
        return getMavenDependencyProperty(dependency, "artifactId");
    }

    private String getMavenDependencyVersion(Object dependency) {
        return getMavenDependencyProperty(dependency, "version");
    }

    private void sortPomDependencies(org.gradle.api.artifacts.maven.MavenPom pom) {
        Collections.sort(
            pom.getDependencies(),
            new Comparator<Object>() {
                @Override
                public int compare(Object o1, Object o2) {
                    if (getMavenDependencyScope(o1).compareTo(getMavenDependencyScope(o2)) != 0) {
                        return getMavenDependencyScope(o1).compareTo(getMavenDependencyScope(o2));
                    } else if (getMavenDependencyGroupId(o1).compareTo(getMavenDependencyGroupId(o2)) != 0) {
                        return getMavenDependencyGroupId(o1).compareTo(getMavenDependencyGroupId(o2));
                    } else if (getMavenDependencyArtifactId(o1).compareTo(getMavenDependencyArtifactId(o2)) != 0) {
                        return getMavenDependencyArtifactId(o1).compareTo(getMavenDependencyArtifactId(o2));
                    } else {
                        return getMavenDependencyVersion(o1).compareTo(getMavenDependencyVersion(o2));
                    }
                }
                @Override
                public boolean equals(Object obj) { return false; }
            }
        );
    }

    /**
     * Turns the dependencies with a scope set to 'optional' into dependencies
     * with a 'compile' scope and the optional attribute set to true.
     */
    private void fixOptionalDependencies(org.gradle.api.artifacts.maven.MavenPom pom) {
        for (Object dependency : pom.getDependencies()) {
            if (dependency.getClass().getName().equals("org.apache.maven.model.Dependency")) {
                 if ("optional".equals(getMavenDependencyScope(dependency))) {
                     setMavenDependencyProperty(dependency, "optional", "true");
                     setMavenDependencyProperty(dependency, "scope", "compile");
                 }
            }
        }
    }

    @OutputDirectory
    private File getDestinationPomDir() {
        return new File(getProject().getBuildDir(), "debian");
    }

    @OutputFile
    private File getDestinationPomFile() {
        return new File(
            getDestinationPomDir(),
            getProject().getConvention()
                        .getPlugin(BasePluginConvention.class)
                        .getArchivesBaseName() + ".pom"
        );
    }

    @TaskAction
    private void generatePom() {
        final org.gradle.api.artifacts.maven.MavenPom pom =
                             getProject().getConvention()
                                         .getPlugin(MavenPluginConvention.class)
                                         .pom();
        pom.project(new MethodClosure(
            new Object() { public void execute() {} },
            "execute"
        ));
        pom.setArtifactId(getProject().getConvention()
                                      .getPlugin(BasePluginConvention.class)
                                      .getArchivesBaseName());
        final org.gradle.api.artifacts.maven.MavenPom effectivePom =
                                                          pom.getEffectivePom();
        fixOptionalDependencies(effectivePom);
        sortPomDependencies(effectivePom);
        getDestinationPomDir().mkdir();
        log.info("\tGenerating pom file " + getDestinationPomFile());
        effectivePom.writeTo(getDestinationPomFile());
    }
}
