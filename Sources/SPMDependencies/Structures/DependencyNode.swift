//
//  DependencyNode.swift
//  SPMDependencies
//
//  Created by Steven Woolgar on 2024-01-17.
//  Copyright © 2024 Steven Woolgar, All Rights Reserved.
//

import Foundation
import PackageModel
import Workspace

typealias TargetDependencyNode = DependencyNode<TargetDescription, TargetDescription.Dependency>
typealias ProductDependencyNode = DependencyNode<ProductDescription, PackageDependency>
typealias PackageDependencyNode = DependencyNode<Package, ProductDependencyNode>

public class DependencyNode<Value, Child> {
    var value: Value
    var children: [Child]

    init(value: Value, children: [Child] = []) {
        self.value = value
        self.children = children
    }

    func add(children: [Child]) {
        self.children.append(contentsOf: children)
    }

    func add(child: Child) {
        self.children.append(child)
    }

    var isLeaf: Bool {
        children.isEmpty
    }
}
