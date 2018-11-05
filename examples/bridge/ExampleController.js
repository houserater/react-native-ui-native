import RNUINative from "../..";

import ForwardingEmitter from "../services/ForwardingEmitter";

class ExampleController extends RNUINative.Controller {
    static name = "ExampleController";

    registerEventListeners() {
        ForwardingEmitter.addListener('buttonTapped', this.buildEmitter('buttonTapped'));
    }

    async loadDocuments() {
        return [{ random: Math.random() }]
    }
}

RNUINative.registerController(ExampleController);
