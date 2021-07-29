class ZureStringService {
  static String zureCheckFormatter(String str) {
    if (str.isEmpty) {
      return 'Please enter your words';
    }
    var match = RegExp(r'^[a-z0-9_]+$').hasMatch(str);
    if (match) {
      var firstMatch = RegExp(r'^[a-z]+$').hasMatch(str[0]);
      if (firstMatch) {
        return '';
      } else {
        return 'The first character should be "a~z"';
      }
    } else {
      return 'Your word has invalid character';
    }
  }

  static bool zureCheckRepeat(List<String> list) {
    if (list.isEmpty || list.length == 1) {
      return false;
    }
    for (var str in list) {
      List<String> lOthers = list;
      lOthers.removeAt(list.indexOf(str));
      if (lOthers.contains(str)) {
        return true;
      }
    }
    return false;
  }
}