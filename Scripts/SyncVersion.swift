#!/usr/bin/swift

import Foundation

let pathToVersion = "Version"
let pathToVersionSwift = "Sources/Flint/version/version.swift"

let version = try! String(contentsOfFile: pathToVersion, encoding: .utf8).dropLast()
let versionSwift = try! String(contentsOfFile: pathToVersionSwift, encoding: .utf8)

try! versionSwift
    .replacingOccurrences(of: "develop", with: version)
    .write(toFile: pathToVersionSwift, atomically: true, encoding: .utf8)
