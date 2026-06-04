class IntelligenceService {
  const IntelligenceService();

  /// Suggests a title based on the content of a note.
  String? suggestTitle(String content) {
    if (content.isEmpty) return null;
    
    // Simple logic: take the first line or first 30 characters
    final lines = content.split('\n');
    final firstLine = lines.first.trim();
    if (firstLine.isNotEmpty) {
      return firstLine.length > 30 ? '${firstLine.substring(0, 27)}...' : firstLine;
    }
    return null;
  }

  /// Detects potential due dates in text (very basic implementation).
  DateTime? detectDueDate(String text) {
    final lowerText = text.toLowerCase();
    final now = DateTime.now();
    
    if (lowerText.contains('today')) {
      return DateTime(now.year, now.month, now.day, 23, 59);
    }
    if (lowerText.contains('tomorrow')) {
      final tomorrow = now.add(const Duration(days: 1));
      return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59);
    }
    if (lowerText.contains('next week')) {
      final nextWeek = now.add(const Duration(days: 7));
      return DateTime(nextWeek.year, nextWeek.month, nextWeek.day, 23, 59);
    }
    
    return null;
  }
}
