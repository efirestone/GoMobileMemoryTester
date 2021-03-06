# GoMobileMemoryTester

A small sample app that allocates memory within a Go runtime using [Go Mobile](https://github.com/golang/mobile) and reports the memory usage. The goal of the app is to help document the behavior of Go code embedded within an iOS app and its interaction with the main runtime. To start, this focuses on how the differing memory models of Go (garbage collection) and Objective-C/Swift (ARC) affect the efficiency of total memory usage within the shared process.

## Installation

To run the sample, both the Go language and Go Mobile must be installed.

1. Install Go from https://golang.org/dl/
2. Install Go Mobile by executing (from any working directory):

	```
	$  go get golang.org/x/mobile/cmd/gomobile
	```

3. Initialize Go Mobile by executing (from any working directory):

	```
	$  gomobile init
	```

## Usage

The app allows the user to allocate and deallocate memory using either the Objective-C or Go runtime, and reports back the current total resident memory usage reported by the process. It's also worth looking at the Xcode performance tab and Instruments, as these may report slightly different values.

## Findings/Notes

- This example currently allocates 10MB chunks of space at a time. It's possible that collections of smaller chunks may be treated differently by the GC.
- Unlike when a Go process runs directly within the OS, the memory it reserves seems to be real memory and not virtual memory, thus counting against the total memory for the process. This means that if the Go GC reserves 300MB and the process is only allowed 400MB before the OS kills it, then the rest of the process only has 100MB until the Go scavenger frees up some memory.
- The GC scavenger is reticent to return memory to the OS. It does happen sometimes, but seems unpredictable, and primarily when GBs of memory are freeable.
- Some (possibly outdated) GC info is [here](http://www.slideshare.net/jgrahamc/go-memory). Despite the slides, waiting 7+ minutes does not seem to guarantee that the scavenger will return memory to the OS.
- The Go GC does keep some overhead available internally. If you deallocate, then reallocate the same amount within the runtime it doesn't raise the total resident memory of the process. (So, it works.)
- Forcing a GC flush using `debug.FreeOSMemory` doesn't seem to do much.
- The memory reported by Xcode in the performance tab, and the memory reported by the process using `task_basic_info.resident_size` may differ. They're often close, but the memory tab will sometimes show more memory being consumed.
- On occasion the amount of memory allocated using the Go runtime will exceed the total memory reported by either `resident_size` or the Xcode performance tab. It's not clear why this happens yet.
