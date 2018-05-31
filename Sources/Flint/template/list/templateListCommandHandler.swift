//
//  templateListCommandHandler.swift
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
import Bouncer
import ANSIEscapeCode

/// Template list command handler.
let templateListCommandHandler: CommandHandler = { _, _, operandValues, optionValues in
    // Grab values.
    let verbose = optionValues.have(templateCloneVerboseOption)

    // Print input summary.
    if verbose {
        printVerbose(
            """
            Input summary
            └╴Verbose: \(verbose)
            """
        )
    }

    // List available templates.
    do {
        let templateDirectoryPath = try getTemplateDirectoryPath()
        if verbose {
            printVerbose("\(templateDirectoryPath.path)")
        }

        for contentPath in try templateDirectoryPath.enumerated() {
            // Get template path.
            let contentParentPath = contentPath.parent.path
            let pathToPrint: String
            if verbose {
                pathToPrint = contentPath.parent.path
            } else {
                pathToPrint = String(contentParentPath.dropFirst(templateDirectoryPath.path.count + 1))
            }

            // Read template.
            let template: Template
            do {
                if let readTemplate = try readTemplate(atPath: contentPath) {
                    template = readTemplate
                } else {
                    continue
                }
            } catch {
                print("\(pathToPrint.boldOutput) - \(error.localizedDescription.color(.red))")
                continue
            }

            // Print template info.
            let output: String
            if let description = template.description {
                output = "\(pathToPrint.boldOutput) - \(description)"
            } else {
                output = pathToPrint.boldOutput
            }
            print(output)
        }
    } catch {
        printError(error.localizedDescription)
        return
    }
}
