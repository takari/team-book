# Local Repository Improvements

The local repository used by Maven, and by default stored in the users 
home directory in `m2/repository` acts as a cache for dependencies and plugins 
that have been retrieved from remote repositories as well as a storage 
location for build outputs from locally built projects. These can in turn then be used 
by other Maven projects accessing the local repository.  

## Concurrent Safe Access

The access to the local repository done by a standard Maven installation is not 
designed to have multiple instances of Maven to access it concurrently for read or write access.

The Takari Concurrent Local Repository support available from https://github.com/takari/takari-local-repository
removes this restriction and enables safe concurrent use of the local repository. Multiple builds 
can concurrently resolve and install artifacts to the shared local repository. This is especially 
useful for continuous integration systems that usually build multiple projects in parallel 
and want to share the same local repository to reduce disk consumption.

Note that this extension is only concerned with the data integrity of the local repository 
at the artifact/metadata file level. It does not provide all-or-nothing installation of 
artifacts produced by a given build.

### Installation

To use the Takari Local Repository access, you must install it in Maven's `lib/ext` folder:

```
curl -O http://repo1.maven.org/maven2/io/takari/aether/takari-local-repository/0.10.4/takari-local-repository-0.10.4.jar
cp takari-local-repository-0.10.4.jar $M2_HOME/lib/ext

curl -O http://repo1.maven.org/maven2/io/takari/takari-filemanager/0.8.2/takari-filemanager-0.8.2.jar
cp takari-filemanager-0.8.2.jar $M2_HOME/lib/ext
```

### Using

Once the extensions are installed, no further steps are required. Any acces to the local repository is automatically performed
in a process/thread safe manner.


