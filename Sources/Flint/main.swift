//
//  main.swift
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

let program = Program(
    commands: [
        templateCloneCommand,
        templateCloneCommandAlias,
        templateAddCommand,
        templateAddCommandAlias,
        templateListCommand,
        templateListCommandAlias,
        templateRemoveCommand,
        templateRemoveCommandAlias,
        sparkCommand,
        sparkCommandAlias,
        inputCommand,
        inputCommandAlias,
        versionCommand,
        versionCommandAlias,
        helpCommand,
        helpCommandAlias
    ]
)

do {
    try program.run(withArguments: Array(CommandLine.arguments.dropFirst()))
} catch let error as CommandParsingError {
    switch error {
    case .commandNotFound:
        print("Cannot find command")
    }
} catch let error as OperandParsingError {
    switch error {
    case .invalidNumberOfOperands(_, _, _):
        print("Invalid number of operands")
    }
} catch let error as OptionParsingError {
    switch error {
    case .missingOptionArgument(_, let option):
        print("Missing option argument for \(option.name)")
    case .missingOptions(_, let options):
        print("Missing options \(options.map { $0.name })")
    }
} catch {
    print(error.localizedDescription)
}
