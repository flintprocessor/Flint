//
//  processDateVariables.swift
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

/// Process all kind of date variables.
///
/// - Parameter string: Raw string.
func processDateVariables(string: inout String) {
    let date = Date()
    processDateVariables(string: &string, date: date, tagOpening: "___", tagClosing: "___")
    processDateVariables(string: &string, date: date, tagOpening: "__", tagClosing: "__")
    processDateVariables(string: &string, date: date, tagOpening: "--", tagClosing: "--")
    processDateVariables(string: &string, date: date, tagOpening: "\\{\\{", tagClosing: "\\}\\}")
}

/// Process date variables with specific tag opening and closing.
///
/// - Parameters:
///   - string: Raw string.
///   - date: Target date.
///   - tagOpening: Tag opening.
///   - tagClosing: Tag closing.
func processDateVariables(string: inout String, date: Date, tagOpening: String, tagClosing: String) {
    repeat {
        // Get date tag
        let regex = "(?<=\(tagOpening)DATE:)(.*?)(?=\(tagClosing))"
        guard let dateTagRange = string.range(of: regex, options: .regularExpression) else {
            break
        }
        let dateTag = String(string[dateTagRange])

        // Get date tag components
        var localeString: String? = nil
        let separatorIndex = dateTag.index(of: "|")
        var dateFormat: String = dateTag

        if let separatorIndex = separatorIndex {
            localeString = String(dateTag.prefix(upTo: separatorIndex))
            dateFormat = String(dateTag.suffix(from: dateTag.index(separatorIndex, offsetBy: +1)))
        }

        // Get date formatter
        let dateFormatter = DateFormatter()
        if let localeString = localeString {
            dateFormatter.locale = Locale(identifier: localeString)
        }
        switch dateFormat {
        case "YEAR":
            dateFormatter.dateFormat = "yyyy"
        case "YEAR-SHORT":
            dateFormatter.dateFormat = "yy"
        case "MONTH":
            dateFormatter.dateFormat = "MM"
        case "MONTH-SHORT":
            dateFormatter.dateFormat = "M"
        case "DAY":
            dateFormatter.dateFormat = "DD"
        case "DAY-SHORT":
            dateFormatter.dateFormat = "D"
        case "SHORT":
            dateFormatter.dateStyle = .short
        case "MEDIUM":
            dateFormatter.dateStyle = .medium
        case "LONG":
            dateFormatter.dateStyle = .long
        case "FULL":
            dateFormatter.dateStyle = .full
        default:
            dateFormatter.dateFormat = dateFormat
        }

        // Replace tag
        let tag: String
        let trimmedTagOpening = tagOpening.replacingOccurrences(of: "\\", with: "")
        let trimmedTagClosing = tagClosing.replacingOccurrences(of: "\\", with: "")
        if let localeString = localeString, separatorIndex != nil {
            tag = "\(trimmedTagOpening)DATE:\(localeString)|\(dateFormat)\(trimmedTagClosing)"
        } else {
            tag = "\(trimmedTagOpening)DATE:\(dateFormat)\(trimmedTagClosing)"
        }
        string = string.replacingOccurrences(of: tag, with: dateFormatter.string(from: date))
    } while true
}
