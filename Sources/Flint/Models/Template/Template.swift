//
//  Template.swift
//  Flint
//
//  Copyright (c) 2018 Jason Nam (https://jasonnam.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import PathFinder

/// Template.
struct Template {

    /// Manifest.
    let manifest: Manifest
    /// Template files path.
    let templateFilesPath: Path
    /// Included files path.
    let includedFilesPath: Path
    /// Prehook scripts path.
    let prehookScriptsPath: Path
    /// Posthook scripts path.
    let posthookScriptsPath: Path
    /// Template path.
    let path: Path

    /// Initialize template.
    ///
    /// - Parameter path: Path for template directory.
    /// - Throws: Template format error.
    init(path: Path) throws {
        // Read manifest.
        if path["template.json"].exists {
            manifest = try readJSONManifest(atPath: path["template.json"])
        } else if path["template.yaml"].exists {
            manifest = try readYAMLManifest(atPath: path["template.yaml"])
        } else if path["template.yml"].exists {
            manifest = try readYAMLManifest(atPath: path["template.yml"])
        } else {
            throw TemplateFormatError.manifestFileNotExists(path)
        }
        // Set paths.
        templateFilesPath = path["template"]
        includedFilesPath = path["include"]
        prehookScriptsPath = path["prehooks"]
        posthookScriptsPath = path["posthooks"]
        self.path = path
    }
}
