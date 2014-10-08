# Installing TEAM

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
tar xvzf takari-team-maven-0.9.0.tar.gz
```

Successful extraction will create a directory with the same name as the archive
file, omitting the extension.

```
takari-team-maven-0.9.0
```

As a next step you need to move this directory to a suitable location. The
only requirements is that the user that will run TEAM has read access to the
path.

We suggest to follow the operating system specific recommendations e.g. on
Linux or OSX install TEAM into `/opt` or `/usr/local` and avoid path names containing
spaces such as `Program Files`.

```
/opt/takari-team-maven-0.9.0
C:\tools\takari-team-maven-0.9.0
```

The next steps should be just as familiar from a standard Maven installation as
the simple archive extraction - create a `M2_HOME` environment variable that
points to the folder you just created and add `M2_HOME/bin` to the `PATH`.

On Linux or OSX you can configure this e.g., in your `~/.profile` file with

```
export M2_HOME=/opt/takari-team-maven-0.9.0
export PATH=M2_HOME/bin:$PATH
```

On Windows you typically configure this via the user interface as a system
environment variable. On the command line you can use the set command:

```
set M2_HOME=c:\tools\takari-team-maven-0.9.0
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
by running `mvn -v` or `mvn --version`, which should display the TEAM version
and some further details:

```
$ mvn -v
Takari TEAM 0.9.0 (15eb3...; 2014-08-28T10:27:57-07:00)
Maven home: /opt/tools/takari-team-maven-0.9.0
Java version: 1.7.0_65, vendor: Oracle Corporation
Java home: /Library/Java/JavaVirtualMachines/jdk1.7.0_65.jdk/Contents/Home/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "mac os x", version: "10.8.5", arch: "x86_64", family: "mac"
```

## Eclipse Support for TEAM

Any TEAM plugins and components needed for development with Eclipse and M2e are setup to be automatically installed. Alternatively you can manually install the components.

[//]: # (TBD need to add some URLs or whatever else here, maybe screenshots or whatever)

Here is an example figure ... have to figure out how that works in the scripts
yet. Notice that the file name does NOT determine the file .. only to some
degree. The chapter number is autoinserted based on the folder or so.

Insert 18333fig0301.png
Figure 3-1. one one

If you make some changes and commit again, the next commit stores a pointer to
the commit that came immediately before it. After two more commits, your history
might look something like Figure 1-2.

Insert 18333fig0302.png
Figure 3-2. one two
