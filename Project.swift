import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains MyExampleApp App target and MyExampleApp unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

let debugConfiguration: Configuration = .debug(
    name: "Debug",
        // Add your xcconfig here per environment which will for instance contain your different bundleIds, etc
    xcconfig: .relativeToRoot("Targets/MyExampleApp/Configurations/Dev/MyExampleApp.xcconfig")
)
let stagingConfiguration: Configuration = .release(
    name: "Staging",
    xcconfig: .relativeToRoot("Targets/MyExampleApp/Configurations/Staging/MyExampleApp.xcconfig")
)

let releaseConfiguration: Configuration = .release(
    name: "Release",
    xcconfig: .relativeToRoot("Targets/MyExampleApp/Configurations/Release/MyExampleApp.xcconfig")
)

// MARK: Create schemes
let debugScheme = Scheme(
    name: "MyExampleApp-Debug",
    shared: true,
    buildAction: .buildAction(targets: [TargetReference(stringLiteral: "MyExampleApp")]),
    testAction: .testPlans([], configuration: .configuration("Debug")),
    runAction: .runAction(configuration: .configuration("Debug")),
    archiveAction: .archiveAction(configuration: .configuration("Debug")),
    profileAction: .profileAction(configuration: .configuration("Debug")),
    analyzeAction: .analyzeAction(configuration: .configuration("Debug"))
)

let stagingScheme = Scheme(
    name: "MyExampleApp-Staging",
    shared: true,
    buildAction: BuildAction(targets: [TargetReference(stringLiteral: "MyExampleApp")]),
    testAction: .testPlans([], configuration: .configuration("Release")),
    runAction: .runAction(configuration: .configuration("Release")),
    archiveAction: .archiveAction(configuration: .configuration("Staging")),
    profileAction: .profileAction(configuration: .configuration("Staging")),
    analyzeAction: .analyzeAction(configuration: .configuration("Staging"))
)

let prodScheme = Scheme(
    name: "MyExampleApp-Release",
    shared: true,
    buildAction: BuildAction(targets: [TargetReference(stringLiteral: "MyExampleApp")]),
    testAction: .testPlans([], configuration: .configuration("Release")),
    runAction: .runAction(configuration: .configuration("Release")),
    archiveAction: .archiveAction(configuration: .configuration("Release")),
    profileAction: .profileAction(configuration: .configuration("Release")),
    analyzeAction: .analyzeAction(configuration: .configuration("Release"))
)

let settings: Settings =
    .settings(base: [:],
              configurations:
              [
                  debugConfiguration,
                  stagingConfiguration,
                  releaseConfiguration,
              ])

let project = Project(
    name: "ExampleProject",
    organizationName: "MyOrg",
    settings: settings,
    targets: [
        Target(
            name: "MyExampleApp",
            platform: .iOS,
            product: .app,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: InfoPlist.dictionary([
                "CFBundleName": "$(APP_NAME)",
                "CFBundleVersion": "1",
                "CFBundleShortVersionString": "0.0.1",
                "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                "CFBundleExecutable": "$(EXECUTABLE_NAME)",
                "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
            ]),
            sources: ["Targets/MyExampleApp/Sources/**"],
            resources: ["Targets/MyExampleApp/Resources/**"],
            dependencies: [
                .project(
                    target: "MyDesignSystem",
                    path: .relativeToManifest("Projects/MyDesignSystem")
                ),
                .external(name: "Alamofire"),

            ],
            settings: .settings(base: [:], configurations: [
                debugConfiguration,
                stagingConfiguration,
                releaseConfiguration,
            // if you use fastlane, it is recommanded to add this extra line about the CODE_SIGN_IDENTITY
            ], defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"]))
        ),
        Target(
            name: "MyExampleAppUnitTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.myexampleapp.unittests",
            infoPlist: .default,
                    // To uncomment later on
            sources: ["Targets/MyExampleApp/Tests/**"],
            dependencies: [.target(name: "MyExampleApp")]
        ),
    ],
    schemes: [
        debugScheme,
        stagingScheme,
        prodScheme,
    ]
)
