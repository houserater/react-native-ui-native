import React from "react";
import {
    AppRegistry,
    StyleSheet,
    Button,
    View
} from "react-native";
import EventEmitter from "EventEmitter";

import RNUINative from "../..";

const ForwardingEmitter = new EventEmitter();

class ObjCEvent extends RNUINative.Handler {
    registerEventListeners() {
        ForwardingEmitter.addListener('buttonTapped', this.buildEmitter('buttonTapped'));
    }
}

class ObjCEventView extends React.Component {
    render() {
        return (
            <View style={styles.container}>
                <Button
                    onPress={() => ForwardingEmitter.emit('buttonTapped', { time: Date.now() })}
                    title="Emit JS Event"
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#ccc',
    },
});

AppRegistry.registerComponent('ObjCEventView', () => ObjCEventView);
export default RNUINative.registerHandler('ObjCEvent', () => ObjCEvent);
