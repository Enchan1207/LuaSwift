// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LuaSwift",
    platforms: [
        .macOS(.v11), .iOS(.v14)
    ],
    products: [
        .library(
            name: "LuaSwift",
            targets: ["LuaSwift"]),
    ],
    targets: [
        // ライブラリ
        .target(
            name: "LuaSwift",
            dependencies: ["LuaSwiftCore", "LuaSwiftMacros"]),

        // マクロ
        .target(
            name: "LuaSwiftMacros",
            dependencies: ["LuaSwiftCore"]),
        
        // Luaコア
        .target(
            name: "LuaSwiftCore",
            exclude: [
                "lua/ljumptab.h",
                "lua/lua.c",
                "lua/onelua.c",
                "lua/ltests.c",
                "lua/ltests.h",
                "lua/testes"
            ],
            cSettings: [
                .define("LUA_COMPAT_5_3"),
                .define("LUA_USE_JUMPTABLE", to: "0"),
                .define("LUA_USE_MACOSX", to: nil, .when(platforms: [.macOS])),
                .define("LUA_USE_READLINE", to: nil, .when(platforms: [.macOS])),
                .define("LUA_USE_IOS", to: nil, .when(platforms: [.iOS]))
            ],
            linkerSettings: [
                .linkedLibrary("dl", .when(platforms: [.macOS])),
                .linkedLibrary("readline", .when(platforms: [.macOS]))
            ]),
        
        // テストターゲット
        .testTarget(
            name: "LuaSwiftTests",
            dependencies: ["LuaSwift", "LuaSwiftCore"]),
    ]
)
