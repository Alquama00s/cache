part of internal_lib;
// contains all function pertaining to url

///whether the string correctly formated to urls
bool isUrlCorrect(String url) => Uri.parse(url).isAbsolute;
