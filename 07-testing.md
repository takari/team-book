# Introduction

TEAM introduces additionl support for testing your application or plugin.

## Plugin Integration Testing

TEAM plugin integration testing allows you to run integration tests for your project that span a new Maven invocation to run a full Maven build of an example Maven project. This can include multiple runs with different Maven versions, log analysis and different test runs for the same projects. IDE support is available and allows you full debugging of your build.

### Configuring the POM

The POM of the project containing the integration tests needs to be set up to provision all the Maven distributions required for the test invocations in the the build output directory. This can be achieved with the Maven dependency plugin:

````
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-dependency-plugin</artifactId>
  <executions>
    <execution>
      <id>unpack</id>
      <phase>generate-test-resources</phase>
      <goals>
        <goal>unpack</goal>
      </goals>
      <configuration>
      <outputDirectory>${project.build.directory}/maven-installation</outputDirectory>
      <artifactItems>
        <artifactItem>
          <groupId>org.apache.maven</groupId>
          <artifactId>apache-maven</artifactId>
          <version>3.0.5</version>
          <classifier>bin</classifier>
          <type>tar.gz</type>
        </artifactItem>
        <artifactItem>
          <groupId>org.apache.maven</groupId>
          <artifactId>apache-maven</artifactId>
          <version>3.2.3</version>
          <classifier>bin</classifier>
          <type>tar.gz</type>
          </artifactItem>
        </artifactItems>
      </configuration>
    </execution>
  </executions>
</plugin>
````

Depending on the Maven versions you you plan to use, you can either remove or add furhter artifact items. The plugin testing itself is added as a test scoped dependency.

````
<dependency>
  <groupId>io.takari.maven.plugins</groupId>
  <artifactId>takari-plugin-testing</artifactId>
  <version>${takari.plugin.testing.version}</version>
</dependency>
````

In addition it is necessary to configure the plugin to process the test resources.

````
<plugin>
  <groupId>io.takari.maven.plugins</groupId>
  <artifactId>takari-plugin-testing-plugin</artifactId>
  <version>${takari.plugin.testing.version}</version>
  <executions>
    <execution>
      <id>testProperties</id>
      <phase>process-test-resources</phase>
      <goals>
        <goal>testProperties</goal>
      </goals>
    </execution>
  </executions>
</plugin>
````

This completes the necessary configuration in the POM.

### Adding Test Projects

The example projects used for the integration tests runs should be located in ```src/test/projects```.

### Writing a Test

see examples

### Test Execution Configuration

Either as normal junit test or if desired to run separately at IT test with failsafe plugin

### Running a Test on the Commandline

````
mvn test or integration-test -Dtest=xyz
````

### Running a Test in Eclipse

with Maven Dev
