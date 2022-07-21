//
//  Project.swift
//  Config
//
//  Created by Pierre Capo on 20/07/2022.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    organizationName: "MyOrg",
    options: Project
        .Options
        .options(),
    targets: [Target(
        name: "MyDesignSystem",
        platform: .iOS,
        product: .framework,
        bundleId: "com.mydesignsystem",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        sources: .paths(["Sources/**"]),
        // unlock this line once you want to add custom resources like colors, images, etc.
        // Don't forget to create the Resources folder to make it work!
        //   resources: ["Resources/**"],
        dependencies: []
    )]
)
