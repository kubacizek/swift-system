// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
/*
 This source file is part of the Swift System open source project
 Copyright (c) 2020 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception
 See https://swift.org/LICENSE.txt for license information
*/

import PackageDescription

#if os(Linux)
let libraryName = "System"
let libraryType: PackageDescription.Product.Library.LibraryType = .dynamic
#else
let libraryName = "SystemPackage"
let libraryType: PackageDescription.Product.Library.LibraryType = .static
#endif

let package = Package(
    name: "swift-system",
    products: [
        .library(
			name: libraryName, 
			type: libraryType,
			targets: ["SystemPackage"]
		)
    ],
    dependencies: [],
    targets: [
      .target(
        name: "CSystem",
        dependencies: []),
      .target(
        name: "SystemPackage",
        dependencies: ["CSystem"],
        path: "Sources/System",
        cSettings: [
          .define("_CRT_SECURE_NO_WARNINGS")
        ],
        swiftSettings: [
          .define("SYSTEM_PACKAGE"),
          .define("ENABLE_MOCKING", .when(configuration: .debug))
        ]),
      .testTarget(
        name: "SystemTests",
        dependencies: ["SystemPackage"],
        swiftSettings: [
          .define("SYSTEM_PACKAGE")
        ]),
    ]
)
