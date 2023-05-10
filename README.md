# simple_chopper_logger

Simple Chopper Logger is a [Chopper](https://pub.dev/packages/chopper) interceptor that prints request and response logs in a readable format.

## Usage

To use Simple Chopper Logger just add it to your Chopper client:

```dart
final chopper = ChopperClient(
  baseUrl: 'YOUR_BASE_URL',
  services: [
    // Your services here
  ],
  interceptors: [
    SimpleChopperLogger(),
  ],
);
```

## How it looks
<!-- TODO ADD EXAMPLE -->