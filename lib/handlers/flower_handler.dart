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
  bot.onCallbackQuery().listen((query)async {
    final data = query.data;
    final chatId = query.message?.chat.id;

    // Filter only indoor/outdoor category
    if (chatId == null || data == null) return;
    if (data != 'indoor' && data != 'outdoor') return;

    bot.answerCallbackQuery(query.id); // ✅ Respond immediately

    final selectedFlowers = allFlowers.where((f) => f.type == data).toList();

    for (var flower in selectedFlowers) {
      try {
        bot.sendMessage(
          chatId,
          '''
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

      } catch (e) {
        print('❌ Failed to send photo for ${flower.name}: $e');
        await bot.sendMessage(chatId, '⚠️ Could not load image for ${flower.name}');
      }

    }
  });
}
//