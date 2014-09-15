# Introduction

This book was created to document the plugins and features available in the
Takari Extensions for Apache Maven (TEAM). This introduction defines what the
TEAM distribution is and introduces the company behind this new
distribution.

## What is TEAM?

TEAM stands for the Takari Extensions for Apache. TEAM is a collection of
supported Maven plugins and extensions to a core Apache Maven. It is made freely
available by Takari. Takari is creating new releases every 30-60 days depending
on the current development schedule.

TEAM was created to address several shortcomings in the "stock" Maven
distribution and TEAM includes the following features beyond that of Maven:

1. Support for incremental build operations

1. An intelligent approach to the parallelization of Maven builds

1. An alternative to SNAPSHOT releases called Generations

### TEAM: Advanced Use Cases for Maven

While TEAM's features are relevant to all Maven users, these features and
plugins were designed to support development at scale - on projects with
hundreds or thousands of developers. These advanced builds are often
characterized by large networks of interdependent groups building and delivering
a steady stream of software to production dealing with challenges that arise
when an organization has a a large number of components with often conflicting
release schedules.

On such large projects the key to success is agility, the pace with which new
features can be implemented and additional releases can be delivered. These
projects can rarely stop and wait for a formal release process that takes hours
to complete. Individual developers are most productive when they can focus on
incremental builds that don't cause them to set aside hours or days for
integration.

TEAM can be used by any Maven user, but TEAM was specifically designed for the
needs of large software projects. The features added to TEAM cater to issues that
arise when hundreds or thousands of developers are collaborating on fast-moving
projects.

### What is Takari?

Takari is a company founded by Jason van Zyl focused on creating software to
manage component-based development and to support builds at scale. Takari's
developers bring multiple decades of experience building software systems to our
customers. We know about creating and documenting large open source projects
including Maven among others from years of actually running them.

### Sustainable Open Source Development

Takari is committed to practicing sustainable open source development and
building a community that understands exactly how open source developers and
community members must be active participants to ensure the ongoing health of an
open source project.

### Integrity and Authenticity

As open source developers we believe in doing the right thing, in a reliable
way and are committed to being genuine in our actions and reactions. Everyone
from our developers to our executives understands that our actions must be
consistent with our community.

### Our Customers are Our Investors

Our customers fund our day-to-day operations by paying for our training,
services and products. We answer to our customers so we can continue to focus
our energy where it matters most — on creating high-quality, useful products for
the community.

### Community Support is Key

Staying involved and continuing to support the projects that are such a large
part of where we came from is important to us. While we are focused on
delivering quality software to our supporters we are also cognizant of the
larger community.

## Evolving Challenges - Builds at Scale

The efforts of Takari related to TEAM are influenced by the following industry
trends:

### Changing Technology - Changing Conventions

What worked 10 years ago may not be appropriate for today’s builds, but the
core concepts that drove the creation of Maven are still valid today. Convention
over configuration is even more appropriate now than it was then given the
amount of variation introduced by polyglot development. With new languages, new
production architectures, and a growing array of tools, Maven needs more than
just a few new plugins to support new tools. It needs a comprehensive overhaul
to allow for continued adaptation.

Incremental and parallel build improvements allow Maven to be used for a number
of use-cases such as incremental compilation, incremental processing of
Javascript resources, and other requirements which may not have been of primary
concern in 2004.

TEAM updates the concept of SNAPSHOTS for complex projects and replaces it with
Generations. This is an approach to tracking software releases and relating
specific point-in-time releases to a commit or branch in a distributed version
control system.

Over time TEAM will release updates to the core APIs and models of Maven to
allow for easier integration with different languages, tools, and technology. It
is Takari's goal to make sure that TEAM's regular releases can fill in the gaps
between Maven's far less frequent releases so that changes in technology can be
quickly addressed by TEAM.

### Faster Lifecycles: More Frequent Releases

When Maven was created we were aiming at projects that needed to conduct a
weekly or monthly software release for a relatively well-defined project. When
Maven was still new, the industry didn't have projects beyond a certain level of
complexity because the easy, component-based approach to development in Java
hadn't yet been enabled by Maven. Projects were more limited in scope then they
are today. In addition to differences in scope, projects weren't nearly as
complex and interdependent as projects Takari supports in the field in 2014.

Today, we see large organizations with hundreds or thousands of developers.
These organizations are building very complex, interdependent systems which
depend upon Maven to facilitate both continuous integration and software
releases. Where a company may only push to production once a month in 2004 or
even less frequently, that same company expects to be able to push to production
as often as possible even multiple times a day. This is the emerging reality of
enterprise software development and Maven's legacy approach to Releases and
SNAPSHOTs does not lend itself to these, more iterative and agile workflows.

TEAM's generations features as well as incremental and parallel builds are aimed
squarely at created more timely and efficient builds for organizations that are
looking to push to production frequently.