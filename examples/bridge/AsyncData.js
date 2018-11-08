import RNUINative from "../..";

class AsyncData extends RNUINative.Handler {
    async performDelay() {
        const delayPromise = new Promise((resolve) => setTimeout(resolve, 1000));

        await delayPromise;

        return [];
    }
}

export default RNUINative.registerHandler('AsyncData', () => AsyncData);
