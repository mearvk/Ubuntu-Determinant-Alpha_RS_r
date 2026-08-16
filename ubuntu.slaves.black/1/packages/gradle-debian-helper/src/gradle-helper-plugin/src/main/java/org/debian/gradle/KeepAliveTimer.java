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

import java.util.Timer;
import java.util.TimerTask;

import org.gradle.BuildAdapter;
import org.gradle.api.invocation.Gradle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Build listener displaying a message every 10 minutes. This prevents the auto builders
 * from killing Gradle on slow architectures.
 */
class KeepAliveTimer extends BuildAdapter {
    
    private final Logger log = LoggerFactory.getLogger(KeepAliveTimer.class);

    private static final long PERIOD = 10 * 60 * 1000L; // 10 minutes

    @Override
    public void projectsLoaded(Gradle gradle) {
        Timer timer = new Timer("Gradle Keep-alive Timer", true);
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                log.info("\tGradle is still running, please be patient...");
            }
        }, PERIOD, PERIOD);

        log.info("\tKeep-alive timer started");
    }
}
