# previous design
we first implemented a very simple cache using hive whic cached the data of
some network calls so the cache system was implemented at the very function 
the call was made and it became the responsipility whoever programmed a particular api
to implement it in their function


## External packages

At the time of implementing this API we dont have an option there is fairly only one package that only handels network files.

also we need a custom cache because there is one API call which saves the cache and other which makes it dirty

# New improved cache


## Basic structure
This current design has three classes 
1. Backend (responsible for fetching request from Backend)
1. cachedRequest (responsible for managing local cachedRequest)
1. server (contains functions specific to a particular server, this is the class we need to add to incase of future server integration)

server class is implemented separate from the other two

cachedRequest and Backend will both have an implementation to handle diffrent requests (get,post or multipart etc)

the server class will call the cachedRequest class directly the cachedRequest class will handle the requests if it can other wise it will transfer that request up to Backend class.

the Backend class will then send the data to cachedRequest class and here the cachedRequest will save the data to local storage

the Backend class can not be called directly

## Behaviour //TODO