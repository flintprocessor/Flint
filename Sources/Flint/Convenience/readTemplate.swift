//
//  readTemplate.swift
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
import Yams

/// Read template from template file.
///
/// - Parameter path: Path for template file.
/// - Returns: Template.
/// - Throws: Read data error. Decode error.
func readTemplate(atPath path: Path) throws -> Template? {
    if path.name == jsonTemplateFileName {
        return try readJSONTemplate(atPath: path)
    } else if path.name == yamlTemplateFileName ||
        path.name == ymlTemplateFileName {
        return try readYAMLTemplate(atPath: path)
    } else {
        return nil
    }
}

/// Read template from JSON template file.
///
/// - Parameter path: Path for JSON template file.
/// - Returns: Template.
/// - Throws: Read data error. Decode error.
func readJSONTemplate(atPath path: Path) throws -> Template {
    let data = try Data(contentsOf: path.rawValue)
    return try JSONDecoder().decode(Template.self, from: data)
}

/// Read template from YAML template file.
///
/// - Parameter path: Path for YAML template file.
/// - Returns: Template.
/// - Throws: Read data error. Decode error.
func readYAMLTemplate(atPath path: Path) throws -> Template {
    let string = try String(contentsOf: path.rawValue, encoding: .utf8)
    return try YAMLDecoder().decode(Template.self, from: string)
}
