import 'package:flutter/material.dart';
import 'package:flutter_educational_app/models/quiz_question.dart';
import 'package:flutter_educational_app/services/quiz_service.dart';
import 'package:flutter_educational_app/widgets/topic_selector.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String? _selectedTopic;
  bool _gameStarted = false;
  bool _gameCompleted = false;
  int _score = 0;
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _correctAnswers = 0;
  bool _isLoading = false;

  final QuizService _quizService = QuizService();

  void _handleTopicSelect(String topic) {
    setState(() {
      _selectedTopic = topic;
    });
  }

  void _startGame() async {
    if (_selectedTopic == null) return;
    
    setState(() {
      _gameStarted = true;
      _gameCompleted = false;
      _score = 0;
      _currentQuestionIndex = 0;
      _selectedOptionIndex = null;
      _isAnswered = false;
      _correctAnswers = 0;
      _isLoading = true;
    });
    
    try {
      final questions = await _quizService.getQuizQuestions(_selectedTopic!);
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load questions: $e')),
        );
      }
    }
  }

  void _handleOptionSelect(int optionIndex) {
    if (_isAnswered) return;
    
    setState(() {
      _selectedOptionIndex = optionIndex;
    });
  }

  void _checkAnswer() {
    if (_selectedOptionIndex == null) return;
    
    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = _selectedOptionIndex == currentQuestion.correctAnswerIndex;
    
    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      });
    } else {
      // Game completed
      final finalScore = (_correctAnswers / _questions.length * 100).round();
      setState(() {
        _score = finalScore;
        _gameCompleted = true;
        _gameStarted = false;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _selectedTopic = null;
      _gameStarted = false;
      _gameCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Games'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _gameCompleted
            ? _buildGameCompleted()
            : _gameStarted
                ? _isLoading
                    ? _buildLoadingQuiz()
                    : _buildQuizGame()
                : _buildTopicSelector(),
      ),
    );
  }

  Widget _buildTopicSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a Topic to Play',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a topic you\'ve learned about to test your knowledge',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                TopicSelector(onSelect: _handleTopicSelect),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _selectedTopic == null ? null : _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Start Game'),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingQuiz() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading questions about $_selectedTopic...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizGame() {
    if (_questions.isEmpty) {
      return Center(
        child: Text(
          'No questions available for this topic. Please try another topic.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = _currentQuestionIndex / _questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Score: $_correctAnswers/${_currentQuestionIndex + (_isAnswered ? 1 : 0)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion.text,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(
                  currentQuestion.options.length,
                  (index) => _buildOptionItem(index, currentQuestion),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAnswered
                        ? _nextQuestion
                        : _selectedOptionIndex == null
                            ? null
                            : _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: _isAnswered
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    child: Text(
                      _isAnswered
                          ? _currentQuestionIndex < _questions.length - 1
                              ? 'Next Question'
                              : 'Finish Quiz'
                          : 'Check Answer',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem(int index, QuizQuestion question) {
    final isSelected = _selectedOptionIndex == index;
    final isCorrect = index == question.correctAnswerIndex;
    
    Color? backgroundColor;
    Color? borderColor;
    
    if (_isAnswered) {
      if (isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return GestureDetector(
      onTap: _isAnswered ? null : () => _handleOptionSelect(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor ?? Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(question.options[index]),
            ),
            if (_isAnswered)
              Icon(
                isCorrect ? Icons.check_circle : (isSelected ? Icons.cancel : null),
                color: isCorrect ? Colors.green : Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCompleted() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Game Completed!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'You\'ve completed the quiz on $_selectedTopic',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Score: $_score%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _score / 100,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  const SizedBox(height: 32),
                  _buildFeedbackCard(
                    title: 'What you did well:',
                    content: _score > 70
                        ? 'Great job! You have a solid understanding of the topic.'
                        : 'You\'ve made a good start with understanding the basics.',
                  ),
                  const SizedBox(height: 16),
                  _buildFeedbackCard(
                    title: 'Areas to improve:',
                    content: _score > 70
                        ? 'Review the few questions you missed to perfect your knowledge.'
                        : 'Consider revisiting the learning materials to strengthen your understanding.',
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetGame,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 16),
                              const SizedBox(width: 8),
                              const Text('Try Another Topic'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Play Again'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
