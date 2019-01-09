# React Native UI Native

*Native iOS UI views with a React Native backend.*

## Getting Started

Install React Native UI Native:

```bash
$ yarn add react-native-ui-native
```

Then link it to your project:

```bash
$ react-native link
```

Once the project is linked, ensure that your `AppDelegate` class stores the
`RCTBridge` as an `AppDelegate().bridge` property.

```objc
// AppDelegate.h
@property (nonatomic, strong) RCTBridge *bridge;

// AppDelegate.m
#import <RNUINative/RNUINativeManager.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // ...

    self.bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                        moduleProvider:nil
                                         launchOptions:launchOptions];

    // ...
}
```

Note: If you're rendering an `RCTRootView` for your app, you will replace your
existing constructor to utilize the new bridge rather than the `jsCodeLocation`
directly using this `initWithBridge:::` code.

```objc
RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                                 moduleName:@"HelloWorld"
                                          initialProperties:nil];
```

## Usage

This project is meant for native apps using React Native as the primary data
source for backend services. That means you're able to use advanced features in
Xcode & Interface Builder (i.e. Storyboards and XIBs), while still communicating
to the JS backend of your application.

There generally are two entry points to native code--the app launching directly to
native code...or the `RCTBridge` triggering a modal or swap of main content into native
code.

```objc
[RNUINativeManager addEventListener:@"HandlerName.launchNativeModal" eventBlock:^(id data) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *initialVC = [storyboard instantiateInitialViewController];
    
    [self.window.rootViewController presentViewController:initialVC animated:YES completion:nil];
    // or use `self.window.rootViewController = initialVC;` to replace the screen.
} withController:self];
```

The `^` above code will listen for an event (typically emitted by a button) to launch
a modal containing native code. Instead, you can also configure the *Main Interface*
of your project in the Xcode project tab, and remove any `self.window` code from the
`AppDelegate` as your app launches (since a Main Interface already declares
`self.window`).

Handlers, like the one used above, are defined and imported into your project by
extending the `RNUINative.Handler` class.

```js
// MyHandler.js
import RNUINative from "react-native-ui-native";
import MyService from "../services/MyService";

class MyHandler extends RNUINative.Handler {
    registerEventListeners() {
        MyService.addEventListener('service-event', this.buildEmitter('launchNativeModal'));
    }
    
    async getServiceData() {
        const tableData = await MyService.getData();
        
        return tableData.map((item) => ({
            title: item.title,
            id: item.databaseID
        }));
    }
}
RNUINative.registerHandler('HandlerName', () => MyHandler);

// index.ios.js
import "./handlers/MyHandler";
```

Don't forget `^` that your `index.ios.js` file needs to import the handler files (either
directly or indirectly), otherwise the JS code will not actually be included by the Metro
bundler.

Now, using standard `UIViewController` subclasses, you can load data and listen to events
utilizing the JS bridge with `loadData:::`.

```objc
[RNUINativeManager loadData:@"HandlerName.getServiceData()" arguments:@[ @"arg1", @{"arg2": 1 } ] completionBlock:^(id data, NSError *error) {
    if (error) {
        NSLog(@"Unable to load JS data", error);
        return;
    }
    
    self.myTableData = data;
    [self.tableView reloadData];
}];
```

You can also send a `nil` completion block, in order to notify JS code of events
occurring natively.

```objc
[RNUINativeManager loadData:@"HandlerName.notifyService()", arguments:@[ @"mydata" ] completionBlock:nil];
```

The project allows you to transmit any JSON-serializable data between JS and native
code quickly, with simple JS handlers as entry-points to your JS bridge.

## Usage in Swift

Swift controllers provide improved static typing and abstract-ability over Objective-C,
and can make the usage of `react-native-ui-native` even more powerful. Just make sure
that you add `#import <RNUINative/RNUINativeManager.h>` to your `Bridging-Header.h`
file in order to access the project.

Using projects like [Unbox][swift-unbox] or [Argo][swift-argo], you can make the
decoding of `id data` much easier.

```swift
private var myTableData: [MyTableData]

override func viewDidLoad() {
    RNUINativeManager.loadData(withHandler: "HandlerName.getServiceData", arguments: nil) { data, error in
        if let err = error {
            print("Unable to load JS data \(err)")
            return
        }
        
        do {
            self.myTableData = try unbox(data: data)
            self.tableView.reloadData()
        } catch {
            print("Unable to parse JS data \(error)")
        }
    }
}
```

You can also listen for events using the bridged `addEventListener:::` method.

```swift
RNUINativeManager.addEventListener("HandlerName.launchNativeModal", eventBlock: { [unowned self] data in
    do {
        let event: MyEvent = try unbox(data: data)
        // ...
    } catch {
        print("Unable to parse JS data \(error)")
    }
}, withController:self)
```

Finally, notifying JS code about events from native actions can be done using
`loadData:::` in Swift with a `nil` completion block.

```swift
RNUINativeManager.loadData(withHandler: "HandlerName.notifyService()", arguments: [ "mydata" ], completionBlock: nil)
```

## Known Considerations

- **We use `withController:self` on event listeners, so that the handler can
  automatically be removed when the view controller (or any generic object) is
  de-allocated.**
- This project depends on reading the `AppDelegate().bridge` property, rather
  than containing some injection function, such as `RNUINativeManager.setBridge()`
- This project does not currently have Android support--HouseRater currently only
  publishes apps for iOS.

## Running the Example App

You can run an example project for `react-native-ui-native` to see how this
project works by launching the `examples/ios/RNUINativeExamples.xcodeproj` file.

In Xcode 10, you may see a build failure the first time you build. This is because
of React Native's [lack of support][xcode-build-system] for the new Xcode build
system. After the first build, Xcode will have ran the `postinstall` script of
`react-native`, which installs and configures the `third-party` modules, and
therefore allows a successful Xcode build with the new build system.

## Notes

- This module is currently in initial stages of development, and it **not
recommended** for large-scale use

## License

[MIT][license]


[xcode-build-system]: https://github.com/facebook/react-native/issues/19573
[license]: https://github.com/houserater/react-native-ui-native/blob/master/LICENSE
[swift-unbox]: https://github.com/JohnSundell/Unbox
[swift-argo]: https://github.com/thoughtbot/Argo
