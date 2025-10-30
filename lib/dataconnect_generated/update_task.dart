part of 'generated.dart';

class UpdateTaskVariablesBuilder {
  String id;
  Optional<bool> _isCompleted = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateTaskVariablesBuilder isCompleted(bool? t) {
   _isCompleted.value = t;
   return this;
  }

  UpdateTaskVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateTaskData> dataDeserializer = (dynamic json)  => UpdateTaskData.fromJson(jsonDecode(json));
  Serializer<UpdateTaskVariables> varsSerializer = (UpdateTaskVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateTaskData, UpdateTaskVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateTaskData, UpdateTaskVariables> ref() {
    UpdateTaskVariables vars= UpdateTaskVariables(id: id,isCompleted: _isCompleted,);
    return _dataConnect.mutation("UpdateTask", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateTaskTaskUpdate {
  final String id;
  UpdateTaskTaskUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskTaskUpdate otherTyped = other as UpdateTaskTaskUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateTaskTaskUpdate({
    required this.id,
  });
}

@immutable
class UpdateTaskData {
  final UpdateTaskTaskUpdate? task_update;
  UpdateTaskData.fromJson(dynamic json):
  
  task_update = json['task_update'] == null ? null : UpdateTaskTaskUpdate.fromJson(json['task_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskData otherTyped = other as UpdateTaskData;
    return task_update == otherTyped.task_update;
    
  }
  @override
  int get hashCode => task_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (task_update != null) {
      json['task_update'] = task_update!.toJson();
    }
    return json;
  }

  UpdateTaskData({
    this.task_update,
  });
}

@immutable
class UpdateTaskVariables {
  final String id;
  late final Optional<bool>isCompleted;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateTaskVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    isCompleted = Optional.optional(nativeFromJson, nativeToJson);
    isCompleted.value = json['isCompleted'] == null ? null : nativeFromJson<bool>(json['isCompleted']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskVariables otherTyped = other as UpdateTaskVariables;
    return id == otherTyped.id && 
    isCompleted == otherTyped.isCompleted;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, isCompleted.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(isCompleted.state == OptionalState.set) {
      json['isCompleted'] = isCompleted.toJson();
    }
    return json;
  }

  UpdateTaskVariables({
    required this.id,
    required this.isCompleted,
  });
}

