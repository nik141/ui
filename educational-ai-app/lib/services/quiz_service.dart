import 'package:flutter_educational_app/models/quiz_question.dart';

class QuizService {
  // In a real app, you would fetch questions from an API
  // This is a mock implementation
  Future<List<QuizQuestion>> getQuizQuestions(String topic) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate questions based on the topic
    return _generateQuestions(topic);
  }

  List<QuizQuestion> _generateQuestions(String topic) {
    // In a real app, you would generate questions based on the topic using AI
    // or fetch them from a database
    
    // For now, we'll create some generic questions
    return [
      QuizQuestion(
        id: 1,
        text: 'What is the main concept behind $topic?',
        options: [
          '$topic is primarily about theoretical concepts',
          '$topic focuses on practical applications',
          '$topic combines both theory and practice',
          '$topic is an outdated concept',
        ],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        id: 2,
        text: 'Which of the following is NOT related to $topic?',
        options: [
          'Core principles of $topic',
          'Advanced applications of $topic',
          'Historical development of $topic',
          'Unrelated subject matter',
        ],
        correctAnswerIndex: 3,
      ),
      QuizQuestion(
        id: 3,
        text: 'How is $topic typically applied in real-world scenarios?',
        options: [
          'Through theoretical research only',
          'In practical, everyday situations',
          'Only in specialized academic settings',
          'It has no practical applications',
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        id: 4,
        text: 'What is considered the foundation of $topic?',
        options: [
          'Basic principles and core concepts',
          'Advanced theoretical frameworks',
          'Historical precedents',
          'Recent innovations',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        id: 5,
        text: 'Which field is most closely related to $topic?',
        options: [
          'An entirely unrelated field',
          'A somewhat related discipline',
          'A closely aligned area of study',
          'The exact same field with a different name',
        ],
        correctAnswerIndex: 2,
      ),
    ];
  }
}
