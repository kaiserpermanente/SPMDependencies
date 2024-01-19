//
//  ListDependencyTree.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-03.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import ArgumentParser
import Basics
import Foundation
import OSLog

extension Commands {
    struct ListDependencyTree: AsyncParsableSubCommand {
        static var verbose = false
        static let configuration = CommandConfiguration(
            commandName: "list-tree",
            abstract: "Print Swift Package Manager dependency tree"
        )

        @Argument var input: String

        mutating func run() async throws {
            let file = Path(input)

            if file.exists && file.lastComponent == "Package.swift" {
                Logger.listTree.info("Package.swift file found for path: \(file.path)")

                let packagePath = try AbsolutePath(validating: file.normalize().path)

                let dependencyWalker = try WorkspaceDependencyWalker(packagePath: packagePath)
                /*let packageDependencyNode = */ try await dependencyWalker.walk(packagePath: packagePath)
            } else {
                Logger.listTree.error("Package.swift file not found for path: \(file.path)")
            }
        }
    }
}
