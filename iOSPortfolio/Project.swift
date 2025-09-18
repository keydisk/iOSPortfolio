import ProjectDescription

public enum CommonPackages {
    public static let all: [Package] = [
        .package(url: "https://github.com/apple/swift-async-algorithms", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMinor(from: "5.10.2")),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMinor(from: "5.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMinor(from: "6.8.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/realm/realm-swift", .exact("20.0.3")),
        .package(url: "https://github.com/onevcat/Kingfisher", .exact("8.3.3")),
    ]
}

public let swiftlintScript: TargetScript = .pre(
    script: """
    echo "SwiftLint SRCROOT: ${SRCROOT}"
    export PATH="$PATH:/opt/homebrew/bin"
    
    if which swiftlint >/dev/null; then
        swiftlint --config "${SRCROOT}/.swiftlint.yml"
    else
        echo "warning: SwiftLint not installed"
    fi
    """,
    name: "SwiftLint",
    outputPaths: ["$(DERIVED_FILE_DIR)/swiftlint.log"]
)

public let appTarget: DeploymentTargets = .iOS("16.0")

let project = Project(
    name: "SearchApp",
    organizationName: "com.portfolio",
    packages: CommonPackages.all, // 외부 라이브러리가 있다면 여기에 추가 (e.g., Alamofire, Kingfisher)
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.portfolio.app",
            deploymentTargets: appTarget,
            infoPlist: .extendingDefault(
                with: [
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ],
                    "UILaunchStoryboardName": "LaunchScreen",
                    "CFBundleShortVersionString": "1.0.0",  // 앱 버전
                    "CFBundleVersion": "100",               // 빌드 번호
                    "CFBundleDisplayName": "최주영포트폴리오"    // 앱 표시 이름
                ]
            ),
            sources: ["Targets/App/Sources/**"],
            resources: ["Targets/App/Resources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .target(name: "FeatureSearch"),
                .target(name: "FeatureImage"),
                .target(name: "FeatureBookMark"),
                .target(name: "Domain"),
                .target(name: "Data"), // App에서 의존성 주입을 위해 Data 모듈을 알아야 함
                .package(product: "RxSwift"),
                .package(product: "RxCocoa"),
                .package(product: "RxDataSources"),
                .package(product: "Kingfisher"),
                .package(product: "SnapKit"),
                .package(product: "RealmSwift")
            ]
        ),
        .target(
            name: "FeatureSearch",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.featureSearch",
            deploymentTargets: appTarget,
            sources: ["Targets/FeatureSearch/Sources/**"],
            resources: ["Targets/FeatureSearch/Resources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Core"),
                .target(name: "DesignSystem"),
                .package(product: "Kingfisher"),
                .package(product: "SnapKit"),
                .package(product: "Alamofire"),
                .package(product: "RealmSwift"),
            ]
        ),

        .target(
            name: "FeatureImage",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.featureImage",
            deploymentTargets: appTarget,
            sources: ["Targets/FeatureImage/Sources/**"],
            resources: ["Targets/FeatureImage/Resources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Core"),
                .target(name: "DesignSystem"),
                .package(product: "Kingfisher"),
                .package(product: "SnapKit"),
                .package(product: "Alamofire"),
                .package(product: "RealmSwift"),
            ]
        ),

        .target(
            name: "FeatureBookMark",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.featureBookMark",
            deploymentTargets: appTarget,
            sources: ["Targets/FeatureBookMark/Sources/**"],
            resources: ["Targets/FeatureBookMark/Resources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Core"),
                .target(name: "DesignSystem"),
                .package(product: "Kingfisher"),
                .package(product: "SnapKit"),
                .package(product: "Alamofire"),
                .package(product: "RealmSwift"),
                .package(product: "RxSwift"),
                .package(product: "RxCocoa"),
                .package(product: "RxDataSources"),

            ]
        ),

        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.DesignSystem",
            deploymentTargets: appTarget,
            sources: ["Targets/DesignSystem/Sources/**"],
            resources: ["Targets/DesignSystem/Resources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .package(product: "SnapKit"),
            ]
        ),

        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.domain",
            deploymentTargets: appTarget,
            sources: ["Targets/Domain/Sources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [] // Domain은 아무것도 의존하지 않음
        ),
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.data",
            deploymentTargets: appTarget,
            sources: ["Targets/Data/Sources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .target(name: "Domain"), // Domain의 Repository 프로토콜을 구현하기 위해 의존
                .package(product: "Alamofire"),
                .package(product: "RealmSwift")
            ]
        ),
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.portfolio.core",
            deploymentTargets: appTarget,
            sources: ["Targets/Core/Sources/**"],
            resources: ["Targets/Core/Resources/**"],
            scripts: [
                swiftlintScript,
            ],
            dependencies: [
                .package(product: "SnapKit")
            ]
        ),
        .target(
            name: "AppUITest",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "io.tuist.portfolio.AppUITest",
            deploymentTargets: appTarget,
            infoPlist: .default,
            sources: ["Targets/AppUITest/Sources**"],
            dependencies: [
                .target(name: "App"),
                .package(product: "RxSwift"),
                .package(product: "RxCocoa"),
                .package(product: "RxDataSources"),
                .package(product: "Kingfisher"),
                .package(product: "SnapKit"),
                .package(product: "RealmSwift") ]
        )
    ]
)
