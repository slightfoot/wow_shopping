import 'package:server/server.dart';
import 'package:server/server/deployment.dart';

Future<void> main(List<String> args) async {
  final server = ServerApi(Deployment.dev);
  await server.start();
}
