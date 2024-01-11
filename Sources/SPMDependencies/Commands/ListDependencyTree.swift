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

import Build
import PackageGraph
import PackageModel
import SourceControl
import Workspace

extension Commands {
    struct ListDependencyTree: ParsableSubCommand {
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

                // This computes the path of this package root based on the file location
                let packagePath = try AbsolutePath(validating: file.normalize().path)
                let packageFolderPath = packagePath.parentDirectory
                Logger.listTree.info("packagePath: \(packagePath)")
                Logger.listTree.info("packageFolderPath: \(packageFolderPath)")

                let libraryFolder = URL(string: "/Users/m401329/Desktop/spm/") //FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
                var libraryFolderPath: String
                if let path = libraryFolder?.path {
                    libraryFolderPath = path
                } else {
                    libraryFolderPath = file.path
                }

                let idiomaticSwiftPMDirectory = try AbsolutePath(validating: libraryFolderPath).appending("org.swift.swiftpm")

                // There are several levels of information available.
                // Each takes longer to load than the level above it, but provides more detail.

                //                Task {
                let observability = ObservabilitySystem({ print("\($0): \($1)") })

                var location: Workspace.Location
                //                    do {
                let spmConfigurationFolder = idiomaticSwiftPMDirectory.appending("configuration") // try localFileSystem.swiftPMConfigurationDirectory
                let spmSecurityFolder = idiomaticSwiftPMDirectory.appending("security") //try localFileSystem.swiftPMSecurityDirectory
                let spmCacheFolder = idiomaticSwiftPMDirectory.appending("cache") // try localFileSystem.swiftPMCacheDirectory
                location = Workspace.Location(
                    scratchDirectory: Workspace.DefaultLocations.scratchDirectory(forRootPackage: packageFolderPath),
                    editsDirectory: Workspace.DefaultLocations.editsDirectory(forRootPackage: packageFolderPath),
                    resolvedVersionsFile: Workspace.DefaultLocations.resolvedVersionsFile(forRootPackage: packageFolderPath),
                    localConfigurationDirectory: Workspace.DefaultLocations.configurationDirectory(forRootPackage: packageFolderPath),
                    sharedConfigurationDirectory: spmConfigurationFolder,
                    sharedSecurityDirectory: spmSecurityFolder,
                    sharedCacheDirectory: spmCacheFolder)
                //                    } catch {
                //                        Logger.listTree.error("Failed to create the location")
                //                        throw error
                //                    }

                print("before creating workspace")
                let workspace = try Workspace(
                    fileSystem: localFileSystem,
                    location: location,
                    authorizationProvider: .none,
                    registryAuthorizationProvider: .none,
                    configuration: .none,
                    cancellator: .none,
                    initializationWarningHandler: .none,
                    customManifestLoader: .none,
                    customPackageContainerProvider: .none,
                    customRepositoryProvider: .none,
                    delegate: .none
                )
                print("after creating workspace")

                let manifest = try await workspace.loadRootManifest(at: packagePath, observabilityScope: observability.topScope)
                print("after creating manifest")
                let package = try await workspace.loadRootPackage(at: packagePath, observabilityScope: observability.topScope)
                print("after creating package")
                let graph = try workspace.loadPackageGraph(rootPath: packagePath, observabilityScope: observability.topScope)
                print("after creating graph")

                // Manifest
                let products = manifest.products.map({ $0.name }).joined(separator: ", ")
                print("Products:", products)

                let targets = manifest.targets.map({ $0.name }).joined(separator: ", ")
                print("Targets:", targets)

                // Package
                let executables = package.targets.filter({ $0.type == .executable }).map({ $0.name })
                print("Executable targets:", executables)

                // PackageGraph
                let numberOfFiles = graph.reachableTargets.reduce(0, { $0 + $1.sources.paths.count })
                print("Total number of source files (including dependencies):", numberOfFiles)
            } else {
                Logger.listTree.error("Package.swift file not found for path: \(file.path)")
            }
        }
    }
}
