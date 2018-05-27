import Foundation
import Bouncer

let program = Program(commands: [templateCloneCommand,
                                 templateCloneCommandAlias])

try? program.run(withArguments: Array(CommandLine.arguments.dropFirst()))
