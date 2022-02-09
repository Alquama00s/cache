<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
# Cache
This flutter package lets you cache your api responses locally
thus saving network calls 
## Installing

```
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.0.5
  cache:
    git:
        url:https://github.com/Alquama00s/cache.git
```

## Usage

A simple scenario includes your application fetching data from server
(a get request) and then updating the modified change (A post request)

lets give this group of operations (get and post) on a particular data field  a name say `user-profile`

just do the following to cache your user profile

```dart
const String userGroup = "user-profile";

String url = "my-url"; //no need to uri parse

Response r = cache.getRequest(url, cache:true, alias:userGroup); //this will automatically fetch ur data from local unless cache is expired then it will fetch it from server

cache.postRequest(url,headers,body, cache:true, alias:userGroup,); //this will invalidate the local cache so next time a get request will result in server call

```





<!--
TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.



## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.



## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
-->