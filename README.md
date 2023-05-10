# Simple Chopper Logger

Simple Chopper Logger is a [Chopper](https://pub.dev/packages/chopper) interceptor that prints request and response logs in a readable format.

## Usage

To use Simple Chopper Logger just add it to your Chopper client:

```dart
import 'package:simple_chopper_logger/simple_chopper_logger.dart';

final chopperClient = ChopperClient(
  baseUrl: 'YOUR_BASE_URL',
  services: [
    // Your services here
  ],
  interceptors: [
    SimpleChopperLogger(),
  ],
);
```

# How it looks like

## Request

![Example Request](https://github.com/Iteo/simple_chopper_logger/blob/main/images/request.png)

## Response

![Example Response](https://github.com/Iteo/simple_chopper_logger/blob/main/images/response.png)