# Environmentalism

Simple package that loads variables from your DotEnv files. 

## Requirements

* MacOS or Linux
* Swift 4+

## Installation

You can grab this package through [Swift Package Manager](https://swift.org/package-manager):

```
import PackageDescription

let package = Package(
    name: "Example",
    products: [
      .executable(name: "Example", targets: ["Example"])
    ],
    dependencies: [
      .package(url: "https://github.com/fborges/Environmentalism", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Example",
            dependencies: ["Environmentalism"]),
    ]
)
```

## Usage

This package has basically **One** struct that brings up the stuff for you:

```swift
import Environmentalism

// Load environment variables from file at specified URL
let env = try! Environment(url: url)

// Supports subscripting
let victories = env["BRAZIL_WORLD_CHAMPION"] -> "5"

// Push all key-value pairs into actual environment variables
env.commit()
```

## Further improvements

... I'll think about this later.

## License

[MIT License](https://github.com/fborges/Environmentalism/blob/master/LICENSE)

