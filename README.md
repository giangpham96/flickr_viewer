# flickr_viewer
A simple Flutter application that allows users to search for images on Flickr using search bar or predefined keywords

## Languages, libraries and tools
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [dio](https://pub.dev/packages/dio) A powerful Http client for Dart
- [retrofit](https://pub.dev/packages/retrofit) a type conversion dio client generator using source_gen 
and inspired by Retrofit2 (Android and Java)
- [rxdart](https://pub.dev/packages/rxdart) an implementation of the popular reactiveX api 
for asynchronous programming
- [get_it](https://pub.dev/packages/get_it) simple direct Service Locator that allows to decouple the interface 
from a concrete implementation and to access the concrete implementation from everywhere

## Architecture
This project follows [BLoC Pattern](https://medium.com/flutter-community/flutter-bloc-with-streams-6ed8d0a63bb8) 
and Clean Architecture

- ### UI
Flutter UI widgets belong here. View communicates with BLoC, subscribing to ViewState. 
Each Widget has a ViewState attached that provides the data required by the view to make state transitions.

- ### Presentation
This module provides the logic of the UI, by providing subscribing components to the widgets to react to. 
The BLoC changes the ViewState based on the use case responses.

- ### Domain
Contain use cases of the application. They provide the application specific business rules and are 
are responsible of accessing data from different repositories, combine and transform them, to 
provide single use case business rule.

- ### Data
The Data layer is our access point to external data layers and is used to fetch data from multiple 
sources (network, cache). It contains implementations of Repositories, which request data from 
necessary RemoteDataSources and CacheDataSources to feed the use case and make communication 
between the 2 types of data sources.


- ### Remote
The Remote layer handles all communications with remote sources such as API calls using a Retrofit 
definition. A RemoteImpl class implements a Remote interface from the Data layer and uses a Service 
to retrieve data from the API.


- ### Cache
The Cache layer handles all communication with the local database.

## Test
`flutter test`

## Build
- Retrieve a flickr api key by following [this instruction](https://www.flickr.com/services/api/misc.api_keys.html)
- In the root of the repository, create an assets directory if it is missing
- Inside assets, create a file called `secret.json` with the following content
```
{"flickr_api_key": "<YOUR_FLICKR_API_KEY>"}
```
- Connect a device or an emulator
- Build
```
flutter run
```

## CI
Github Actions will run tests and build debug application (iOS, Android) on every pull request and merge event.
Test coverage is reported at [CodeCov](https://codecov.io/gh/giangpham96/flickr_viewer)
