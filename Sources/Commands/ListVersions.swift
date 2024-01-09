//
//  ListVersions.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-03.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import ArgumentParser
import Foundation
import OSLog

extension Commands {
	struct ListVersions: ParsableSubCommand {
		static var verbose = false
		static let configuration = CommandConfiguration(
			commandName: "list-versions",
			abstract: "Print all versions of swift packages"
		)

		mutating func run() throws {
		}
	}
}
