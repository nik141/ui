import 'package:flutter/material.dart';
import 'package:flutter_educational_app/models/message.dart';

class LearningMaterialsWidget extends StatelessWidget {
  final List<ChatMessage> messages;

  const LearningMaterialsWidget({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    // Get the last AI message
    final lastAiMessage = messages.lastWhere(
      (message) => !message.isUser,
      orElse: () => ChatMessage(text: '', isUser: false),
    );

    if (lastAiMessage.text.isEmpty) {
      return const Center(child: Text('No learning materials available'));
    }

    // Extract a topic from the last message (simplified)
    final topic = _extractTopic(lastAiMessage.text);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMaterialCard(
          context,
          title: 'Key Concepts',
          icon: Icons.lightbulb_outline,
          children: [
            _buildListItem(context, _generateKeyConcept(topic, 1)),
            _buildListItem(context, _generateKeyConcept(topic, 2)),
            _buildListItem(context, _generateKeyConcept(topic, 3)),
          ],
        ),
        
        const SizedBox(height: 16),
        
        _buildMaterialCard(
          context,
          title: 'Recommended Reading',
          icon: Icons.menu_book,
          children: [
            _buildLinkItem(context, _generateReading(topic, 1)),
            _buildLinkItem(context, _generateReading(topic, 2)),
          ],
        ),
        
        const SizedBox(height: 16),
        
        _buildMaterialCard(
          context,
          title: 'Video Resources',
          icon: Icons.video_library,
          children: [
            _buildLinkItem(context, _generateVideo(topic, 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildMaterialCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          )),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.link,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper functions to generate sample content
  String _extractTopic(String content) {
    // In a real app, you would use NLP to extract the main topic
    // For now, just take the first few words
    final words = content.split(' ').take(3).join(' ');
    return words.isNotEmpty ? words : 'the topic';
  }

  String _generateKeyConcept(String topic, int index) {
    final concepts = [
      'Understanding the fundamentals of $topic',
      'How $topic relates to real-world applications',
      'Advanced concepts in $topic studies',
    ];

    return index <= concepts.length ? concepts[index - 1] : 'Concept $index about $topic';
  }

  String _generateReading(String topic, int index) {
    final readings = [
      '"Introduction to $topic" - A comprehensive guide for beginners',
      '"Advanced $topic: Theory and Practice" - For deeper understanding',
    ];

    return index <= readings.length ? readings[index - 1] : 'Reading $index about $topic';
  }

  String _generateVideo(String topic, int index) {
    return '"$topic Explained" - Educational video series (45 min)';
  }
}
