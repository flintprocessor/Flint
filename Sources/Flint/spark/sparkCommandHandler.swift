//
//  sparkCommandHandler.swift
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
import Bouncer
import Work
import Yams

/// Spark command handler.
let sparkCommandHandler: CommandHandler = { _, _, operandValues, optionValues in
    // Grab values.
    let templateNameOperand = operandValues[optional: 0]
    let templatePathOptionValue = optionValues.findOptionalArgument(for: sparkTemplatePathOption)
    let outputPathOptionValue = optionValues.findOptionalArgument(for: sparkOutputPathOption)
    let inputFilePathOptionValue = optionValues.findOptionalArgument(for: sparkInputFilePathOption)
    let force = optionValues.have(sparkForceOption)
    let verbose = optionValues.have(sparkVerboseOption)

    // Print input summary.
    if verbose {
        printVerbose(
            """
            Input Summary
            └╴Template Name: \(templateNameOperand ?? "nil")
            └╴Template Path: \(templatePathOptionValue ?? "nil")
            └╴Output Path  : \(outputPathOptionValue ?? "nil")
            └╴Input Path   : \(inputFilePathOptionValue ?? "nil")
            └╴Force        : \(force)
            └╴Verbose      : \(verbose)
            """
        )
    }

    // Prepare template.
    let template: Template
    do {
        let templatePath: Path
        if let templateName = templateNameOperand {
            templatePath = try getTemplateHomePath()[templateName]
            if let templatePathOptionValue = templatePathOptionValue {
                printWarning("Ignore \(templatePathOptionValue)")
            }
        } else if let templatePathOptionValue = templatePathOptionValue {
            templatePath = Path(fileURLWithPath: templatePathOptionValue)
        } else {
            printError("Template not specified.")
            return
        }
        template = try Template(path: templatePath)
    } catch {
        printError(error.localizedDescription)
        return
    }

    // Output path.
    let outputPath: Path
    if let outputPathOptionValue = outputPathOptionValue {
        outputPath = Path(fileURLWithPath: outputPathOptionValue)
    } else {
        outputPath = Path(fileURLWithPath: FileManager.default.currentDirectoryPath)
    }

    // Check if output path is valid.
    if outputPath.exists {
        if force {
            do {
                try outputPath.remove()
            } catch {
                printError(error.localizedDescription)
                return
            }
        } else {
            printWarning("\(outputPath.path) is not empty")
            return
        }
    }

    // Get inputs.
    var inputs: [String: String] = [:]
    if let inputFilePathOptionValue = inputFilePathOptionValue {
        let inputPath = Path(fileURLWithPath: inputFilePathOptionValue)
        if inputPath.rawValue.pathExtension == "json" {
            do {
                let data = try Data(contentsOf: inputPath.rawValue)
                inputs = try JSONDecoder().decode([String: String].self, from: data)
            } catch {
                printError(error.localizedDescription)
                return
            }
        } else if inputPath.rawValue.pathExtension == "yaml" ||
            inputPath.rawValue.pathExtension == "yml" {
            do {
                let string = try String(contentsOf: inputPath.rawValue)
                inputs = try YAMLDecoder().decode([String: String].self, from: string)
            } catch {
                printError(error.localizedDescription)
                return
            }
        }
    } else {
        for variable in template.manifest.variables ?? [] {
            var output = variable.name.boldOutput
            if let defaultValue = variable.defaultValue {
                output += " (\(defaultValue))"
            }
            print("\(output): ", terminator: "")
            if let input = readLine(), input.count > 0 {
                inputs[variable.name] = input
            } else {
                inputs[variable.name] = variable.defaultValue
            }
        }
    }

    // Process template.
    do {
        // Copy template directory.
        if verbose {
            printVerbose("Copy \(template.path.path) into \(outputPath.path)")
        }
        try template.templateFilesPath.copy(to: outputPath)

        // Prehook.
        if verbose {
            printVerbose("Execute prehooks")
        }
        for prehook in template.manifest.prehooks ?? [] {
            let scriptPath = template.prehookScriptsPath[prehook]
            if scriptPath.exists {
                let work = Work(command: "sh \(scriptPath.path)",
                    standardOutputHandler: { standardOutput in
                        print(standardOutput)
                    }, standardErrorHandler: { standardError in
                        print(standardError)
                    }
                )
                var environment = ProcessInfo.processInfo.environment
                environment["FLINT_OUTPUT_PATH"] = outputPath.path
                for (key, input) in inputs {
                    environment["FLINT_\(key)"] = input
                }
                work.task.environment = environment
                work.start()
            }
        }

        // Process variables.
        if verbose {
            printVerbose("Process variables \(outputPath.path)")
        }

        var directoryPaths: [Path] = []

        for content in try outputPath.enumerated() {
            if content.isDirectory {
                directoryPaths.append(content)
            } else {
                let processedName = process(content.rawValue.lastPathComponent,
                                            variables: template.manifest.variables ?? [],
                                            inputs: inputs)
                var encoding = String.Encoding.utf8
                if let dataString = try? String(contentsOfFile: content.path, usedEncoding: &encoding) {
                    let processedString = process(dataString,
                                                  variables: template.manifest.variables ?? [],
                                                  inputs: inputs)
                    try? content.remove()
                    try? processedString.write(to: content.parent[processedName].rawValue,
                                          atomically: true,
                                          encoding: encoding)
                } else {
                    try? content.move(to: content.parent[processedName])
                }
            }
        }

        for directoryPath in directoryPaths {
            let processedName = process(directoryPath.rawValue.lastPathComponent,
                                        variables: template.manifest.variables ?? [],
                                        inputs: inputs)
            try? directoryPath.move(to: directoryPath.parent[processedName])
        }

        // Posthook.
        if verbose {
            printVerbose("Execute posthooks")
        }
        for posthook in template.manifest.posthooks ?? [] {
            let scriptPath = template.posthookScriptsPath[posthook]
            if scriptPath.exists {
                let work = Work(command: "sh \(scriptPath.path)",
                    standardOutputHandler: { standardOutput in
                        print(standardOutput)
                    }, standardErrorHandler: { standardError in
                        print(standardError)
                    }
                )
                var environment = ProcessInfo.processInfo.environment
                environment["FLINT_OUTPUT_PATH"] = outputPath.path
                for (key, input) in inputs {
                    environment["FLINT_\(key)"] = input
                }
                work.task.environment = environment
                work.start()
            }
        }

        print("✓".color(.green) + " Done")
    } catch {
        printError(error.localizedDescription)
        return
    }
}
