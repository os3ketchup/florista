import 'package:teledart/teledart.dart';
import 'package:teledart/model.dart';
import '../utils/flower_data.dart';

void registerFlowerHandler(TeleDart bot) {
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

  bot.onCallbackQuery().listen((query) {
    final data = query.data;
    final chatId = query.message?.chat.id;

    if (chatId == null || data == null) return;

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

    bot.answerCallbackQuery(query.id);
  });
}
