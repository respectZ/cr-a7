class TimedString {
  List<String> Strings = [];
  List<Duration> Timing = [];
  TimedString({required this.Strings, required this.Timing});

  Stream<String> generateString() async* {
    for (int i = 0; i < Strings.length; i++) {
      await Future<void>.delayed(Timing[i]);
      yield Strings[i];
    }
  }

  List<Duration> getTiming() => Timing;
  List<String> getString() => Strings;
}
