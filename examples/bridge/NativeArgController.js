import RNUINative from "../..";

class NativeArgController extends RNUINative.Controller {
    static name = "NativeArgController";

    submitUUID(uuid) {
        return uuid;
    }
}

RNUINative.registerController(NativeArgController);
