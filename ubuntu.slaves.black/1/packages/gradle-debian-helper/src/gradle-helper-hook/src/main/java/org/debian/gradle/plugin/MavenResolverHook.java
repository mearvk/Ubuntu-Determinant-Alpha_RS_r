/**
 * Copyright 2018 Emmanuel Bourg
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

package org.debian.gradle.plugin;

import java.util.HashMap;
import java.util.Map;

import org.debian.maven.cliargs.ArgumentsIterable;
import org.debian.maven.cliargs.ArgumentsMap;
import org.debian.maven.repo.Dependency;
import org.debian.maven.repo.DependencyRule;
import org.debian.maven.repo.DependencyRuleSetFiles;

/**
 * Hook for Gradle's MavenResolver class.
 */
public class MavenResolverHook {

    private static final MavenResolverHook INSTANCE = new MavenResolverHook();

    /** The substitution rules for the Maven dependencies */
    private DependencyRuleSetFiles rulesets;

    /** The placeholder used for ignored dependencies */
    private static final Dependency IGNORED_DEPENDENCY_PLACEHOLDER = new Dependency("org.debian.gradle", "gradle-dependency-placeholder", "jar", "1.0", "compile", false, null, null);

    private MavenResolverHook() {
    }

    public static MavenResolverHook getInstance() {
        return INSTANCE;
    }

    private void initRules() {
        System.out.println("\tLoading the Maven rules...");
        ArgumentsMap args = new ArgumentsMap(new ArgumentsIterable(new String[] { "--rules=debian/maven.rules", "--ignore-rules=debian/maven.ignoreRules"}));
        rulesets = DependencyRuleSetFiles.fromCLIArguments(args, false);
        rulesets.addDefaultRules();
    }

    public Map<String, String> rewrite(String groupId, String artifactId, String version, String type, String classifier) throws Exception {
        if (rulesets == null) {
            initRules();
        }
        Dependency dependency = new Dependency(groupId, artifactId, type, version, "compile", false, classifier, null);
        Dependency resolved = resolve(dependency);

        if (resolved == null) {
            System.out.println("\tIgnoring " + format(dependency));
            resolved = IGNORED_DEPENDENCY_PLACEHOLDER;

        } else if (dependency == resolved) {
            System.out.println("\tPassing through " + format(dependency));
        } else {
            System.out.println("\tReplacing " + format(dependency) + "  ->  " + format(resolved));
        }

        Map<String, String> result = new HashMap<String, String>();
        result.put("groupId", resolved.getGroupId());
        result.put("artifactId", resolved.getArtifactId());
        result.put("version", resolved.getVersion());
        result.put("type", resolved.getType());
        result.put("classifier", resolved.getClassifier());

        return result;
    }

    /**
     * Apply the Maven rules to the specified dependency.
     *
     * @param dependency the resolved dependency, or null if the dependency is ignored.
     */
    private Dependency resolve(Dependency dependency) {
        // check if the dependency is ignored
        for (DependencyRule rule : rulesets.get(DependencyRuleSetFiles.RulesType.IGNORE).getRules()) {
            if (rule.matches(dependency)) {
                return null;
            }
        }

        /**
         * The transitive dependencies are also resolved but unfortunately there is no way to detect them as such.
         * This means that a transitive dependency on asm:4.x for example would be transformed into asm:debian unless
         * its rule is copied into debian/maven.rules in order to preserve the generic '4.x' version. To mitigate this
         * issue the '.x' generic versions are detected and passed through. Artifacts with no generic version are still
         * affected though, and their rules have to be added to debian/maven.rules.
         */
        if (!dependency.getVersion().endsWith(".x") && !dependency.getVersion().equals("debian")) {
            // apply the first rule that matches
            for (DependencyRule rule : rulesets.get(DependencyRuleSetFiles.RulesType.RULES).getRules()) {
                if (rule.matches(dependency)) {
                    return rule.apply(dependency);
                }
            }
        }

        return dependency;
    }

    /**
     * Format a dependency for display (slightly more compact than dependency.toString())
     */
    private String format(Dependency dependency) {
        StringBuilder builder = new StringBuilder();
        builder.append(dependency.getGroupId());
        builder.append(":");
        builder.append(dependency.getArtifactId());
        builder.append(":");
        builder.append(dependency.getType());
        builder.append(":");
        builder.append(dependency.getVersion());
        if (dependency.getClassifier() != null && dependency.getClassifier().trim().length() > 0) {
            builder.append(":");
            builder.append(dependency.getClassifier());
        }

        return builder.toString();
    }
}
