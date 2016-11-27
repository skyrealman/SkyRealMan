//
//  Package.swift
//  SkyRealMan's Blog
//
//  Created by sz on 2016-11-06.
//	Copyright (C) 2016
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PackageDescription

let package = Package(
	name: "SkyRealMan",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/iamjono/SwiftString.git",majorVersion: 1, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-SQLite.git", majorVersion: 0, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 0),
	]
)
