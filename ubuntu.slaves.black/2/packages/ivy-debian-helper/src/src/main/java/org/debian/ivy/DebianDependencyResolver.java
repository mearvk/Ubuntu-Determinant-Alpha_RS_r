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

package org.debian.ivy;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ivy.core.cache.ArtifactOrigin;
import org.apache.ivy.core.module.descriptor.Artifact;
import org.apache.ivy.core.module.descriptor.DefaultArtifact;
import org.apache.ivy.core.module.descriptor.DefaultDependencyDescriptor;
import org.apache.ivy.core.module.descriptor.DependencyDescriptor;
import org.apache.ivy.core.module.descriptor.ModuleDescriptor;
import org.apache.ivy.core.module.id.ModuleRevisionId;
import org.apache.ivy.core.report.ArtifactDownloadReport;
import org.apache.ivy.core.report.DownloadReport;
import org.apache.ivy.core.resolve.DownloadOptions;
import org.apache.ivy.core.resolve.ResolveData;
import org.apache.ivy.core.resolve.ResolvedModuleRevision;
import org.apache.ivy.plugins.resolver.IBiblioResolver;
import org.apache.ivy.util.Message;
import org.debian.maven.cliargs.ArgumentsIterable;
import org.debian.maven.cliargs.ArgumentsMap;
import org.debian.maven.repo.Dependency;
import org.debian.maven.repo.DependencyRule;
import org.debian.maven.repo.DependencyRuleSetFiles;

/**
 * Dependency resolver for Ivy using the Debian system repository under /usr/share/maven-repo.
 *
 * @author Emmanuel Bourg
 * @version $Revision$, $Date$
 */
public class DebianDependencyResolver extends IBiblioResolver {

    /** The substitution rules for the Maven dependencies */
    private DependencyRuleSetFiles rulesets;

    /** The placeholder used for ignored dependencies */
    private static final DependencyDescriptor IGNORED_DEPENDENCY_PLACEHOLDER = new DefaultDependencyDescriptor(ModuleRevisionId.newInstance("org.debian.ivy", "ivy-debian-helper", "1.0"), false);

    public DebianDependencyResolver() {
        setRoot("file:///usr/share/maven-repo");
        setM2compatible(true);

        Message.info("[ivy-debian-helper] Loading the Maven rules...");
        ArgumentsMap args = new ArgumentsMap(new ArgumentsIterable(new String[] { "--rules=debian/maven.rules", "--ignore-rules=debian/maven.ignoreRules"}));
        rulesets = DependencyRuleSetFiles.fromCLIArguments(args, false);
        rulesets.addDefaultRules();
    }

    @Override
    public ResolvedModuleRevision getDependency(DependencyDescriptor dd, ResolveData data) throws ParseException {
        
        ModuleDescriptor md = getModuleDescription(dd);
        
        Dependency dependency = toDependency(dd);
        Dependency resolved = resolve(dependency);
        
        if (resolved == null) {
            Message.info("[ivy-debian-helper] Ignoring " + format(dependency));
            dd = IGNORED_DEPENDENCY_PLACEHOLDER;

        } else if (dependency == resolved) {
            Message.info("[ivy-debian-helper] Passing through " + format(dependency));

        } else {
            Message.info("[ivy-debian-helper] Replacing " + format(dependency) + "  ->  " + format(resolved));
            
            Map<String, String> attributes = new HashMap<String, String>();
            if (resolved.getClassifier() != null && resolved.getClassifier().length() > 0) {
                attributes.put("classifier", resolved.getClassifier());
            }
            
            ModuleRevisionId mrid = ModuleRevisionId.newInstance(resolved.getGroupId(), resolved.getArtifactId(), dd.getDependencyRevisionId().getBranch(), resolved.getVersion(), attributes);
            dd = new DefaultDependencyDescriptor(md, mrid, dd.isForce(), dd.isChanging(), dd.isTransitive());
        }

        return super.getDependency(dd, data);
    }

    /**
     * Return the ModuleDescriptor of the specified DependencyDescriptor.
     */
    private ModuleDescriptor getModuleDescription(DependencyDescriptor dd) {
        try {
            Field field = DefaultDependencyDescriptor.class.getDeclaredField("md");
            field.setAccessible(true);
            
            return (ModuleDescriptor) field.get(dd);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
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
     * Alters the download logic by ensuring the artifacts downloaded are those that were given
     * by the substitution rules.
     *
     * Ivy allows to change the name of the artifact downloaded with a dependency like this one:
     *
     * <pre>
     * &lt;dependency org="org.eclipse.jetty.orbit" name="javax.servlet" rev="3.0">
     *   &lt;artifact name="servlet" type="orbit" ext="jar"/>
     * &lt;/dependency>
     * </pre>
     *
     * In this case, if the following rule is applied:
     *
     * <pre>  s/org.eclipse.jetty.orbit/javax.servlet/ s/javax.servlet/servlet-api/ * * * *</pre>
     *
     * Ivy will attempt to download:
     *
     * <pre>  file:/usr/share/maven-repo/javax/servlet/servlet-api/3.0/servlet-3.0.jar</pre>
     *
     * instead of:
     *
     * <pre>  file:/usr/share/maven-repo/javax/servlet/servlet-api/3.0/servlet-api-3.0.jar</pre>
     *
     * Thus this implementation ensures that the artifact name specified in the dependency is ignored.
     */
    @Override
    public DownloadReport download(Artifact[] artifacts, DownloadOptions options) {
        Map<Artifact, Artifact> replacedArtifacts = new HashMap<Artifact, Artifact>();
        
        List<Artifact> resolvedArtifacts = new ArrayList<Artifact>();
        
        if (artifacts != null) {
            for (Artifact artifact : artifacts) {
                Artifact artifact2 = DefaultArtifact.cloneWithAnotherName(artifact, artifact.getModuleRevisionId().getName());
                resolvedArtifacts.add(artifact2);
                replacedArtifacts.put(artifact2, artifact);
            }
        }
        
        DownloadReport report =  super.download(resolvedArtifacts.toArray(new Artifact[0]), options);
        
        // rewrite the download report with the original artifacts
        DownloadReport report2 = new DownloadReport();
        for (ArtifactDownloadReport artifactDownloadReport : report.getArtifactsReports()) {
            Artifact artifact = replacedArtifacts.get(artifactDownloadReport.getArtifact());
            
            ArtifactDownloadReport artifactDownloadReport2 = new ArtifactDownloadReport(artifact);
            String location = artifactDownloadReport.getArtifactOrigin().getLocation();
            
            if (location != null) {
                artifactDownloadReport2.setArtifactOrigin(new ArtifactOrigin(artifact, false, location));
                artifactDownloadReport2.setLocalFile(artifactDownloadReport.getLocalFile());
                artifactDownloadReport2.setSize(artifactDownloadReport.getSize());
            }
            
            artifactDownloadReport2.setDownloadStatus(artifactDownloadReport.getDownloadStatus());
            artifactDownloadReport2.setDownloadDetails(artifactDownloadReport.getDownloadDetails());
            artifactDownloadReport2.setDownloadTimeMillis(artifactDownloadReport.getDownloadTimeMillis());
            
            report2.addArtifactReport(artifactDownloadReport2);
        }
        
        return report2;
    }

    /**
     * Converts an Ivy dependency into a dependency object as handled by maven-repo-helper.
     */
    private Dependency toDependency(DependencyDescriptor dd) {
        String groupId = dd.getDependencyId().getOrganisation();
        String artifactId = dd.getDependencyId().getName();
        String type = "jar";
        String version = dd.getDependencyRevisionId().getRevision();
        String classifier = dd.getAttribute("classifier");
        
        return new Dependency(groupId, artifactId, type, version, "compile", false, classifier, null);
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
