class DateTimeParser {
  static String toDataString(DateTime dateTime) {
    return "${dateTime.year};${dateTime.month};${dateTime.day};${dateTime.hour};${dateTime.minute};${dateTime.second}";
  }

  static DateTime parsed(String string) {
    List<String> split = string.split(";");
    return DateTime(
      int.parse(split[0]),
      int.parse(split[1]),
      int.parse(split[2]),
      int.parse(split[3]),
      int.parse(split[4]),
      int.parse(split[5]),
    );
  }
}
