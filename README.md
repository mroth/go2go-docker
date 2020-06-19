# go2go-docker

An alpine based Go image, built using the `dev.go2go` experimental branch.

See ["The Go Blog: The Next Step For Generics"][1] for additional context.

[1]: https://blog.golang.org/generics-next-step

## Installation

Either build locally, or `docker pull mrothy/go2go`.

## Usage

Use just like the official `golang` images, except you also have access to `go
tool go2go`.


    $ go tool go2go
    Usage: go2go <command> [arguments]

    The commands are:

            build      translate and build packages
            run        translate and run list of files
            test       translate and test packages
            translate  translate .go2 files into .go files

