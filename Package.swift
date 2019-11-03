// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TinyPagination",
    products: [
        .library(
            name: "TinyPagination",
            targets: [ "TinyPagination", ]
        ),
    ],
    targets: [
        .target(name: "TinyPagination"),
        .testTarget(
            name: "TinyPaginationTests",
            dependencies: [ "TinyPagination", ]
        ),
    ]
)
