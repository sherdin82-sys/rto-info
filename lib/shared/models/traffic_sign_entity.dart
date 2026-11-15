/// Domain model for Indian traffic signs per IRC & Motor Vehicles Act.
class TrafficSignEntity {
  final String id;
  final String title;
  final String category; // 'Mandatory', 'Cautionary', 'Informatory'
  final String description;
  final String shape; // 'Circle', 'Triangle', 'Rectangle', 'Octagon'
  final String? fineForViolation;

  const TrafficSignEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.shape,
    this.fineForViolation,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'shape': shape,
    'fineForViolation': fineForViolation,
  };

  factory TrafficSignEntity.fromMap(Map<String, dynamic> map) =>
      TrafficSignEntity(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        category: map['category'] ?? 'Mandatory',
        description: map['description'] ?? '',
        shape: map['shape'] ?? 'Circle',
        fineForViolation: map['fineForViolation'],
      );
}

/// Official MV Act penalty item
class TrafficFineItem {
  final String offence;
  final String section;
  final String penalty;
  final String category;

  const TrafficFineItem({
    required this.offence,
    required this.section,
    required this.penalty,
    required this.category,
  });
}
