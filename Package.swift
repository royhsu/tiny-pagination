// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TinyPagination",
    products: [
        .library(name: "TinyPagination", targets: [ "TinyPagination", ]),
    ],
    dependencies: [ .package(path: "../tiny-combine"), ],
    targets: [
        .target(name: "TinyPagination", dependencies: [ "TinyCombine", ]),
        .testTarget(
            name: "TinyPaginationTests",
            dependencies: [ "TinyPagination", ]
        ),
    ]
)
