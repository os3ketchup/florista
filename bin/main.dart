import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:e_florista_bot/bot.dart';


Future<void> main() async {
  String? token;

  // ✅ Use .env only if running locally
  if (Platform.environment.containsKey('RAILWAY_ENVIRONMENT')) {
    token = Platform.environment['BOT_TOKEN'];
  } else {
    final env = DotEnv()..load();
    token = env['BOT_TOKEN'];
  }

  if (token == null || token.isEmpty) {
    print('❌ BOT_TOKEN not found.');
    return;
  }

  await startBot(token);
}
//////