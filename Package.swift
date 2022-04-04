// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Argon2ObjC",
    platforms: [
    	.macOS(.v10_14),
    	.iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Argon2ObjC", targets: ["Argon2ObjC", "Argon2ObjC-BinaryPackage"]),
//        .library(name: "Argon2ObjC-XCFramework", targets: ["Argon2ObjC-BinaryPackage"]),        
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(name: "argon2", url: "https://github.com/P-H-C/phc-winner-argon2.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
    	.target(
    		name: "Argon2ObjC",
    		dependencies: ["argon2"]
    	),
    	.binaryTarget(
			name: "Argon2ObjC-BinaryPackage",
			url: "https://github.com/ZENPIE-STUDIO/Argon2ObjC/releases/download/v1.0.0/Argon2ObjC.xcframework.zip",
			checksum: "8385bdd0150e94ac5f81a8acfde81b78030013dc71cae5686bef0774171cead8"
		),
		.testTarget(
    		name: "Argon2ObjCTests",
           	dependencies: ["Argon2ObjC"]
        ),
    ]
)
