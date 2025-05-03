class QuizQuestion {
  final int id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}
