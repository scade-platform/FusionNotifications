# FusionNotifications
The FusionNotifications SPM package makes it possible to use Bluetooth functionality on Android and iOS using Swift 

Discuss
-------
Join our slack channel here for Fusion Package discussion [link](https://scadeio.slack.com/archives/C025WRG18TW)

For native cross plaform development with Swift and geneel Fusion introduciton, go here [SCADE Fusion](beta.scade.io/fusion)

Install - Add to Package.swift
------------------------------
```swift
import PackageDescription
import Foundation

let SCADE_SDK = ProcessInfo.processInfo.environment["SCADE_SDK"] ?? ""

let package = Package(
    name: "BluetoothApp",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "BluetoothApp",
            type: .static,
            targets: [
                "BluetoothApp"
            ]
        )
    ],
    dependencies: [
		.package(name: "FusionNotifications", url: "https://github.com/scade-platform/FusionNotifications.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "BluetoothApp",
            dependencies: [
            	.product(name: "FusionNotifications", package: "FusionNotifications"),
            ],
            exclude: ["main.page"],
            swiftSettings: [
                .unsafeFlags(["-F", SCADE_SDK], .when(platforms: [.macOS, .iOS])),
                .unsafeFlags(["-I", "\(SCADE_SDK)/include"], .when(platforms: [.android])),
            ]
        )
    ]
)
```

Permission Settings
-------------------
<Add Permission specific text and instructions>

```yaml
...
ios:
  ...
  plist:
    ...
    - key: NSBluetoothAlwaysUsageDescription
      type: string
      value: Use Bluetooth    

android:
  ...
  permissions: ["ACCESS_FINE_LOCATION", "BLUETOOTH", "BLUETOOTH_ADMIN", "ACCESS_COARSE_LOCATION"]
  ...
```

Demo App
--------
Our demo app is available here [link](https://github.com/scade-platform/FusionExamples/tree/main/NotificationsApp)


Basic Usage
-----------
```swift
    ...

    ...
```

Features
--------
List of features
* Time Notification
* Calendar Notification
* Location Notification
* Push Notification

API
---
Please find the api here [API](./Sources/FusionNotifications_Common/Notifications.swift)


