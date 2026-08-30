# jvm-list.sh: a list of available JVM and some shortcuts
# Copyright 2008, 2009 by Vincent Fourmond <fourmond@debian.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.

# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# All variables defined here can be used as arguments for the
# find_java_runtime function if you strip the __jvm_ at the beginning
# of the variable...
#
# They can also be used for the JAVA_FLAVOR environment variable, see
# java-wrappers(7).

__arch=$(dpkg --print-architecture)

# default runtime
__jvm_default="/usr/lib/jvm/default-java"

# Oracle runtimes
__jvm_oracle7="/usr/lib/jvm/java-7-oracle /usr/lib/jvm/jdk-7-oracle-* /usr/lib/jvm/jre-7-oracle-*"
__jvm_oracle8="/usr/lib/jvm/java-8-oracle /usr/lib/jvm/jdk-8-oracle-* /usr/lib/jvm/jre-8-oracle-*"
__jvm_oracle9="/usr/lib/jvm/java-9-oracle /usr/lib/jvm/jdk-9-oracle-* /usr/lib/jvm/jre-9-oracle-*"
__jvm_oracle10="/usr/lib/jvm/java-10-oracle /usr/lib/jvm/jdk-10-oracle-* /usr/lib/jvm/jre-10-oracle-*"
__jvm_oracle11="/usr/lib/jvm/java-11-oracle /usr/lib/jvm/jdk-11-oracle-* /usr/lib/jvm/jre-11-oracle-*"

# Now, free runtimes:
__jvm_openjdk6="/usr/lib/jvm/java-6-openjdk-$__arch /usr/lib/jvm/java-6-openjdk"
__jvm_openjdk7="/usr/lib/jvm/java-7-openjdk-$__arch /usr/lib/jvm/java-7-openjdk"
__jvm_openjdk8="/usr/lib/jvm/java-8-openjdk-$__arch /usr/lib/jvm/java-8-openjdk"
__jvm_openjdk9="/usr/lib/jvm/java-9-openjdk-$__arch /usr/lib/jvm/java-9-openjdk"
__jvm_openjdk10="/usr/lib/jvm/java-10-openjdk-$__arch /usr/lib/jvm/java-10-openjdk"
__jvm_openjdk11="/usr/lib/jvm/java-11-openjdk-$__arch /usr/lib/jvm/java-11-openjdk"


# And a few aliases
__jvm_openjdk="$__jvm_openjdk11 $__jvm_openjdk10 $__jvm_openjdk9 $__jvm_openjdk8 $__jvm_openjdk7 $__jvm_openjdk6"

# The java* runtimes:
__jvm_java11="$__jvm_openjdk11 $__jvm_oracle11"
__jvm_java10="$__jvm_java11 $__jvm_openjdk10 $__jvm_oracle10"
__jvm_java9="$__jvm_java10 $__jvm_openjdk9 $__jvm_oracle9"
__jvm_java8="$__jvm_java9 $__jvm_openjdk8 $__jvm_oracle8"
__jvm_java7="$__jvm_java8 $__jvm_openjdk7 $__jvm_oracle7"
# -> corresponds to Provides: java6-runtime
__jvm_java6="$__jvm_java7 $__jvm_openjdk6"
# -> corresponds to Provides: java5-runtime
__jvm_java5="$__jvm_java6"
# -> corresponds to Provides: java2-runtime
__jvm_java2="$__jvm_java5"

# current java alternatives
__jvm_alt=$(readlink /etc/alternatives/java|sed -n 's!\(.*\)/bin/[^/]*$!\1!p')

# All JVMs
__jvm_all="$__jvm_default /usr/lib/jvm/*"

# Probably here should come a few meaningful global aliases.
