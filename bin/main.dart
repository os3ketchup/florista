import 'package:dotenv/dotenv.dart';

import '../lib/bot.dart';

Future<void> main() async {
  final env = DotEnv()..load();
  final token = env['BOT_TOKEN'];

  if (token == null) {
    print('❌ BOT_TOKEN not found in environment.');
    return;
  }

  await startBot(token);
}
