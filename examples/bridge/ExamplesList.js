import RNUINative from "../..";

class ExamplesList extends RNUINative.Controller {
    static name = "ExamplesList";

    findExamples() {
        return [
            // Examples lookup `controller` in `Main.storyboard` to render the view controller
            { title: "JS Root View", controller: "RNUINExample-JSEventButton" },

            { title: "Swift View", controller: "RNUINExample-SwiftController" },
            { title: "Native Arguments", controller: "RNUINExample-NativeArgController" },
            { title: "Multi-loadData()", controller: "RNUINExample-LoadMultiData" }
        ]
    }
}

RNUINative.registerController(ExamplesList);
