import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // In a real app, you would use a proper API endpoint
  // This is a mock implementation
  Future<String> getAiResponse(String question) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo purposes, we'll return predefined responses based on keywords
    if (question.toLowerCase().contains('math') || 
        question.toLowerCase().contains('mathematics')) {
      return '''
Mathematics is the study of numbers, quantities, and shapes. It is a fundamental discipline that plays a crucial role in many fields.

Key areas in mathematics include:
- Algebra: The study of mathematical symbols and the rules for manipulating these symbols
- Geometry: The study of shapes, sizes, relative positions of figures, and properties of space
- Calculus: The mathematical study of continuous change
- Statistics: The study of the collection, analysis, interpretation, and presentation of data

Mathematics helps develop critical thinking and problem-solving skills that are valuable in everyday life and various professions.
''';
    } else if (question.toLowerCase().contains('science') || 
               question.toLowerCase().contains('physics')) {
      return '''
Physics is the natural science that studies matter, its motion and behavior through space and time, and the related entities of energy and force.

Physics is one of the most fundamental scientific disciplines, with its main goal being to understand how the universe behaves. It covers a wide range of phenomena, from the smallest subatomic particles to the entire universe.

Key branches of physics include:
- Classical mechanics: The study of the motion of bodies under the influence of forces
- Electromagnetism: The study of electrical and magnetic phenomena
- Thermodynamics: The study of heat and temperature and their relation to energy and work
- Quantum mechanics: The study of physical phenomena at nanoscopic scales
- Relativity: The study of the relationship between space and time

Physics forms the foundation for many other sciences and has applications in numerous fields including engineering, medicine, and technology.
''';
    } else {
      return '''
I'd be happy to help you learn about this topic! 

This is an interesting subject with many facets to explore. Learning about it can help you understand related concepts and develop a broader knowledge base.

Some key points to consider:
- The fundamental principles and how they developed over time
- The practical applications in various fields
- Current research and future directions
- How this topic connects to other areas of knowledge

Would you like me to focus on any particular aspect of this topic? I can provide more specific information based on your interests.
''';
    }
  }
}
