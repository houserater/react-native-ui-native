import RNUINative from "../..";

class NativeArgs extends RNUINative.Handler {
    submitUUID(uuid) {
        return uuid;
    }
}

export default RNUINative.registerHandler('NativeArgs', () => NativeArgs);
