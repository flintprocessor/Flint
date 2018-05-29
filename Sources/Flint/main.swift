import Foundation
import Bouncer

let program = Program(commands: [templateCloneCommand,
                                 templateCloneCommandAlias,
                                 templateAddCommand,
                                 templateAddCommandAlias,
                                 templateListCommand,
                                 templateListCommandAlias,
                                 templateRemoveCommand,
                                 templateRemoveCommandAlias])

try? program.run(withArguments: Array(CommandLine.arguments.dropFirst()))
