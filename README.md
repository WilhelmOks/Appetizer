<p align="center">
    <img src="Images/logo.png" width="500" alt="Appetizer"/>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5-orange.svg"/>
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <img src="https://img.shields.io/badge/platforms-mac-brightgreen.svg?style=flat" alt="Mac" />
</p>

Appetizer is a macOS command line tool that takes an image (in PNG or JPG format) and makes suitable iOS and Android images and app icons.

## Usage

(TODO)

## Installation

### Binary release

Download an appetizer binary from the release section and copy it into the folder `/usr/local/bin` so that it can be launched from anywhere in the command line.

### Compile the source

You can compile the source using the command line:

`$ swift build -c release`

Then copy the `appetizer` binary from the folder `.build/release` to `/usr/local/bin` so that it can be launched from anywhere in the command line.

## TODO

* Make a macOS app, which has the same functions but with a GUI instead of a command line tool. Users should then be able to use either the command line or the GUI tool.
