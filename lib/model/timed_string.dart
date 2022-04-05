class TimedString {
  List<String> Strings = [];
  List<Duration> Timing = [];
  TimedString({required this.Strings, required this.Timing});

  List<Duration> getTiming() => Timing;
  List<String> getString() => Strings;
}
