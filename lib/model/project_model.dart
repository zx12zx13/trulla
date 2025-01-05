import 'package:intl/intl.dart';

class Project {
  int id;
  String judul;
  String deskripsi;
  DateTime deadline;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int? teamId;
  int userId;
  List<Checklist> checklists;

  int get completedChecklists {
    int count = 0;
    for (var i = 0; i < checklists.length; i++) {
      if (checklists[i].subChecklists.isNotEmpty &&
          checklists[i].completedSubChecklists ==
              checklists[i].subChecklists.length) {
        count++;
      }
    }

    return count;
  }

  double get progress {
    double rawProgress =
        checklists.isEmpty ? 0.0 : (completedChecklists / checklists.length);
    return double.parse(
        rawProgress.toStringAsFixed(1)); // Limit to 1 decimal place
  }

  // Example: 04 January 2025, 18:00
  String get formattedDeadline {
    return DateFormat('dd MMMM yyyy, HH:mm').format(deadline);
  }

  String get statusText {
    switch (status) {
      case 'ongoing':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'canceled':
        return 'Canceled';
      default:
        return 'Ongoing';
    }
  }

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
      checklists: (json['checklists'] as List)
          .map((i) => Checklist.fromJson(i))
          .toList(),
    );
  }
}

class Checklist {
  int id;
  String judul;
  int projectId;
  DateTime createdAt;
  DateTime updatedAt;
  List<SubChecklist> subChecklists;
  int get completedSubChecklists =>
      subChecklists.where((sub) => sub.completed == 1).length;

  double get progress {
    double rawProgress = subChecklists.isEmpty
        ? 0.0 // Default if subChecklists is empty
        : (completedSubChecklists / subChecklists.length);
    return double.parse(
        rawProgress.toStringAsFixed(1)); // Limit to 1 decimal place
  }

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
      subChecklists: (json['sub_checklists'] as List?)
              ?.map((i) => SubChecklist.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class SubChecklist {
  int id;
  String text;
  int completed;
  int checklistId;
  DateTime createdAt;
  DateTime updatedAt;

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
      completed: json['completed'] ?? 0,
      checklistId: json['checklist_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
