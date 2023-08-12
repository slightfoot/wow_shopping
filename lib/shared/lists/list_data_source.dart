import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';

abstract class ListDataSource<TItem> {
  ListDataSource() {
    commandErrors = updateDataCommand.errors;
    isFetchingNextPage = updateDataCommand.isExecuting;
  }

  /// false until the first call to [updateDataCommand] completes.
  bool get updateWasCalled;

  List<TItem> get items;
  Command<void, void> get updateDataCommand;

  ValueListenable<int> get itemCount;

  late final ValueListenable<CommandError?> commandErrors;
  late final ValueListenable<bool> isFetchingNextPage;

  TItem getItemAtIndex(int index) {
    assert(index >= 0 && index < items.length);
    return items[index];
  }

  void dispose();
}
