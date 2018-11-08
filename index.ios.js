/**
 * Copyright (c) 2018, HouseRater LLC.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @providesModule react-native-ui-native
 */

import React from "react";
import { NativeModules } from "react-native";
const BatchedBridge = require('BatchedBridge');

const RNUINativeManager = NativeModules.RNUINativeManager;

class RNUINativeController {
    constructor() {
        if (this.registerEventListeners) {
            this.registerEventListeners();
        }
    }

    buildEmitter(eventName) {
        return (data) => {
            const fullEventName = `${this.constructor.name}.${eventName}`;
            RNUINativeManager.emitEvent(fullEventName, JSON.stringify(data));
        };
    }
}

class RNUINative {
    constructor() {
        this.Controller = RNUINativeController;

        this._controllers = {};
    }

    registerController(Controller) {
        const controller = new Controller();
        this._controllers[Controller.name] = controller;

        return controller;
    }

    async loadData(handler, responseId, ...args) {
        try {
            // We assume native callers will always supply `Controller.functionName()` with the empty parenthesis
            // (even when arguments are passed in via native code). This is a paradigm that makes it easier to run
            // Project-Find operations, but is not following any specific programming convention :)

            const [, controllerName, actionName ] = handler.match(/([a-zA-Z0-9]+)\.([a-zA-Z0-9]+)\(\)/);
            const controller = this._controllers[controllerName];

            const response = await controller[actionName](...args);
            RNUINativeManager.loadDataComplete(JSON.stringify(response), responseId, null);
        } catch (err) {
            RNUINativeManager.loadDataComplete(null, responseId, err.message);
        }
    }
}

const uiNativeInstance = new RNUINative();
BatchedBridge.registerCallableModule('RNUINative', uiNativeInstance);
export default uiNativeInstance;
