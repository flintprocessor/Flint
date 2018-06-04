//
//  helpCommandHandler.swift
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

/// Help command handler.
let helpCommandHandler: CommandHandler = { _, _, _, _ in
    print(
        """
        ┌─────────────────┬───────┬─────────────────────────────────────────────────┐
        │ Command         │ Alias │ Description                                     │
        ├─────────────────┼───────┼─────────────────────────────────────────────────┤
        │ template add    │  t a  │ Copy template to template home path             │
        │ template clone  │  t c  │ Clone template repository to template home path │
        │ template list   │  t l  │ List available templates under template home    │
        │ template remove │  t r  │ Remove templates under template home            │
        ├─────────────────┼───────┼─────────────────────────────────────────────────┤
        │ spark           │   s   │ Generate project from template                  │
        ├─────────────────┼───────┼─────────────────────────────────────────────────┤
        │ input           │   i   │ Generate variable input file from template      │
        ├─────────────────┼───────┼─────────────────────────────────────────────────┤
        │ version         │   v   │ Print binary version                            │
        ├─────────────────┼───────┴─────────────────────────────────────────────────┤
        │ More info on    │ https://github.com/flintbox/Flint                       │
        └─────────────────┴─────────────────────────────────────────────────────────┘
        """
    )
}
