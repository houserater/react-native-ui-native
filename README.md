# React Native UI Native

*Native iOS UI views with a React Native backend.*

## Getting Started

Install React Native UI Native:

```bash
$ yarn add react-native-ui-native
```

Then link it to your project:

```bash
$ react-native link
```

## Usage

WIP

## Running the Example App

You can run an example project for `react-native-ui-native` to see how this
project works by launching the `examples/ios/RNUINativeExamples.xcodeproj` file.

In Xcode 10, you may see a build failure the first time you build. This is because
of React Native's [lack of support][xcode-build-system] for the new Xcode build
system. After the first build, Xcode will have ran the `postinstall` script of
`react-native`, which installs and configures the `third-party` modules, and
therefore allows a successful Xcode build with the new build system.

## Notes

- This module is currently in initial stages of development, and it **not
recommended** for large-scale use

## License

[MIT][license]


[xcode-build-system]: https://github.com/facebook/react-native/issues/19573
[license]: https://github.com/houserater/react-native-ui-native/blob/master/LICENSE
