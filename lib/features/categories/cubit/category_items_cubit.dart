import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'category_items_state.dart';

class CategoryItemsCubit extends Cubit<CategoryItemsState> {
  CategoryItemsCubit() : super(CategoryItemsInitial());
}
