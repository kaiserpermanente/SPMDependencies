//
//  SubCommand.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-03.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import Foundation
import ArgumentParser

protocol ParsableSubCommand: AsyncParsableCommand {
    static var verbose: Bool { get set }
}
