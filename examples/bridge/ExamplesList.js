import RNUINative from "../..";

class ExamplesList extends RNUINative.Controller {
    static name = "ExamplesList";

    async findExamples() {
        return [
            // Examples lookup `controller` in `Main.storyboard` to render the view controller
            { title: "JS Root View", controller: "RNUINExample-JSEventButton" },

            { title: "Swift View", controller: "RNUINExample-SwiftController" }
        ]
    }
}

RNUINative.registerController(ExamplesList);
