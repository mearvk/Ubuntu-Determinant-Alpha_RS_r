/*
 * Copyright 2007-2008 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.gradle.api.publication.maven.internal.action;

import org.apache.maven.artifact.ant.RemoteRepository;
import org.gradle.api.GradleException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.eclipse.aether.RepositorySystem;
import org.eclipse.aether.RepositorySystemSession;
import org.eclipse.aether.artifact.Artifact;
import org.eclipse.aether.deployment.DeployRequest;
import org.eclipse.aether.deployment.DeploymentException;
import org.eclipse.aether.repository.Authentication;
import org.eclipse.aether.repository.Proxy;
import org.eclipse.aether.util.repository.DefaultProxySelector;

import java.io.File;
import java.util.Collection;
import java.util.List;

public class MavenDeployAction extends AbstractMavenPublishAction {
    private static final Logger LOGGER = LoggerFactory.getLogger(MavenDeployAction.class);

    private RemoteRepository remoteRepository;
    private RemoteRepository remoteSnapshotRepository;

    public MavenDeployAction(File pomFile, List<File> wagonJars) {
        super(pomFile, wagonJars);
    }

    public void setRepositories(RemoteRepository repository, RemoteRepository snapshotRepository) {
        this.remoteRepository = repository;
        this.remoteSnapshotRepository = snapshotRepository;
    }

    @Override
    protected void publishArtifacts(Collection<Artifact> artifacts, RepositorySystem repositorySystem, RepositorySystemSession session) throws DeploymentException {
        RemoteRepository gradleRepo = remoteRepository;
        if (artifacts.iterator().next().isSnapshot() && remoteSnapshotRepository != null) {
            gradleRepo = remoteSnapshotRepository;
        }
        if (gradleRepo == null) {
            throw new GradleException("Must specify a repository for deployment");
        }

        org.eclipse.aether.repository.RemoteRepository aetherRepo = createRepository(gradleRepo);

        DeployRequest request = new DeployRequest();
        request.setRepository(aetherRepo);
        for (Artifact artifact : artifacts) {
            request.addArtifact(artifact);
        }

        LOGGER.info("Deploying to {}", gradleRepo.getUrl());
        repositorySystem.deploy(session, request);
    }

    private org.eclipse.aether.repository.RemoteRepository createRepository(RemoteRepository gradleRepo) {
        org.eclipse.aether.repository.RemoteRepository.Builder repo = new org.eclipse.aether.repository.RemoteRepository.Builder("remote", gradleRepo.getLayout(), gradleRepo.getUrl());

        org.apache.maven.artifact.ant.Authentication auth = gradleRepo.getAuthentication();
        if (auth != null) {
            org.eclipse.aether.util.repository.AuthenticationBuilder authBuilder = new org.eclipse.aether.util.repository.AuthenticationBuilder();
            authBuilder.addUsername(auth.getUserName()).addPassword(auth.getPassword()).addPrivateKey(auth.getPrivateKey(), auth.getPassphrase());
            repo.setAuthentication(authBuilder.build());
        }

        org.apache.maven.artifact.ant.Proxy proxy = gradleRepo.getProxy();
        if (proxy != null) {
            DefaultProxySelector proxySelector = new DefaultProxySelector();
            org.eclipse.aether.util.repository.AuthenticationBuilder authBuilder = new org.eclipse.aether.util.repository.AuthenticationBuilder();
            authBuilder.addUsername(proxy.getUserName()).addPassword(proxy.getPassword());
            Authentication proxyAuth = authBuilder.build();
            proxySelector.add(new Proxy(proxy.getType(), proxy.getHost(), proxy.getPort(), proxyAuth), proxy.getNonProxyHosts());
            repo.setProxy(proxySelector.getProxy(repo.build()));
        }

        return repo.build();
    }
}
