/**
 * RNUINative Examples React Native App
 * https://github.com/houserater/react-native-ui-native
 */

import React from 'react';
import {
    AppRegistry,
    StyleSheet,
    Button,
    View
} from 'react-native';

import "./bridge/ExampleController";
import ForwardingEmitter from "./services/ForwardingEmitter";

class RNUINativeExamples extends React.Component {
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

AppRegistry.registerComponent('RNUINativeExamples', () => RNUINativeExamples);
