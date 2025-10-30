part of 'generated.dart';

class ListTasksVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListTasksVariablesBuilder(this._dataConnect, );
  Deserializer<ListTasksData> dataDeserializer = (dynamic json)  => ListTasksData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListTasksData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListTasksData, void> ref() {
    
    return _dataConnect.query("ListTasks", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListTasksTasks {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final Timestamp? dueDate;
  ListTasksTasks.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  isCompleted = nativeFromJson<bool>(json['isCompleted']),
  dueDate = json['dueDate'] == null ? null : Timestamp.fromJson(json['dueDate']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksTasks otherTyped = other as ListTasksTasks;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    description == otherTyped.description && 
    isCompleted == otherTyped.isCompleted && 
    dueDate == otherTyped.dueDate;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, description.hashCode, isCompleted.hashCode, dueDate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['isCompleted'] = nativeToJson<bool>(isCompleted);
    if (dueDate != null) {
      json['dueDate'] = dueDate!.toJson();
    }
    return json;
  }

  ListTasksTasks({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.dueDate,
  });
}

@immutable
class ListTasksData {
  final List<ListTasksTasks> tasks;
  ListTasksData.fromJson(dynamic json):
  
  tasks = (json['tasks'] as List<dynamic>)
        .map((e) => ListTasksTasks.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTasksData otherTyped = other as ListTasksData;
    return tasks == otherTyped.tasks;
    
  }
  @override
  int get hashCode => tasks.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tasks'] = tasks.map((e) => e.toJson()).toList();
    return json;
  }

  ListTasksData({
    required this.tasks,
  });
}

