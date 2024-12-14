class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;
  final String category;  // Add category field
  bool isCompleted; // Menambahkan properti isCompleted untuk status selesai

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.category, // Add category to constructor
    this.isCompleted = false, // Default nilai isCompleted adalah false
  });
}
