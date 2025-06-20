import 'package:dotenv/dotenv.dart';
import 'package:e_florista_bot/bot.dart';


Future<void> startApps() async {
  final env = DotEnv()..load();
  final token = env['BOT_TOKEN'];

  if (token == null) {
    print('❌ BOT_TOKEN not found in environment.');
    return;
  }

  await startBot(token);
}
