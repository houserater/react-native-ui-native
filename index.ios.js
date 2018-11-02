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

    async loadData(handler) {
        const [, controllerName, actionName ] = handler.match(/([a-zA-Z0-9]+)\.([a-zA-Z0-9]+)\(\)/);

        const controller = this._controllers[controllerName];

        try {
            const response = await controller[actionName]();
            RNUINativeManager.loadDataComplete(JSON.stringify(response), null);
        } catch (err) {
            RNUINativeManager.loadDataComplete(null, err.message);
        }
    }
}

const uiNativeInstance = new RNUINative();
BatchedBridge.registerCallableModule('RNUINative', uiNativeInstance);
export default uiNativeInstance;
