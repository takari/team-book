# Local Repository Improvements

The local repository used by Maven is, by default, stored in the users home directory in `.m2/repository` . It acts as a
cache for dependencies and plugins that have been retrieved from remote repositories as well as a storage location for
build outputs from locally built projects. These can in turn then be used by other Maven projects accessing the local
repository.

## Concurrent Safe Access

The access to the local repository done by a standard Maven installation is not designed to have multiple instances of
Maven accessing it concurrently for read or write access. Concurrent access can end up corrupting the consistency of the 
repository due to wrong metadata file content.

The Takari Concurrent Local Repository support, available from https://github.com/takari/takari-local-repository,
removes this restriction and enables safe concurrent use of the local repository. Multiple builds can concurrently
resolve and install artifacts to the shared local repository. This is especially useful for continuous integration
systems that usually build multiple projects in parallel and want to share the same local repository to reduce disk
consumption.

Note that this extension is only concerned with the data integrity of the local repository at the artifact/metadata
file level. It does not provide all-or-nothing installation of artifacts produced by a given build.

### Installation

To use the Takari Local Repository access, you must install it in Maven's `lib/ext` folder, by downloading the jar
files from the Central Repository and moving them into place:

```
curl -O http://repo1.maven.org/maven2/io/takari/aether/takari-local-repository/0.10.4/takari-local-repository-0.10.4.jar
mv takari-local-repository-0.10.4.jar $M2_HOME/lib/ext

curl -O http://repo1.maven.org/maven2/io/takari/takari-filemanager/0.8.2/takari-filemanager-0.8.2.jar
mv takari-filemanager-0.8.2.jar $M2_HOME/lib/ext
```

### Using

Once the extensions are installed, no further steps are required. Any access to the local repository is automatically
performed in a process/thread safe manner.


# Takari Smart Builder

## Overview

The Takari Smart Builder, available at https://github.com/takari/takari-local-repository, is an alternative scheduler
for build multi-module Maven projects. It allows the user to greatly improve the performance of mulit-module builds. The
primary difference between the standard multi-threaded scheduler in Maven and the Takari Smart Builder scheduler is
illustrated below.

![Standard and Smart Builder Scheduling](figures/smart-builder-scheduler.png)


The standard multi-threaded scheduler using a rather naive and simple approach of using dependency-depth information in
the project. It builds everything at a given dependency-depth before continuing to the next level.

The Takari Smart Builder scheduler is using a more advanced approach of dependency-path information. Projects are
aggressively built along a dependency-path in topological order as upstream dependencies have been satisfied.

In addition to the more aggressive build processing the Takari Smart Builder can optionally record project build times
to determine your build's critical path. If possible, the Takari Smart Builder always attempts to schedule projects on
the critical path first. This means that the timing information is used to determine the longest chain of dependencies 
that are forming a chain being built. This chain impacts the overall duration of the build the most. Starting the build
 of the involved projects as early as possible speeds up the overall build the most.

**NOTE: Maven 3.2.1 or higher is required to use this extension.** 

## Installation

To use the Takari Smart Builder you must install it in Maven's `lib/ext` folder, by downloading them jar files from the
Central Repository and moving them into place:

```
curl -O http://repo1.maven.org/maven2/io/takari/maven/takari-smart-builder/0.3.0/takari-smart-builder-0.3.0.jar

cp takari-smart-builder-0.3.0.jar $M2_HOME/lib/ext
```

## Using Smart Builder

To take advantage of the Smart Builder you need to use multiple threads in your build execution in order for the Smart
Builder scheduling capabilities to take affect. To use the Smart Builder invoke Maven by specifying the number of
threads with or the number of threads per core:

```
mvn clean install --builder smart -T8
```

or

```
mvn clean install --builder smart -T1.0C
```

When running builds in parallel, projects download their dependencies just prior to building the project. For
multi-threaded builds, two projects that are built simultaneously and require the same dependency, will likely corrupt
the local Maven repository. In order to avoid this problem we recommend using the Takari Local Repository implementation
which provides thread/process safe access to the local Maven repository.

## Using Critical Path Scheduling

To use the critical path scheduling you simply need to create an `.mvn` directory at the root of your multi-module
project. This directory is used to persist the build timing observed in a `timing.properties` file. If there is no timing
information available the critical path is estimated as the path with the greatest number of segments. On subsequent
runs the timing information is used to calculate the critical path and an attempt is made to schedule that first. Where
possible Smart Builder tries to schedule project builds such that your build should take no longer than the critical
path.
