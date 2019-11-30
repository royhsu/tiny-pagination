// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TinyPagination",
    products: [
        .library(name: "TinyPagination", targets: [ "TinyPagination", ]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/broadwaylamb/OpenCombine.git",
            .exact("0.6.0")
        ),
    ],
    targets: [
        .target(name: "TinyPagination", dependencies: [ "OpenCombine", ]),
        .testTarget(
            name: "TinyPaginationTests",
            dependencies: [ "TinyPagination", ]
        ),
    ]
)
