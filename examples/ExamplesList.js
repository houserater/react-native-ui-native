import RNUINative from "../index";

import ObjCEvent from "./bridged-views/ObjCEvent";
import SwiftEvent from "./bridged-views/SwiftEvent";
import LoadMultiData from "./bridge/LoadMultiData";
import NativeArgs from "./bridge/NativeArgs";
import AsyncData from "./bridge/AsyncData";

class ExamplesList extends RNUINative.Handler {
    findExamples() {
        // The native `examples` app renders `Main.storyboard` controllers by ID. Our example JS handlers
        // each export the name of the storyboard view controller ID.

        return [
            { title: "JS Root View (ObjC)", controller: ObjCEvent.name },
            { title: "JS Root View (Swift)", controller: SwiftEvent.name },
            { title: "Native Arguments", controller: NativeArgs.name },
            { title: "Multi-loadData()", controller: LoadMultiData.name },
            { title: "Async Data", controller: AsyncData.name },
        ]
    }
}

RNUINative.registerHandler('ExamplesList', () => ExamplesList);
