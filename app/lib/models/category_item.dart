import 'package:collection/collection.dart';
import 'package:wow_shopping/app/assets.dart';

enum CategoryItem {
  global(0, 'Global', Assets.categoryGlobal),
  fashion(1, 'Fashion', Assets.categoryFashion),
  phoneTablet(2, 'Phones & Tablets', Assets.categoryPhoneTablet),
  electronics(3, 'Electronics', Assets.categoryElectronics),
  computing(4, 'Computing', Assets.categoryComputing),
  homeOffice(5, 'Home Office', Assets.categoryHomeOffice),
  healthBeauty(6, 'Health Beauty', Assets.categoryHealthBeauty),
  grocery(7, 'Grocery', Assets.categoryGrocery),
  baby(8, 'Baby Products', Assets.categoryBaby),
  kettles(9, 'Kettles', Assets.categoryKettles),
  smartWatches(10, 'Smart Watches', Assets.categorySmartWatches),
  flashDrives(11, 'Flash Drives', Assets.categoryFlashDrives),
  wallMounts(12, 'Wall Mounts', Assets.categoryWallMounts),
  kitchen(13, 'Kitchen', Assets.categoryKitchen),
  audio(14, 'Speaker Systems', Assets.categoryAudio),
  other(15, 'Other', Assets.categoryOther);

  const CategoryItem(this.id, this.title, this.iconAsset);

  final int id;
  final String title;
  final String iconAsset;

  static CategoryItem? fromId(int id) {
    return CategoryItem.values.firstWhereOrNull((el) => el.id == id);
  }
}
