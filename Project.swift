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

let project = Project(
    name: "ExampleProject",
    organizationName: "MyOrg",
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

            ]
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
    ]
)
