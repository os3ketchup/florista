import 'package:teledart/teledart.dart';
import 'package:teledart/model.dart';
import '../utils/flower_data.dart';

void registerFlowerHandler(TeleDart bot) {
  // /flowers command shows flower category buttons
  bot.onCommand('flowers').listen((message) {
    bot.sendMessage(
      message.chat.id,
      '🏡 Where will your flowers live?',
      replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
        [
          InlineKeyboardButton(text: '🪴 Indoor', callbackData: 'indoor'),
          InlineKeyboardButton(text: '🌼 Outdoor', callbackData: 'outdoor'),
        ]
      ]),
    );
  });

  // Handle flower type button clicks (indoor / outdoor)
  bot.onCallbackQuery().listen((query) {
    final data = query.data;
    final chatId = query.message?.chat.id;

    // Filter only indoor/outdoor category
    if (chatId == null || data == null) return;
    if (data != 'indoor' && data != 'outdoor') return;

    bot.answerCallbackQuery(query.id); // ✅ Respond immediately

    final selectedFlowers = allFlowers.where((f) => f.type == data).toList();

    for (var flower in selectedFlowers) {
      bot.sendPhoto(
        chatId,
        flower.imageUrl,
        caption: '''
🌸 *${flower.name}*
💬 ${flower.description}
💰 ${flower.price} UZS
''',
        parseMode: 'Markdown',
        replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
          [
            InlineKeyboardButton(
              text: '🛒 Add to Cart',
              callbackData: 'add_${flower.id}',
            ),
          ],
        ]),
      );
    }
  });
}
