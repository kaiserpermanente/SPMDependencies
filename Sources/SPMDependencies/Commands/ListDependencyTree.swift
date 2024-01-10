//
//  ListDependencyTree.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-03.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import Foundation
import ArgumentParser
import OSLog

extension Commands {
    struct ListDependencyTree: ParsableSubCommand {
        static var verbose = false
        static let configuration = CommandConfiguration(
            commandName: "list-tree",
            abstract: "Print Swift Package Manager dependency tree"
        )

        @Argument var input: String

        mutating func run() throws {
            let file = Path(input)

            if file.exists {
                Logger.listTree.info("Package.swift file found for path: \(file.path)")
            } else {
                Logger.listTree.error("Package.swift file not found for path: \(file.path)")
            }
        }
    }
}
