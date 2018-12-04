// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "RxSwiftExt",

    products: [
        .library(name: "RxSwiftExt", targets: ["RxSwiftExt"]),
    ],

    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.0.0")),
    ],

    targets: [
        .target(name: "RxSwiftExt", dependencies: ["RxSwift", "RxCocoa"], path: "Source"),
        .testTarget(name: "RxSwiftTests", dependencies: ["RxSwiftExt", "RxTest"], path: "Tests"),
    ]
)
