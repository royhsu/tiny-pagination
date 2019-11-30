// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TinyPagination",
    products: [
        .library(name: "TinyPagination", targets: [ "TinyPagination", ]),
    ],
    dependencies: [
        .package(path: "../OpenCombine"),
    ],
    targets: [
        .target(name: "TinyPagination", dependencies: [ "OpenCombine", ]),
        .testTarget(
            name: "TinyPaginationTests",
            dependencies: [ "TinyPagination", ]
        ),
    ]
)
