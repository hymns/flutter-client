import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/settings/settings_actions.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';

class ViewCreditList extends AbstractNavigatorAction implements PersistUI {
  ViewCreditList({
    @required NavigatorState navigator,
    this.force = false,
  }) : super(navigator: navigator);

  final bool force;
}

class ViewCredit extends AbstractNavigatorAction
    implements PersistUI, PersistPrefs {
  ViewCredit({
    @required NavigatorState navigator,
    @required this.creditId,
    this.force = false,
  }) : super(navigator: navigator);

  final String creditId;
  final bool force;
}

class EditCredit extends AbstractNavigatorAction
    implements PersistUI, PersistPrefs {
  EditCredit(
      {@required this.credit,
      @required NavigatorState navigator,
      this.completer,
      this.cancelCompleter,
      this.force = false})
      : super(navigator: navigator);

  final InvoiceEntity credit;
  final Completer completer;
  final Completer cancelCompleter;
  final bool force;
}

class UpdateCredit implements PersistUI {
  UpdateCredit(this.credit);

  final InvoiceEntity credit;
}

class LoadCredit {
  LoadCredit({this.completer, this.creditId});

  final Completer completer;
  final String creditId;
}

class LoadCreditActivity {
  LoadCreditActivity({this.completer, this.creditId});

  final Completer completer;
  final String creditId;
}

class LoadCredits {
  LoadCredits({this.completer, this.force = false});

  final Completer completer;
  final bool force;
}

class LoadCreditRequest implements StartLoading {}

class LoadCreditFailure implements StopLoading {
  LoadCreditFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadCreditFailure{error: $error}';
  }
}

class LoadCreditSuccess implements StopLoading, PersistData {
  LoadCreditSuccess(this.credit);

  final InvoiceEntity credit;

  @override
  String toString() {
    return 'LoadCreditSuccess{credit: $credit}';
  }
}

class LoadCreditsRequest implements StartLoading {}

class LoadCreditsFailure implements StopLoading {
  LoadCreditsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadCreditsFailure{error: $error}';
  }
}

class LoadCreditsSuccess implements StopLoading, PersistData {
  LoadCreditsSuccess(this.credits);

  final BuiltList<InvoiceEntity> credits;

  @override
  String toString() {
    return 'LoadCreditsSuccess{credits: $credits}';
  }
}

class SaveCreditRequest implements StartSaving {
  SaveCreditRequest({this.completer, this.credit});

  final Completer completer;
  final InvoiceEntity credit;
}

class SaveCreditSuccess implements StopSaving, PersistData, PersistUI {
  SaveCreditSuccess(this.credit);

  final InvoiceEntity credit;
}

class AddCreditSuccess implements StopSaving, PersistData, PersistUI {
  AddCreditSuccess(this.credit);

  final InvoiceEntity credit;
}

class SaveCreditFailure implements StopSaving {
  SaveCreditFailure(this.error);

  final Object error;
}

class ArchiveCreditsRequest implements StartSaving {
  ArchiveCreditsRequest(this.completer, this.creditIds);

  final Completer completer;
  final List<String> creditIds;
}

class ArchiveCreditsSuccess implements StopSaving, PersistData {
  ArchiveCreditsSuccess(this.credits);

  final List<InvoiceEntity> credits;
}

class ArchiveCreditsFailure implements StopSaving {
  ArchiveCreditsFailure(this.credits);

  final List<InvoiceEntity> credits;
}

class DeleteCreditsRequest implements StartSaving {
  DeleteCreditsRequest(this.completer, this.creditIds);

  final Completer completer;
  final List<String> creditIds;
}

class DeleteCreditsSuccess implements StopSaving, PersistData {
  DeleteCreditsSuccess(this.credits);

  final List<InvoiceEntity> credits;
}

class DeleteCreditsFailure implements StopSaving {
  DeleteCreditsFailure(this.credits);

  final List<InvoiceEntity> credits;
}

class RestoreCreditsRequest implements StartSaving {
  RestoreCreditsRequest(this.completer, this.creditIds);

  final Completer completer;
  final List<String> creditIds;
}

class RestoreCreditsSuccess implements StopSaving, PersistData {
  RestoreCreditsSuccess(this.credits);

  final List<InvoiceEntity> credits;
}

class RestoreCreditsFailure implements StopSaving {
  RestoreCreditsFailure(this.credits);

  final List<InvoiceEntity> credits;
}

class FilterCredits implements PersistUI {
  FilterCredits(this.filter);

  final String filter;
}

class SortCredits implements PersistUI {
  SortCredits(this.field);

  final String field;
}

class FilterCreditsByState implements PersistUI {
  FilterCreditsByState(this.state);

  final EntityState state;
}

class FilterCreditsByCustom1 implements PersistUI {
  FilterCreditsByCustom1(this.value);

  final String value;
}

class FilterCreditsByCustom2 implements PersistUI {
  FilterCreditsByCustom2(this.value);

  final String value;
}

class FilterCreditsByCustom3 implements PersistUI {
  FilterCreditsByCustom3(this.value);

  final String value;
}

class FilterCreditsByCustom4 implements PersistUI {
  FilterCreditsByCustom4(this.value);

  final String value;
}

class FilterCreditsByEntity implements PersistUI {
  FilterCreditsByEntity({this.entityId, this.entityType});

  final String entityId;
  final EntityType entityType;
}

void handleCreditAction(
    BuildContext context, List<BaseEntity> credits, EntityAction action) {
  if (credits.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final state = store.state;
  final CompanyEntity company = state.company;
  final localization = AppLocalization.of(context);
  final credit = credits.first as InvoiceEntity;
  final creditIds = credits.map((credit) => credit.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(context: context, entity: credit);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreCreditsRequest(
          snackBarCompleter<Null>(context, localization.restoredCredit),
          creditIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveCreditsRequest(
          snackBarCompleter<Null>(context, localization.archivedCredit),
          creditIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteCreditsRequest(
          snackBarCompleter<Null>(context, localization.deletedCredit),
          creditIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.creditListState.isInMultiselect()) {
        store.dispatch(StartCreditMultiselect(context: context));
      }

      if (credits.isEmpty) {
        break;
      }

      for (final credit in credits) {
        if (!store.state.creditListState.isSelected(credit.id)) {
          store.dispatch(
              AddToCreditMultiselect(context: context, entity: credit));
        } else {
          store.dispatch(
              RemoveFromCreditMultiselect(context: context, entity: credit));
        }
      }
      break;
  }
}

class StartCreditMultiselect {
  StartCreditMultiselect({@required this.context});

  final BuildContext context;
}

class AddToCreditMultiselect {
  AddToCreditMultiselect({@required this.context, @required this.entity});

  final BuildContext context;
  final BaseEntity entity;
}

class RemoveFromCreditMultiselect {
  RemoveFromCreditMultiselect({@required this.context, @required this.entity});

  final BuildContext context;
  final BaseEntity entity;
}

class ClearCreditMultiselect {
  ClearCreditMultiselect({@required this.context});

  final BuildContext context;
}