# Incremental Build Support Library

## Introduction

To use the incremental build library the only dependency you need is the following:

```
<dependency>
  <groupId>io.takari</groupId>
  <artifactId>incrementalbuild</artifactId>
  <version>0.9.0</version>
</dependency>
```

## Single input with single output (1-1)

resources mojo

## Single input with multiple outputs (1-N)

modello

Where the library will track what's been generated from run to run to detect the delta and remove extraneous files, i.e. those that modello has not generated and therefore no longer useful.

- register all valid inputs
- make sure that it's valid
- keeps all associated inputs and their outputs
- keeps track from run to run to maintain list of relevant outputs where differences in this list are considered files that are irrelevant and are erased
- all messages associated with inputs are stored replayed if necessary
- where the file is generated you can register an error message that will fail the build

## Single output multiple inputs (N-1)

jar mojo

Case for many to many

shade -use the aggregate context
provisioning - aggregate
antlr - all or nothing and show terrence an updated version


