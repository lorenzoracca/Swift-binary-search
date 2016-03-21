# Swift/SR-368

This repo contains the work for bug [Swift/SR-368](https://bugs.swift.org/browse/SR-368).

## Contents
* **SE-0047**: Proposal
* **binarysearch.swift**: Current implementation
* **binarysearch.cpp**: Examples of the C++ implementation usage
* **Makefile**: Makefile used to build and run the C++ examples

## C++ Examples
To build and run the C++ examples, simply run the command `make` in the
directory containing the makefile. To remove the binary, run the command
`make clean`.

## TODO
Current work involves:
* Coming up with a clean implementation of `binarySearch` that takes a unary
closure and works in all cases
* Adding an `equalRange` implementation
 
