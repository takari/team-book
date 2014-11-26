# Test Support

TEAM introduces additional support for testing your Maven plugins.

## Plugin Unit Testing

[//]: # (TBD)

The Eclipse tooling of TEAM includes specific support for running unit tests for
Maven plugins with the help of the Maven Plugin Testing Harness. You can start
using it by adding the `test` scoped dependency:


````
<dependency>
  <groupId>org.apache.maven.plugin-testing</groupId>
  <artifactId>maven-plugin-testing-harness</artifactId>
  <scope>test</scope>
</dependency>
````

Further details can be found in
the [mini guide on the Maven website](http://maven.apache.org/plugin-testing/maven-plugin-testing-harness/getting-started/index.html).

Once everything is configured the M2e tooling will allow you to run and debug
any test within the IDE.

## Plugin Integration Testing

TEAM plugin integration testing allows you to run integration tests for your
project that span a new Maven invocation to run a full Maven build of an example
Maven project. This can include multiple runs with different Maven versions, log
analysis and different test runs for the same projects. IDE support is available
and allows you full debugging of your build.

### Configuring the POM

The POM of the project containing the integration tests needs to be set up to
provision all the Maven distributions required for the test invocations in the
the build output directory. This can be achieved with the Maven dependency
plugin:

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

Depending on the Maven versions you you plan to use, you can either remove or
add furhter artifact items. The plugin testing itself is added as a test scoped
dependency.

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

The example projects used for the integration tests runs should be located in `src/test/projects`
and can be Maven projects of any type and complexity. The version of the actual
plugin being tested is passed into the test run as a property `it-plugin.version`
This property can used in your test project to set the plugin version:


```
<groupId>com.example.maven.plugins</groupId>
<artifactId>example-maven-plugin</artifactId>
<version>${it-plugin.version}</version>
```

### Writing a Test

An actual test with a minimal test building an project in `src/test/projects/example`
could look like the following:

````
@RunWith(MavenJUnitTestRunner.class)
@MavenVersions({"3.2.3"})
public class ExampleTest {

  @Rule
  public final TestResources resources = new TestResources();

  public final MavenRuntime mavenRuntime;

  public ExampleIT(MavenRuntimeBuilder builder) throws Exception {
    this.mavenRuntime = builder.build();
  }

  @Test
  public void buildExample() throws Exception {
    File basedir = resources.getBasedir( "example" );
    MavenExecutionResult result = mavenRuntime
          .forProject(basedir)
          .execute( "clean", "install" );

    result.assertErrorFreeLog();
  }
````

The build will run a full build of the `example` project by copying it to the a
method and Maven specific folder in `target/test-projects` . The `MavenVersions`
annotation supports multiple versions to be specified and relies on the Maven
installation done by the POM configuration with the dependency plugin.

### Command Line Test Execution

The tests can be executed as normal junit tests run with the Surefire Maven
plugin. Alternatively you can use the Failsafe plugin to run them separate from
the unit tests.

To run a specific test on the command line you can use

```
mvn test -Dtest=ExampleTest
```

for a surefire test run or

```
mvn test -Dtest=ExampleTest
```

for a failsafe test run.


### Running a Test in Eclipse

When using the plugin testing on a project in Eclipse with M2e, the required
tooling including the Maven Development tools will be automatically installed.
This will enable to you to e.g., run a single test by right-clicking on the test
 method or class and selecting Run As/Debug As - Maven Junit Test.

The following figure shows a sample test with multiple invocations for different
Maven version after a successful run within Eclipse.

![Maven plugin unit testing view in Eclipse](figures/09-maven-it.png)

