import RNUINative from "../..";

class SwiftController extends RNUINative.Controller {
    static name = "SwiftController";

    async getDate() {
        return Date.now()
    }
}

RNUINative.registerController(SwiftController);
