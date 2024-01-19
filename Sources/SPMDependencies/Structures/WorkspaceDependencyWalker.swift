//
//  WorkspaceDependencyWalker.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-19.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import Basics
import Build
import Foundation
import OSLog
import PackageGraph
import PackageLoading
import PackageModel
import SourceControl
import Workspace

public class WorkspaceDependencyWalker {
    var observability = ObservabilitySystem({ Logger.listTree.info("\($0): \($1)") })
    var packagePath: AbsolutePath
    var parentPath: AbsolutePath
    var location: Workspace.Location
//    let repositoryManager: RepositoryManager

    init(packagePath: AbsolutePath) throws {
        self.packagePath = packagePath
        self.parentPath = packagePath.parentDirectory
        self.location = try Workspace.Location(forRootPackage: packagePath, fileSystem: localFileSystem)
    }

    func walk(packagePath: AbsolutePath) async throws /*-> PackageDependencyNode*/ {
        let workspace = try activeWorkspace()
        try createCacheFolders()
        let rootManifests = try await workspace.loadRootManifests(packages: [parentPath], observabilityScope: observability.topScope)
        print("rootManifests: \(rootManifests)")
    }

    private func createCacheFolders() throws {
        try localFileSystem.createDirectory(location.scratchDirectory.appending(component: "repositories"), recursive: true)
        try localFileSystem.createDirectory(location.repositoriesCheckoutsDirectory, recursive: true)
        try localFileSystem.createDirectory(location.artifactsDirectory, recursive: true)
    }

    private func computeResolvedFileOriginHash(root: PackageGraphRootInput) throws -> String {
        return ""
    }

    private func resolveDependencies(resolver: PubGrubDependencyResolver, constraints: [PackageContainerConstraint]) throws {
    }

    private func activeWorkspace() throws -> Workspace {
        return try Workspace(
            fileSystem: localFileSystem,
            location: location,
            authorizationProvider: authorizationProvider(),
            registryAuthorizationProvider: registryAuthorizationProvider(),
            configuration: .init(
                skipDependenciesUpdates: false,
                prefetchBasedOnResolvedFile: true,
                shouldCreateMultipleTestProducts: false,
                createREPLProduct: false,
                additionalFileRules: FileRuleDescription.swiftpmFileTypes,
                sharedDependenciesCacheEnabled: true,
                fingerprintCheckingMode: .strict,
                signingEntityCheckingMode: .warn,
                skipSignatureValidation: false,
                sourceControlToRegistryDependencyTransformation: .disabled,
                defaultRegistry: nil,
                manifestImportRestrictions: .none
            ),
            cancellator: .none,
            initializationWarningHandler: .none,
            customHostToolchain: try UserToolchain(swiftSDK: SwiftSDK.hostSwiftSDK(originalWorkingDirectory: packagePath, observabilityScope: observability.topScope)),
            customManifestLoader: manifestLoader(),
            customPackageContainerProvider: .none,
            customRepositoryProvider: .none,
            delegate: .none
        )
    }

//    func workspaceRoot() throws -> PackageGraphRootInput {
//        let packages: [AbsolutePath]
//
//        if let workspace = options.locations.multirootPackageDataFile {
//            packages = try self.workspaceLoaderProvider(localFileSystem, observabilityScope)
//                .load(workspace: workspace)
//        } else {
//            packages = [try getPackageRoot()]
//        }
//
//        return PackageGraphRootInput(packages: packages)
//    }

    public func manifestLoader() throws -> ManifestLoader {
        let cachePath = Workspace.DefaultLocations.manifestsDirectory(at: location.sharedCacheDirectory!)
        let extraManifestFlags = ["-Xfrontend", "-disable-implicit-concurrency-module-import", "-Xfrontend", "-disable-implicit-string-processing-module-import"]

        return ManifestLoader(
            toolchain: try UserToolchain(swiftSDK: SwiftSDK.hostSwiftSDK(originalWorkingDirectory: packagePath, observabilityScope: observability.topScope)),
            isManifestSandboxEnabled: true,
            cacheDir: cachePath,
            extraManifestFlags: extraManifestFlags,
            importRestrictions: .none
        )
    }

    public func authorizationProvider() throws -> AuthorizationProvider? {
        var authorization = Workspace.Configuration.Authorization.default
        authorization.netrc = .user
        authorization.keychain = .enabled
        return try authorization.makeAuthorizationProvider(
            fileSystem: localFileSystem,
            observabilityScope: observability.topScope
        )
    }

    public func registryAuthorizationProvider() throws -> AuthorizationProvider? {
        var authorization = Workspace.Configuration.Authorization.default
        authorization.netrc = .user
        authorization.keychain = .enabled

        return try authorization.makeRegistryAuthorizationProvider(
            fileSystem: localFileSystem,
            observabilityScope: observability.topScope
        )
    }
}
