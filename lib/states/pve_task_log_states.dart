import 'package:pve_flutter_frontend/models/pve_cluster_tasks_model.dart';

abstract class PVETaskLogState {}

class NoTaskLogsAvailable extends PVETaskLogState {}

class LoadedRecentTasks extends PVETaskLogState {
  final List<PveClusterTasksModel> tasks;

  LoadedRecentTasks(this.tasks);
}