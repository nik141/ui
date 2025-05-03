import 'package:flutter/material.dart';
import 'package:flutter_educational_app/widgets/feature_card.dart';
import 'package:flutter_educational_app/screens/learn_screen.dart';
import 'package:flutter_educational_app/screens/play_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Learn Smarter with AI',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ask questions, get personalized learning materials, and test your knowledge through interactive games.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Feature Cards
                FeatureCard(
                  title: 'AI Learning Assistant',
                  description: 'Ask questions about any topic and get AI-generated answers and learning materials',
                  icon: Icons.psychology,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LearnScreen()),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                FeatureCard(
                  title: 'Knowledge Games',
                  description: 'Test your understanding with interactive quizzes and games',
                  icon: Icons.gamepad,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PlayScreen()),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // How It Works Section
                Text(
                  'How It Works',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                _buildHowItWorksStep(
                  context,
                  number: '1',
                  title: 'Ask a Question',
                  description: 'Type any question about a topic you want to learn',
                ),
                
                const SizedBox(height: 16),
                
                _buildHowItWorksStep(
                  context,
                  number: '2',
                  title: 'Get Personalized Learning',
                  description: 'Receive AI-generated explanations and related materials',
                ),
                
                const SizedBox(height: 16),
                
                _buildHowItWorksStep(
                  context,
                  number: '3',
                  title: 'Test Your Knowledge',
                  description: 'Play interactive games to reinforce what you\'ve learned',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHowItWorksStep(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
