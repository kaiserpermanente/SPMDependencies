//
//  SPMDependencies.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-03.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import ArgumentParser
import Foundation
import OSLog

@main
struct SPMDependencies: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SPMDependencies",
        abstract: "A utility for showing Swift Package Manager dependency chains.",
        version: version,
        subcommands: [
            Commands.ListDependencyTree.self,
            Commands.ListVersions.self
        ]
    )

    @Flag(name: .shortAndLong) var verbose = false

    private static let version = "SPMDependencies v\(Version.SPMDependencies)"
}

enum Commands {
}

extension Logger {
	static let listTree = Logger(subsystem: "SPMDependencies", category: "ListTree")
	static let listVersions = Logger(subsystem: "SPMDependencies", category: "ListVersions")
}
