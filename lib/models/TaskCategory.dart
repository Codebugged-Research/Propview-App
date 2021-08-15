// To parse this JSON data, do
//
//     final taskCategory = taskCategoryFromJson(jsonString);

import 'dart:convert';

List<TaskCategory> taskCategoryFromJson(String str) => List<TaskCategory>.from(
    json.decode(str).map((x) => TaskCategory.fromJson(x)));

String taskCategoryToJson(List<TaskCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskCategory {
  TaskCategory({
    this.taskCategoryId,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  int taskCategoryId;
  String category;
  int createdAt;
  int updatedAt;

  factory TaskCategory.fromJson(Map<String, dynamic> json) => TaskCategory(
        taskCategoryId:
            json["task_category_id"] == null ? null : json["task_category_id"],
        category: json["category"] == null ? null : json["category"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "task_category_id": taskCategoryId == null ? null : taskCategoryId,
        "category": category == null ? null : category,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
