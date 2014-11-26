# The Takari Lifecycle

TEAM includes an optimized replacement for the Maven default lifecycle. The
Takari Lifecycle Plugin provided you access to a number of significant
advantages:

1. One plugin with a small set of dependencies provides equivalent functionality
   to five plugins with a large set of transitive dependencies. This reduces the
   download times to retrieve the needed components as well tje storage space
   requirements in your repositories.

2. The configuration for a number of aspects for your build is centralized to
   one plugin and simplified.

3. The reduced complexity of the plugins involved in the build results in higher
   build performance on the command line and in the IDE.

4. The build is fully incremental, not only for your source code, but also for
   your resources, which in turn again speeds up development cycle and build
   times.

5. Dedicated IDE support brings the advantages of the lifecyle to your daily
   development work.

## Overview

The Takari lifecycle is implemented by a single Maven plugin that acts as build
extension and replaces the following Maven plugins:

* Maven Resources Plugin
* Maven Compiler Plugin
* Maven Jar Plugin
* Maven Install Plugin
* Maven Deploy Plugin

You can take advantage of all these replacements in your builds or pick and
choose.

## Activating the Lifecycle

In order to take advantage of the improved lifecycle, you have to activate it by
adding the takari-lifecycle-plugin as a build extension.

```
<build>
  <plugins>
    <plugin>
      <groupId>io.takari.maven.plugins</groupId>
      <artifactId>takari-lifecycle-plugin</artifactId>
      <extensions>true</extensions>
    </plugin>
  </plugins>
</build>
```

This is all the configuration necessary for projects with packaging `pom`. The
lifecycle bindings are altered so that the `takari-lifeycle-plugin` replaces the
install and deploy plugins in the respective lifecycle phases.

[//]: # (TBD is this enough docs for the pom packaging or do we need to mention anything else, related to shadow POM packaging Jason mentioned to talk to Igor about,)

Additionally projects with packaging `jar` have to be switched to use the
`takari-jar` packaging.

```
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>io.takari.lifecycle.its.basic</groupId>
  <artifactId>basic</artifactId>
  <version>1.0</version>
  <packaging>takari-jar</packaging>
```

The `takari-jar` packaging defines new lifecycle bindings for your build and
replaces the default plugins for the `jar` packaging with their Takari
counterparts. The Maven resources, compiler, jar, install and deploy plugins
are replaced. Using the `takari-jar` packaging is the easiest way to adopt all
the new features.

Alternatively you can use only a specific part, e.g. the new compiler goals only,
by using the default `jar` packaging with the `takari-lifecycle-plugin` added.
If you choose this approach, you will need to deactivate (or skip) the plugin you
want to replace to avoid interference problems between the takari lifeycle and
the default plugin.

An example for using the `jar` packaging, but replacing the default compiler
with the takari lifecycle support can be configured by adding the
`takari-lifecycl-plugin` and explicitly configuring the goals you want to
execute:

```
<build>
  <plugins>
    <plugin>
      <groupId>io.takari.maven.plugins</groupId>
      <artifactId>takari-lifecycle-plugin</artifactId>
      <executions>
        <execution>
          <id>compile</id>
          <goals>
            <goal>compile</goal>
            <goal>testCompile</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
```

and deactivating the Maven compiler plugin:

```
<build>
  ....
  <pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.1</version>
        <configuration>
          <skip>true</skip>
          <skipMain>true</skipMain>
        </configuration>
      </plugin>
    </plugins>
  </pluginManagement>
```

In a similar manner you can configure to use the other goals of the takari
lifecycle plugin, replacing specific parts of your default build.

## Observing the Takari Lifecycle on the Log

Once you have activated the Takari lifecycle, the build log will show all the
invocations of the specific goals. For a project with packaging `pom` this
will mainly affect the install and deploy invocations

```
[INFO] --- takari-lifecycle-plugin:1.7.4:install (default-install) @ pom-only ---
[INFO] Performing incremental build
[INFO] Installing .../pom.xml to /~/.m2/repository/.../SNAPSHOT/pom-only-1.0.0-SNAPSHOT.pom
[INFO]
[INFO] --- takari-lifecycle-plugin:1.7.4:deploy (default-deploy) @ pom-only ---
[INFO] Performing incremental build
...
Uploaded: http://.../1.0.0-SNAPSHOT/pom-only-1.0.0-20140731.183927-2.pom (2 KB at 8 KB/sec)
```

A project with packaging `takari-jar` will log the lifecycle plugin invocations
for the resources, compiliation and packaging related goals as well.

Upon first invocation each goal will be performed as usual, executing all steps
e.g., compiling all files or copying and filtering all resources.

```
[INFO] --- takari-lifecycle-plugin:1.7.4:process-resources (default-process-resources) @ simple-jar ---
[INFO] Previous incremental build state does not exist, performing full build
```

Subsequent builds, however will be able to access the information about prior
builds and execute incrementally.

```
$ mvn compile
[INFO] --- takari-lifecycle-plugin:1.7.4:process-resources (default-process-resources) @ simple-jar ---
[INFO] Performing incremental build
[INFO]
[INFO] --- takari-lifecycle-plugin:1.7.4:compile (default-compile) @ simple-jar ---
[INFO] Performing incremental build
[INFO] Skipped compilation, all 1 sources are up to date
```

Note that a `clean` invocation removes the state information and re-establishes
a clean slate.

## Configuring Resource Filtering and Processing

The Takari lifecycle supports the resource configuration just like the Maven
resources plugin e.g.,

```
<build>
  <resources>
    <resource>
      <directory>src/main/resources</directory>
      <filtering>true</filtering>
    </resource>
  </resources>
```

In contrast to the Maven resources plugin it however supports incremental
resource processing in terms of copying and filtering. It detects any property
changes as well as any resource changes and incrementally reprocesses the
affected files only as shown in the log

```
[INFO] --- takari-lifecycle-plugin:1.7.4:process-resources (default-process-resources) @ simple-jar ---
[INFO] Performing incremental build
```

Property changes are sources from the pom file as well as the user settings
file.

## Compiler Configuration

The Takari lifecycle compiler integration replaces the Maven compiler plugin to
compile main and test source code. It will automatically be used if you use
project packaging of `takari-jar`.

The compiler integration supports a number of configuration parameters. The
source and target parameters allow you to set the respective parameters for the
compiler.

For example, the following configuration can be used to compile Java 1.8 source
code to Java 1.8 compatible class files

```
<plugins>
  <plugin>
    <groupId>io.takari.maven.plugins</groupId>
    <artifactId>takari-lifecycle-plugin</artifactId>
    <configuration>
      <source>1.8</source>
      <target>1.8</target>
    <configuration>
```

Alternatively the property `maven.compiler.source`. Following is a list of all
compiler related configuration options

`compilerId (maven.compiler.compilerId)`
: The default value of 'javac' will invoke the Java compiler of the installed
JDK. 'forked-javac' will fork a new process or 'jdt' will use the Eclipse
JDT compiler.

`debug (maven.compiler.debug)`
: Configures the amount of debug information in the output class files. The
default is 'all' or 'true' and includes all available debug information. The
opposite is 'none' or 'false', excluding everything. Fine grained control is
possible by using a comma separated list of parameters including 'source'
(source file debugging information), 'lines' (line number debugging information)
and 'vars' (local variable debugging information).

`encoding (encoding)`
: The -encoding argument for the Java compiler.

`meminitial (maven.compiler.meminitial)`
: The initial size, in megabytes, of the memory allocation pool e.g., '64'.

`maxmem (maven.compiler.maxmem)`
: The maximum size, in megabytes, of the memory allocation pool, e.g, '128'.

`source (maven.compiler.source)`
: The Java source level argument passed to the compiler.

`target (maven.compiler.source)`
: The Java target level argument passed to the compiler.

`verbose (maven.compiler.verbose)`
: Controls the verbosity of the compiler output, defaulting to 'false'. 'true'
activates verbose output.

`showWarnings (maven.compiler.showWarnings)`
: toggles the display of warning messages from the compiler

The `compile` goal supports specifying `includes` and `excludes` and the
`testCompile` supports the equivalent `testIncludes` and `testExcludes`.

## Packaging jars Archives

Creating source and test

Part of the jar mojo configuration

```
<plugin>
  <groupId>io.takari.maven.plugins</groupId>
  <artifactId>takari-lifecycle-plugin</artifactId>
  <extensions>true</extensions>
  <configuration>
    <sourceJar>true</sourceJar>
    <testJar>true</testJar>
  </configuration>
```

* mainJar
* sourceJar
* testJar
* archive (and all the nested stuff)


## Installing and Deploying Artifacts

The takari lifecycle plugin transparently replaces the install and the deploy
plugins as you can see from this sample output of running deploy on a `pom`
packing project.

```
[INFO] --- takari-lifecycle-plugin:x.y.z:install (default-install) @ pom-only ---
[INFO] Installing .../pom.xml to ~/.m2/repository/.../pom-only-1.0.pom
[INFO]
[INFO] --- takari-lifecycle-plugin:1.8.0-SNAPSHOT:deploy (default-deploy) @ pom-only ---
Uploading: http://.../pom-only-1.0.pom
Uploaded: http://.../pom-only-1.0.pom (2 KB at 4.5 KB/sec)
Downloading: http://.../maven-metadata.xml
Uploading: http://.../maven-metadata.xml
Uploaded: http://.../maven-metadata.xml (311 B at 1.6 KB/sec)
```

On a jar packaging project the pom and jar files are installed and deployed as usual:

```
[INFO] --- takari-lifecycle-plugin:x.y.z:install (default-install) @ simple-jar ---
[INFO] Installing .../simple-jar-1.0-SNAPSHOT.jar to ~/.m2/repository/.../simple-jar-1.0-SNAPSHOT.jar
[INFO] Installing .../pom.xml to ~/.m2/repository/.../simple-jar-1.0-SNAPSHOT.pom
[INFO]
[INFO] --- takari-lifecycle-plugin:x.y.z:deploy (default-deploy) @ simple-jar ---
Downloading: http://.../maven-metadata.xml
Uploading: http://.../simple-jar-1.0-20140620.221731-1.jar
Uploaded: http://.../simple-jar-1.0-20140620.221731-1.jar (2 KB at 9.2 KB/sec)
Uploading: http://.../simple-jar-1.0-20140620.221731-1.pom
Uploaded: http://.../simple-jar-1.0-20140620.221731-1.pom (2 KB at 13.4 KB/sec)
Downloading: http://.../maven-metadata.xml
Uploading: http://.../maven-metadata.xml
Uploaded: http://.../maven-metadata.xml (781 B at 11.7 KB/sec)
Uploading: http://.../maven-metadata.xml
Uploaded: http://.../maven-metadata.xml (295 B at 4.8 KB/sec)
```

## Installing Eclipse m2e Integration

The incremental build behavior of the takari lifecycle is supported by an
extension to the Maven support for Eclipse, m2e. This extensions will
automatically be installedwhen you import a Maven project that have
thetakari-lifecycle-plugin configured.

Alternatively you can install it manually by choosing Help - Install New
Software and adding another software site using the following URL

```
http://repository.takari.io:8081/nexus/content/sites/m2e.extras/takari-team/0.1.0/N/LATEST/
```

Once the available components are loaded, you will be able to select
the Takari Build Lifecycle and proceed with the install through the dialogs.
After a restart of Eclipse the incremental build support will be available.
