//
//  Package.swift
//  ARLanguageLearning
//
//  Created by Rohan Daruwala on 11/4/17.
//  Copyright © 2017 Roholiver. All rights reserved.
//

import Foundation
import PackageDescription

let package = Package(
    name: "ARLanguageLearning",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1, 0, 0)..<Version(3, .max, .max)),
        ]
)
