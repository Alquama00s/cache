part of internal_lib;

//this extension on response is where we will store response and errors
//depending on the errors we will handle it accordingly
//in ui

extension CoustomResponse on Response {
  // TODO:later logger to be integrated to log server response

  ///get error message to show in ui
  String getErrorMessage() {
    switch (this.statusCode) {
      case 201:
        {
          return 'No Error';
        }
      case 200:
        {
          return 'No Error ';
        }
      case 400:
        {
          return 'Invalid Response';
        }
      case 401:
        {
          return 'Unauthorized';
        }
      case 403:
        {
          return 'Forbidden';
        }
      case 404:
        {
          return 'Not found';
        }
      case 101:
        {
          return 'Url Not good';
        }
      case 102:
        {
          return 'No error back from cache';
        }
    }
    return 'Unknown Error';
  }

  ///checks if the response is ok
  bool get isResponseGood =>
      this.statusCode == 201 ||
      this.statusCode == 200 ||
      this.statusCode == 102;

  ///this method should be called only if the response code
  ///is 201
  Map<String, dynamic> getBodyMap() {
    var _json = json.decode(this.body.toString());
    return Map<String, dynamic>.from(_json);
  }

  ///handle an error
  Widget handleError() {
    return Center(
      child: Text(this.getErrorMessage()),
    );
  }
}
