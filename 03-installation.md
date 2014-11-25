# Installing and Configuring TEAM

This chapter covers the installation process for the Takari Extensions for Apache Maven - TEAM.

Before you start installing TEAM there are a few things to establish. The
following sections outline a few assumptions about the audience for this chapter
as well as the prerequisites necessary for a successful installation.

## Assumptions

One of the assumptions of TEAM is that you are already somewhat familiar with
Maven terminology. You understand how to install Maven, and you also understand
how to run Maven from the command-line. The good news is that, if you know how
to do these two things, the installation process should be very easy for you.

If you are unfamiliar with Maven terminology, and if you have never installed
Maven before, we suggest that you refer to the existing documentation or attend
a Takari Maven training. In general, a familiarity with Maven will make the
installation and setup process of TEAM very easy to understand.

## Prerequisites

TEAM is designed and tested for

* Microsoft Windows 7 or higher
* Apple OSX 10.7 or higher and
* Modern Linux Distributions

with the **Oracle Java Development Kit JDK version 7** installed. You can verify
your JDK installation by running `java -version` which should result in an
 output similar to

```
$java -version
java version "1.7.0_65"
Java(TM) SE Runtime Environment (build 1.7.0_65-b17)
Java HotSpot(TM) 64-Bit Server VM (build 24.65-b04, mixed mode)
```

Depending on your particular system and setup procedures, you may need
administrative access to the machine you are installing TEAM on. If you following
the instructions outlined below, you will certainly need administrative access,
but if you understand what you are doing you may be able to get away with
running TEAM from a directory in your home directory. We leave this customization
to the reader.

## Downloading TEAM

You TEAM can be downloaded from the Central Repository at
`https://repo.maven.apache.org/maven/io/takari/takari-team-maven/`. This location
contains all released versions. The TEAM distribution is available as both a
GZip'd tar archive in each version specific folder following the Maven
repository format's naming convention for the archive. E.g. you can download
version 0.9.0 of TEAM from

```
https://repo1.maven.apache.org/maven2/io/takari/takari-team-maven/0.9.0/takari-team-maven-0.9.0.tar.gz
```

resulting in a downloaded archive file name of `takari-team-maven-0.9.0.tar.gz`.

## Installing TEAM

There are two ways to install TEAM on your computer. You can download a complete
distribution of TEAM which includes Apache Maven. Alternatively you can run an
installer that will turn a compatible installation of Apache Maven 3 into a
functioning installation of TEAM. The second option was created for environment
in which Maven is already installed to make it easier to migrate large groups of
developers to the supported TEAM distribution.

### Installing a TEAM Distribution

Installing the TEAM distribution is easy, and if you are familiar with
installing Maven you'll notice the similarities. Once you have downloaded the
archive extract it with a command line tool like 'tar' or one of the
many available archive management applications for your operating system.

```
tar xvzf takari-team-maven-1.0.0.tar.gz
```

Successful extraction will create a directory with the same name as the archive
file, omitting the extension.

```
takari-team-maven-1.0.0
```

As a next step you need to move this directory to a suitable location. The
only requirements is that the user that will run TEAM has read access to the
path.

We suggest to follow the operating system specific recommendations e.g. on
Linux or OSX install TEAM into `/opt` or `/usr/local` and avoid path names containing
spaces such as `Program Files`.

```
/opt/takari-team-maven-1.0.0
C:\tools\takari-team-maven-1.0.0
```

The next steps should be just as familiar from a standard Maven installation as
the simple archive extraction - create a `M2_HOME` environment variable that
points to the folder you just created and add `M2_HOME/bin` to the `PATH`.

On Linux or OSX you can configure this e.g., in your `~/.profile` file with

```
export M2_HOME=/opt/takari-team-maven-1.0.0
export PATH=M2_HOME/bin:$PATH
```

On Windows you typically configure this via the user interface as a system
environment variable. On the command line you can use the set command:

```
set M2_HOME=c:\tools\takari-team-maven-1.0.0
```

Note that the usage of the environment variable is done
via `%M2_HOME%` as compared to `$M2_HOME`, that the delimiter in the path
definition is a semicolon and the path separator is a backslash so your PATH
modification will look similar to

```
%M2_HOME%\bin;%PATH%
```

### Upgrading an Existing Apache Maven Installation

To upgrade an existing Apache Maven installation....

```
mvn team:install or whatever
```

## Verifying your TEAM Installation

Once you have installed the TEAM distribution, you should verify your setup
by running `mvn -v` or `mvn --version`, which should display the TEAM version:

```
$ mvn -v
Takari Extensions for Apache Maven (TEAM) 0.9.1-SNAPSHOT
(72d4cce; 2014-10-14T11:12:43-07:00)

Including:
 --> Apache Maven: 3.2.4-SNAPSHOT
 --> Smart Builder: 0.3.0
 --> Concurrent Safe Local Repository: 0.10.4
 --> OkHttp Aether Connector: 0.13.1
 --> Logback with Colour Support: 1.0.7
 --> Incremental Build Support: 0.9.0+

http://takari.io/team

Maven home: /opt/tools/takari-team-maven-0.9.1-SNAPSHOT
Java version: 1.7.0_65, vendor: Oracle Corporation
Java home: /Library/Java/JavaVirtualMachines/jdk1.7.0_65.jdk/Contents/Home/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "10.8.5", arch: "x86_64", family: "mac"
```

The same output will be created with the `-V` or `--show-version` parameters. It
details the version of TEAM as well as the components of it e.g. Apache Maven,
Smart Builder and others.

## Eclipse Support for TEAM

Any TEAM plugins and components needed for development with Eclipse and M2e are
setup to be automatically installed. Alternatively you can manually install the
components.

[//]: # (TBD need to add some URLs or whatever else here, maybe screenshots or whatever)

## Logging

TEAM includes support for colored logging and other features of the [LOGBack logging framework]
(http://logback.qos.ch/) . Colored output can be activated by replacing the
default `M2_HOME/conf/logback.xml` with the included `M2_HOME/conf/logback-colour.xml`
.

This example configuration simply changes the `[INFO]` label in each log line
toa blue color and the `[WARNING]` label to red. LOGBack supports a lot of
logging configurations, that you can take advantage of. Please refer to the [excellent documentation]
(http://logback.qos.ch/documentation.html) for further details. The [coloring section of the layout chapter]
(http://logback.qos.ch/manual/layouts.html#coloring) is specifically helpful for
further tweaks to the default coloring output e.g. when adapting it to your
favourite command line look and feel.

## Improved HTTP Access

TEAM includes usage of the OkHttp Aether Connector for improved performance for
repository access. No user configuration is required to take advantage of this
feature.

## Concurrent Safe Local Repository

TEAM includes support for concurrent safe access to the local Maven repository.
This allows you to e.g. share a local Maven repository among parallel running
build jobs on a CI server or multiple builds running on a developer machine
without any potential negative side effects or issues. No user configuration is
required to take advantage of this feature.

