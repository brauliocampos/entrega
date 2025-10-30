library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'list_tasks.dart';

part 'update_task.dart';

part 'delete_task.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser () {
    return CreateUserVariablesBuilder(dataConnect, );
  }
  
  
  ListTasksVariablesBuilder listTasks () {
    return ListTasksVariablesBuilder(dataConnect, );
  }
  
  
  UpdateTaskVariablesBuilder updateTask ({required String id, }) {
    return UpdateTaskVariablesBuilder(dataConnect, id: id,);
  }
  
  
  DeleteTaskVariablesBuilder deleteTask ({required String id, }) {
    return DeleteTaskVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'entrega',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

