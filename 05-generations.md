# Generations

TEAM supports a replacement for the distinction between development or SNAPSHOT
versions and release versions of Maven projects and artifacts called
Generations. This new concept allows for every build to be treated as a
potential release and establishes a mapping of each artifact to a unique
revision in the version control system. 

It relies on a sequential increment of a version number qualifier that it
manages in coordination with the backing SCM system. Currently P4 is
supported... a centralized git support and others are planned.. 

Generations support in TEAM allows for simple setups of Maven based builds to
support continuous build as well as continuous deployment set ups.

More to come here shortly. We can take some stuff from blog posts and more. 