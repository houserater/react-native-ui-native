//
//  RNUINativeManager.h
//  RNUINative
//
//  Created by Hank Brekke on 10/25/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <React/RCTBridgeModule.h>

typedef void (^RNUINativeDataCallback)(id data, NSError *error);
typedef void (^RNUINativeEventCallback)(id data);

@interface RNUINativeManager : NSObject <RCTBridgeModule>

/** Send native data to the JS bridge, and retreive a response for UI rendering. It
 can be used as an event emitter or for retrieving data through the bridge.
 
 This function requires JS handlers to have been hooked into the JS project. You can
 see the RNUINative example project or the code below for examples on hooking JS handers
 into your app.
 
 @code
 // bridge/MyHandler.js
 import RNUINative from "react-native-ui-native";
 
 class MyHandler extends RNUINative.Handler {
     static name = "MyHandler";
     async findDocuments() {
         return [];
     }
 }
 
 RNUINative.registerHandler(MyHandler);
 
 // index.ios.js
 import "./bridge/MyHandler.js"@endcode
 
 @param handler Formatted JS handler, as `Handler.function()` with the empty parenthesis.
 @param arguments Optional array of arguments for the JS handler.
 @param callbackBlock Optional callback for the JS data response. You can send `nil` for event
   emitters.
 */
+ (void)loadDataWithHandler:(NSString * _Nonnull)handler arguments:(NSArray * _Nullable)arguments completionBlock:(RNUINativeDataCallback)callbackBlock;

/** Listen for events from JS until the `controller` has been deallocated.
 
 Any JS handler subclassing `registerEventListeners()` can submit events that will be
 transmitted through the bridge.
 
 @code
 class MyHandler extends RNUINative.Handler {
     static name = "MyHandler";
     registerEventListeners() {
         InnerAppState.addEventListener('js-event-name', this.buildEmitter('jsEventName'));
     }
 }@endcode
 
 @param handler Formatted JS handler, as `Handler.jsEventName` from the `buildEmitter()` call.
 @param eventBlock Handler for the JS event data (Note: you will want a weak reference to
   `self` in this block for the listener to be properly removed).
 @param sender Object that will be monitored for deallocation to remove this listener.
 */
+ (void)addEventListener:(NSString * _Nonnull)handler eventBlock:(RNUINativeEventCallback)eventBlock withController:(id)sender;

@end
