import ProjectDescription

let dependencies = Dependencies(
  /*carthage: [
        .github(path: "Alamofire/Alamofire", requirement: .exact("5.0.4")),
     ],*/
    swiftPackageManager: SwiftPackageManagerDependencies([
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .exact("5.6.1")),
    ]),
    platforms: [.iOS]
)
