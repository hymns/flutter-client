import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/data/models/group_model.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';

class ViewGroupList implements PersistUI {
  ViewGroupList({@required this.context, this.force = false});

  final BuildContext context;
  final bool force;
}

class ViewGroup implements PersistUI {
  ViewGroup({
    @required this.groupId,
    @required this.context,
    this.force = false,
  });

  final String groupId;
  final BuildContext context;
  final bool force;
}

class EditGroup implements PersistUI {
  EditGroup(
      {@required this.group,
      @required this.context,
      this.completer,
      this.force = false});

  final GroupEntity group;
  final BuildContext context;
  final Completer completer;
  final bool force;
}

class UpdateGroup implements PersistUI {
  UpdateGroup(this.group);

  final GroupEntity group;
}

class LoadGroup {
  LoadGroup({this.completer, this.groupId, this.loadActivities = false});

  final Completer completer;
  final String groupId;
  final bool loadActivities;
}

class LoadGroupActivity {
  LoadGroupActivity({this.completer, this.groupId});

  final Completer completer;
  final String groupId;
}

class LoadGroups {
  LoadGroups({this.completer, this.force = false});

  final Completer completer;
  final bool force;
}

class LoadGroupRequest implements StartLoading {}

class LoadGroupFailure implements StopLoading {
  LoadGroupFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadGroupFailure{error: $error}';
  }
}

class LoadGroupSuccess implements StopLoading, PersistData {
  LoadGroupSuccess(this.group);

  final GroupEntity group;

  @override
  String toString() {
    return 'LoadGroupSuccess{group: $group}';
  }
}

class LoadGroupsRequest implements StartLoading {}

class LoadGroupsFailure implements StopLoading {
  LoadGroupsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadGroupsFailure{error: $error}';
  }
}

class LoadGroupsSuccess implements StopLoading, PersistData {
  LoadGroupsSuccess(this.groups);

  final BuiltList<GroupEntity> groups;

  @override
  String toString() {
    return 'LoadGroupsSuccess{groups: $groups}';
  }
}

class SaveGroupRequest implements StartSaving {
  SaveGroupRequest({this.completer, this.group});

  final Completer completer;
  final GroupEntity group;
}

class SaveGroupSuccess implements StopSaving, PersistData, PersistUI {
  SaveGroupSuccess(this.group);

  final GroupEntity group;
}

class AddGroupSuccess implements StopSaving, PersistData, PersistUI {
  AddGroupSuccess(this.group);

  final GroupEntity group;
}

class SaveGroupFailure implements StopSaving {
  SaveGroupFailure(this.error);

  final Object error;
}

class ArchiveGroupRequest implements StartSaving {
  ArchiveGroupRequest(this.completer, this.groupId);

  final Completer completer;
  final String groupId;
}

class ArchiveGroupSuccess implements StopSaving, PersistData {
  ArchiveGroupSuccess(this.group);

  final GroupEntity group;
}

class ArchiveGroupFailure implements StopSaving {
  ArchiveGroupFailure(this.group);

  final GroupEntity group;
}

class DeleteGroupRequest implements StartSaving {
  DeleteGroupRequest(this.completer, this.groupId);

  final Completer completer;
  final String groupId;
}

class DeleteGroupSuccess implements StopSaving, PersistData {
  DeleteGroupSuccess(this.group);

  final GroupEntity group;
}

class DeleteGroupFailure implements StopSaving {
  DeleteGroupFailure(this.group);

  final GroupEntity group;
}

class RestoreGroupRequest implements StartSaving {
  RestoreGroupRequest(this.completer, this.groupId);

  final Completer completer;
  final String groupId;
}

class RestoreGroupSuccess implements StopSaving, PersistData {
  RestoreGroupSuccess(this.group);

  final GroupEntity group;
}

class RestoreGroupFailure implements StopSaving {
  RestoreGroupFailure(this.group);

  final GroupEntity group;
}

class FilterGroups {
  FilterGroups(this.filter);

  final String filter;
}

class SortGroups implements PersistUI {
  SortGroups(this.field);

  final String field;
}

class FilterGroupsByState implements PersistUI {
  FilterGroupsByState(this.state);

  final EntityState state;
}

class FilterGroupsByCustom1 implements PersistUI {
  FilterGroupsByCustom1(this.value);

  final String value;
}

class FilterGroupsByCustom2 implements PersistUI {
  FilterGroupsByCustom2(this.value);

  final String value;
}

class FilterGroupsByEntity implements PersistUI {
  FilterGroupsByEntity({this.entityId, this.entityType});

  final String entityId;
  final EntityType entityType;
}

void handleGroupAction(
    BuildContext context, GroupEntity group, EntityAction action) {
  final store = StoreProvider.of<AppState>(context);
  final state = store.state;
  final CompanyEntity company = state.selectedCompany;
  final localization = AppLocalization.of(context);

  switch (action) {
    case EntityAction.edit:
      store.dispatch(EditGroup(context: context, group: group));
      break;
    case EntityAction.restore:
      store.dispatch(RestoreGroupRequest(
          snackBarCompleter(context, localization.restoredGroup), group.id));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveGroupRequest(
          snackBarCompleter(context, localization.archivedGroup), group.id));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteGroupRequest(
          snackBarCompleter(context, localization.deletedGroup), group.id));
      break;
  }
}