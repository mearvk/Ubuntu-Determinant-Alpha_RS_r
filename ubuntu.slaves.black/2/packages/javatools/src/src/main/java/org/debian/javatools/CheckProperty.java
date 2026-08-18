/*
 * Copyright 2018 Emmanuel Bourg
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.debian.javatools;

/**
 * Check the value of a system property from the command line.
 *
 * Syntax:
 *
 *   java org.debian.javatools.CheckProperty <propertyName> <expectedValue>
 *
 * The program exits with the status code 0 if the actual value matches, and 1 otherwise.
 */
public class CheckProperty {

    public static void main(String[] args) throws Exception {
        String propertyName = args[0];
        String expectedValue = args[1];
        String actualValue = System.getProperty(propertyName);

        if (expectedValue.equals(actualValue)) {
            System.out.println("OK: " + propertyName + " = " + actualValue);
            System.exit(0);
        } else {
            System.out.println("FAILED: " + propertyName + " = " + actualValue);
            System.exit(1);
        }
    }
}
