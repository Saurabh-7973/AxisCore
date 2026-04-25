class PanicProtocol {
  const PanicProtocol({
    required this.title,
    required this.steps,
    required this.eventCount,
  });

  final String title;
  final List<String> steps;
  final int eventCount;
}
