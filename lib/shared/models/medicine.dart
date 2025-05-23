/// Medicine model
class Medicine {
  /// Medicine ID
  final String id;
  
  /// Medicine name
  final String name;
  
  /// Medicine dosage
  final String dosage;
  
  /// Medicine schedule
  final String schedule;
  
  /// Medicine image URL
  final String? imageUrl;
  
  /// Medicine notes
  final String? notes;
  
  /// Medicine created at
  final DateTime createdAt;
  
  /// Medicine updated at
  final DateTime updatedAt;

  /// Constructor
  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.schedule,
    this.imageUrl,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a copy of this medicine with the given fields replaced with the new values
  Medicine copyWith({
    String? id,
    String? name,
    String? dosage,
    String? schedule,
    String? imageUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      schedule: schedule ?? this.schedule,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert medicine to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'schedule': schedule,
      'imageUrl': imageUrl,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Create medicine from map
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as String,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      schedule: map['schedule'] as String,
      imageUrl: map['imageUrl'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }
}
