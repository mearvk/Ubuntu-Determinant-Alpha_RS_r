/**
 * Copyright 2015 Emmanuel Bourg
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

import java.util.HashMap;
import java.util.Map;

import org.debian.gradle.tasks.MavenPom;
import org.gradle.api.Action;
import org.gradle.api.Plugin;
import org.gradle.api.Project;
import org.gradle.api.Task;
import org.gradle.api.artifacts.repositories.MavenArtifactRepository;
import org.gradle.api.invocation.Gradle;
import org.gradle.api.tasks.javadoc.Javadoc;
import org.gradle.external.javadoc.StandardJavadocDocletOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Gradle plugin installing the Debian repository before those defined in the build script.
 */
public class DebianHelperPlugin implements Plugin<Gradle> {

    private final Logger log = LoggerFactory.getLogger(DebianHelperPlugin.class);

    @Override
    public void apply(Gradle gradle) {
        // add the Debian repository to all projects
        gradle.allprojects(new Action<Project>() {
            @Override
            public void execute(final Project project) {
                log.info("\tAdding Debian repository to project '" + project.getName() + "'");
                Map<String, String> repositoryParams = new HashMap<>();
                repositoryParams.put("name", "Debian Maven Repository");
                repositoryParams.put("url",  "file:/usr/share/maven-repo/");

                MavenArtifactRepository repository = project.getRepositories().mavenCentral(repositoryParams);
                project.getRepositories().remove(repository);
                project.getRepositories().addFirst(repository);
                project.getBuildscript().getRepositories().addFirst(repository);
            }
        });

        // generate the Maven pom after building a project
        gradle.allprojects(new Action<Project>() {
            @Override
            public void execute(final Project project) {
                project.afterEvaluate(new Action<Project>() {
                    @Override
                    public void execute(Project project) {
                      if (project.getPluginManager().hasPlugin("java")) {
                          log.info("\tAdding Maven pom generation to project '" + project.getName() + "'");
                          project.getPluginManager().apply("maven");
                          Map<String, Class> debianMavenPomTaskOptions = new HashMap<String, Class>();
                          debianMavenPomTaskOptions.put("type", MavenPom.class);
                          project.task(debianMavenPomTaskOptions, "debianMavenPom");
                          ((Task) project.getTasksByName("jar", false).toArray()[0]).dependsOn("debianMavenPom");
                      }
                    }
                });
            }
        });

        // link the javadoc with the system documentation
        gradle.allprojects(new Action<Project>() {
            @Override
            public void execute(final Project project) {
                project.afterEvaluate(new Action<Project>() {
                    @Override
                    public void execute(Project project) {
                        if (project.getPluginManager().hasPlugin("java")) {
                            Javadoc javadocTask = ((Javadoc) (project.getTasksByName("javadoc", false).toArray()[0]));
                            if (javadocTask.getOptions() instanceof StandardJavadocDocletOptions) {
                                log.info("\tLinking the generated javadoc to the system JDK API documentation");
                                ((StandardJavadocDocletOptions) javadocTask.getOptions()).getLinks().add(0, "file:///usr/share/doc/default-jdk/api");
                            }
                        }
                    }
                });
            }
        });

        // start a timer displaying a message periodically to prevent the builders from killing Gradle on slow architectures
        gradle.addBuildListener(new KeepAliveTimer());

        // initialize the project name if necessary
        gradle.addBuildListener(new ProjectNameInitializer());
    }
}

