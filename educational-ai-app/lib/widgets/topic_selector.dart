import 'package:flutter/material.dart';

class TopicSelector extends StatefulWidget {
  final Function(String) onSelect;

  const TopicSelector({
    super.key,
    required this.onSelect,
  });

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  String? _selectedTopic;

  // In a real app, these would be fetched from an API based on the user's learning history
  final List<String> _topics = [
    'Mathematics',
    'Physics',
    'Biology',
    'Chemistry',
    'History',
    'Literature',
    'Computer Science',
    'Astronomy',
    'Geography',
    'Psychology',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Topics',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _topics.map((topic) {
            final isSelected = _selectedTopic == topic;
            
            return ChoiceChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTopic = selected ? topic : null;
                });
                
                if (selected) {
                  widget.onSelect(topic);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
