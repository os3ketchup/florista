import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'handlers/start_handler.dart';
import 'handlers/flower_handler.dart';
import 'handlers/order_handler.dart'; // 👈 NEW

late TeleDart teledart;

Future<void> startBot(String token) async {
  final telegram = Telegram(token);
  final me = await telegram.getMe();
  final username = me.username;

  teledart = TeleDart(token, Event(username!));
  teledart.start();
  print('🤖 Bot started as @$username');

  registerStartHandler(teledart);
  registerFlowerHandler(teledart);
  registerOrderHandler(teledart); // 👈 NEW
}
