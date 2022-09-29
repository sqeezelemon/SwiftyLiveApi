# SwiftyLiveAPI

SwiftyLiveApi is a wrapper around Infinite Flight Live API.

## Usage

The package is available for following platforms:
| Platform | Min. Version |
| -------- | ------------ |
| iOS      | 10           |
| TvOS     | 10           |
| MacOS    | 10.12        |

### Installation

This package is available with the Swift Package Manager in XCode.

To install it manually, insert this in your `Package.swift`:
```swift
.package(url: "https://github.com/sqeezelemon/SwiftyLiveApi.git", from: "3.0.0")
```

and then add it to your target, for example, like this:

```swift
.target(name: "YourTarget", dependencies: [
    .product(name: "SwiftyLiveApi", package: "SwiftyLiveApi")
],
``` 

### Getting started

[**Live API Docs**](https://infiniteflight.com/guide/developer-reference/live-api/)

All SwiftyLiveApi types have a `LA` prefix, just like the big boy libraries.
To get started, import `SwiftyConnectApi`, create an instance of `LAClient` and get straight into coding.
The methods are named in accordance to their Developer Manual names. For example, the `Get Sessions` method becomes `getSessions()`.
Some structures were changed and some variables were renamed for better uniformity and readability. In places where this might get confusing, variable aliases were added to help.

```swift
// 1) Import the package
import SwiftyLiveApi

// 2) Initialise the client
let client = LAClient("your api key")

// 3) Ready to rock!
let sessions = try client.getSessions()
```

### Running tests

In order for tests to work, please insert your Live API key into `Tests/SwiftyLiveApiTests/apikey.txt`, without any preceding whitespace. After that, the tests should run with your API key.
To ignore changes to the file to avoid accidentally pushing your API key, use this command:

```bash
git update-index --skip-worktree Tests/SwiftyLiveApiTests/apikey.txt
```

### Reporting bugs

If you encounter a bug, please file an issue with the reproduction steps and/or the json or request that caused problems.

## Contacts
[**@sqeezelemon** on IFC](https://community.infiniteflight.com/u/sqeezelemon)
