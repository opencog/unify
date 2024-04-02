# Unify

opencog | singnet
------- | -------
[![CircleCI](https://circleci.com/gh/opencog/unify.svg?style=svg)](https://circleci.com/gh/opencog/unify) | [![CircleCI](https://circleci.com/gh/singnet/unify.svg?style=svg)](https://circleci.com/gh/singnet/unify)

Unify, the AtomSpace unifier, is an expression unifier for the AtomSpace.
Given two expressions containing variables, it finds all terms that
provide groundings for those variables.

It is used as a foundation for the term rewriting engine
(the Unified Rule Engine or URE for short) for OpenCog.

## Building and Installing

### Prerequisites

To build the Unifier you need to build and install the
[AtomSpace](https://wiki.opencog.org/w/AtomSpace) first, see
[Building-and-installing-the-AtomSpace](https://github.com/opencog/atomspace#building-and-installing)
for more information.

### Building Unify

Be sure to install the pre-requisites first!
Perform the following steps at the shell prompt:
```
    cd unify
    mkdir build
    cd build
    cmake ..
    make -j
```
Libraries will be built into subdirectories within build, mirroring
the structure of the source directory root.

### Unit tests

To build and run the unit tests, from the `./build` directory enter
(after building opencog as above):
```
    make -j test
```
Tests can be run in parallel as well:
```
    make -j check ARGS=-j4
```

### Install

After building, you must install Unify
```
    sudo make install
```

## Examples

Examples can be found in this repository in the
[examples directory](examples).

## More info

The primary documentation for the URE is here:

* [URE wiki](https://wiki.opencog.org/w/URE)
* [URE README.md](https://github.com/opencog/ure/README.md)
