class Project {
  final int id;
  final String judul;
  final String deskripsi;
  final DateTime deadline;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? teamId;
  final int userId;
  final int completedChecklists;
  final List<Checklist> checklists;

  Project({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.teamId,
    required this.userId,
    required this.completedChecklists,
    required this.checklists,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      teamId: json['team_id'],
      userId: json['user_id'],
      completedChecklists: json['completed_checklists'],
      checklists: (json['checklists'] as List)
          .map((i) => Checklist.fromJson(i))
          .toList(),
    );
  }
}

class Checklist {
  final int id;
  final String judul;
  final int projectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubChecklist> subChecklists;

  Checklist({
    required this.id,
    required this.judul,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.subChecklists,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'],
      judul: json['judul'],
      projectId: json['project_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      subChecklists: (json['sub_checklists'] as List)
          .map((i) => SubChecklist.fromJson(i))
          .toList(),
    );
  }
}

class SubChecklist {
  final int id;
  final String text;
  final int completed;
  final int checklistId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubChecklist({
    required this.id,
    required this.text,
    required this.completed,
    required this.checklistId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubChecklist.fromJson(Map<String, dynamic> json) {
    return SubChecklist(
      id: json['id'],
      text: json['text'],
      completed: json['completed'],
      checklistId: json['checklist_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
