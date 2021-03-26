// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DBC",
	platforms: [
		.iOS(.v12),
		.tvOS(.v12),
		.macOS(.v10_13),
	],
    products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "DBC",
			targets: ["DBC"]),
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "DBC-objc",
			targets: ["DBC-objc"]),
		.library(
			name: "DBC-bridged",
			targets: ["DBC-bridged"]),
		.library(
			name: "DBC-testing",
			targets: ["DBC-testing"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "DBC",
			dependencies: [],
			path: "DBC-swift"),
		.target(
			name: "DBC-objc",
			dependencies: [],
			path: "DBC-objc",
			publicHeadersPath: ""),
		.target(
			name: "DBC-bridged",
			dependencies: ["DBC", "DBC-objc"],
			path: "DBC-bridged"),
		.target(
			name: "DBC-testing",
			dependencies: ["DBC"],
			path: "DBC-testing"),
		.testTarget(
			name: "DBCSObjcTests",
			dependencies: ["DBC", "DBC-objc", "DBC-bridged", "DBC-testing"],
			path: "Example/Tests/objc",
			cSettings: [.define("PACKAGE_MANAGER")]),
		.testTarget(
			name: "DBCSwiftTests",
			dependencies: ["DBC", "DBC-objc", "DBC-bridged", "DBC-testing"],
			path: "Example/Tests/swift"),
    ]
)
