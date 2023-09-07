import 'package:flutter_svg/flutter_svg.dart';

extension SvgPicturePrecache on SvgPicture {
  Future<void> precache() async {
    await svg.cache.putIfAbsent(
      bytesLoader.cacheKey(null),
      () => bytesLoader.loadBytes(null),
    );
  }
}
