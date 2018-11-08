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

class RNUINativeHandler {
    constructor(name) {
        this._RNUINativeName = name;

        if (this.registerEventListeners) {
            this.registerEventListeners();
        }
    }

    buildEmitter(eventName) {
        return (data) => {
            const fullEventName = `${this._RNUINativeName}.${eventName}`;
            RNUINativeManager.emitEvent(fullEventName, JSON.stringify(data));
        };
    }
}

const _registeredHandlers = {};

class RNUINative {
    static Handler = RNUINativeHandler;

    static registerHandler(name, registerFn) {
        const HandlerClass = registerFn();
        const handler = new HandlerClass(name);
        _registeredHandlers[name] = handler;

        return { name, handler };
    }

    static async loadData(handleId, responseId, ...args) {
        try {
            // We assume native callers will always supply `Handler.functionName()` with the empty parenthesis
            // (even when arguments are passed in via native code). This is a paradigm that makes it easier to run
            // Project-Find operations, but is not following any specific programming convention :)

            const [, handlerName, actionName ] = handleId.match(/([\w\s-]+)\.([\w\s-]+)\(\)/);

            const handler = _registeredHandlers[handlerName];
            if (!handler) {
                throw new Error(`Unregistered handler "${handlerName}"`);
            }

            const actionFn = handler[actionName];
            if (!actionFn) {
                throw new Error(`Unregistered action "${handlerName}.${actionFn}()"`);
            }

            const response = await actionFn(...args);
            RNUINativeManager.loadDataComplete(JSON.stringify(response), responseId, null);
        } catch (err) {
            RNUINativeManager.loadDataComplete(null, responseId, err.message);
        }
    }
}

BatchedBridge.registerCallableModule('RNUINative', RNUINative);
export default RNUINative;
