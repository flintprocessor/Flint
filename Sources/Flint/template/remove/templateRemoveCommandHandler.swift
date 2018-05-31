//
//  templateRemoveCommandHandler.swift
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
import ANSIEscapeCode

/// Template remove command handler.
let templateRemoveCommandHandler: CommandHandler = { _, _, operandValues, optionValues in
    // Grab values.
    let templatePathOperand = operandValues[0]
    let verbose = optionValues.have(templateRemoveVerboseOption)

    // Print input summary.
    if verbose {
        printVerbose(
            """
            Input summary
            └╴Template Path: \(templatePathOperand)
            └╴Verbose      : \(verbose)
            """
        )
    }

    // Template full Path.
    let templateFullPath: Path
    do {
        templateFullPath = try getTemplateDirectoryPath()[templatePathOperand]
    } catch {
        printError(error.localizedDescription)
        return
    }

    // Validate template full Path.
    if !(templateFullPath[jsonTemplateFileName].exists ||
        templateFullPath[ymlTemplateFileName].exists ||
        templateFullPath[yamlTemplateFileName].exists) {
        printError("Invalid template path.")
        return
    }

    // Remove template.
    if verbose {
        printVerbose("Remove \(templateFullPath.path)")
    }
    do {
        try templateFullPath.remove()
        print("✓".color(.green) + " Removed")
    } catch {
        printError(error.localizedDescription)
        return
    }
}