import 'package:wow_shopping/app/assets.dart';

enum CategoryItem {
  global('Global', Assets.categoryGlobal),
  fashion('Fashion', Assets.categoryFashion),
  phoneTablet('Phones & Tablets', Assets.categoryPhoneTablet),
  electronics('Electronics', Assets.categoryElectronics),
  computing('Computing', Assets.categoryComputing),
  homeOffice('Home Office', Assets.categoryHomeOffice),
  healthBeauty('Health Beauty', Assets.categoryHealthBeauty),
  grocery('Grocery', Assets.categoryGrocery),
  baby('Baby Products', Assets.categoryBaby),
  kettles('Kettles', Assets.categoryKettles),
  smartWatches('Smart Watches', Assets.categorySmartWatches),
  flashDrives('Flash Drives', Assets.categoryFlashDrives),
  wallMounts('Wall Mounts', Assets.categoryWallMounts),
  kitchen('Kitchen', Assets.categoryKitchen),
  audio('Speaker Systems', Assets.categoryAudio),
  other('Other', Assets.categoryOther),
  ;

  const CategoryItem(this.title, this.iconAsset);

  final String title;
  final String iconAsset;
}
