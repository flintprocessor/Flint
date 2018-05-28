//
//  templateAddCommandHandler.swift
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
import Motor

/// Template add command handler.
let templateAddCommandHandler: CommandHandler = { _, _, operandValues, optionValues in
    // Grab values.
    let originalTemplatePathOperand = operandValues[0]
    let templatePathOperand = operandValues[1]
    let force = optionValues.have(templateAddForceOption)
    let verbose = optionValues.have(templateAddVerboseOption)

    // Print input summary.
    if verbose {
        printVerbose(
            """
            Input summary
            └╴Original Template Path: \(originalTemplatePathOperand)
            └╴Template Path         : \(templatePathOperand)
            └╴Force                 : \(force)
            └╴Verbose               : \(verbose)
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

    // Check existing template.
    if templateFullPath.exists {
        if force {
            do {
                try templateFullPath.remove()
            } catch {
                printError(error.localizedDescription)
                return
            }
        } else {
            printWarning("Template already exists at \(templateFullPath.path)")
            printWarning("Use --force/-f option to override")
            return
        }
    }

    // Prepare copying.
    let spinner = Spinner(pattern: Patterns.dots, delay: 2)
    let originalTemplatePath = Path(fileURLWithPath: originalTemplatePathOperand)

    // Start copying.
    if verbose {
        printVerbose("Copy \(originalTemplatePath.path) to \(templateFullPath.path)")
    }
    spinner.start(message: "Copying...")
    do {
        try originalTemplatePath.copy(to: templateFullPath)
        spinner.stop(message: "✓".color(.green) + " Done")
    } catch {
        spinner.stop()
        printError(error.localizedDescription)
        return
    }
}
