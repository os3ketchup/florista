import 'package:teledart/teledart.dart';
import 'package:teledart/model.dart';

void registerStartHandler(TeleDart bot) {
  bot.onCommand('start').listen((message) {
    bot.sendMessage(
      message.chat.id,
      '''
🌸 *Welcome to E-Florista!*

Your personal flower shop – fast, fresh, and full of love 💐

▫️ Indoor 🌿  
▫️ Outdoor 🌼

Type /flowers to start choosing!

''',
      parseMode: 'Markdown',
    );
  });
}
