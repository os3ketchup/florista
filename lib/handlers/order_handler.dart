import 'package:teledart/teledart.dart';
import 'package:teledart/model.dart';
import '../models/cart.dart';
import '../utils/flower_data.dart';

final Map<int, String> _userState = {}; // Tracks user order state

void registerOrderHandler(TeleDart bot) {
  bot.onCallbackQuery().listen((query) {
    final userId = query.from.id;
    final chatId = query.message?.chat.id;
    final data = query.data;

    if (chatId == null || data == null) return;

    // ✅ Ignore if it's flower type like "indoor" or "outdoor"
    if (data == 'indoor' || data == 'outdoor') return;

    if (data.startsWith('add_')) {
      final flowerId = data.substring(4);
      Cart.addToCart(userId, flowerId);
      bot.answerCallbackQuery(query.id, text: '✅ Added to cart');
    } else if (data.startsWith('remove_')) {
      final flowerId = data.substring(7);
      Cart.removeFromCart(userId, flowerId);
      bot.answerCallbackQuery(query.id, text: '🗑 Removed from cart');
    } else if (data == 'clear_cart') {
      Cart.clearCart(userId);
      bot.answerCallbackQuery(query.id, text: '🧹 Cart cleared');
      bot.sendMessage(chatId, '🛒 Your cart is now empty.');
    } else if (data == 'confirm_order') {
      _userState[userId] = 'awaiting_name';
      bot.answerCallbackQuery(query.id);
      bot.sendMessage(chatId, '👤 What is your *full name*?', parseMode: 'Markdown');
    } else {
      // Fallback for other unknown actions
      bot.answerCallbackQuery(query.id, text: '❓ Unknown action');
    }
  });


  bot.onCommand('cart').listen((message) {
    final userId = message.from?.id;
    final chatId = message.chat.id;

    if (userId == null) return;

    final flowerIds = Cart.getCart(userId);
    if (flowerIds.isEmpty) {
      bot.sendMessage(chatId, '🛒 Your cart is empty.');
      return;
    }

    int total = 0;
    String details = '🧾 *Your Cart:*\n\n';

    for (final id in flowerIds) {
      final flower = allFlowers.firstWhere((f) => f.id == id);
      total += flower.price;
      details += '🌸 ${flower.name} - ${flower.price} UZS\n';
    }

    details += '\n💰 *Total: $total UZS*';

    bot.sendMessage(
      chatId,
      details,
      parseMode: 'Markdown',
      replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
        [InlineKeyboardButton(text: '🧹 Clear Cart', callbackData: 'clear_cart')],
        [InlineKeyboardButton(text: '✅ Proceed to Order', callbackData: 'confirm_order')],
      ]),
    );
  });

  bot.onMessage().listen((message) {
    final userId = message.from?.id;
    final chatId = message.chat.id;
    if (userId == null) return;

    final state = _userState[userId];
    final orderInfo = Cart.getOrderInfo(userId);

    if (message.contact != null) {
      orderInfo.phone = message.contact!.phoneNumber;
      _userState[userId] = 'awaiting_location';
      bot.sendMessage(chatId, '📍 Please enter your *delivery address*:', parseMode: 'Markdown', replyMarkup: ReplyKeyboardRemove(removeKeyboard: true));
      return;
    }

    final text = message.text;
    if (text == null) return;

    if (state == 'awaiting_name') {
      orderInfo.name = text;
      _userState[userId] = 'awaiting_contact';
      bot.sendMessage(
        chatId,
        '📱 Please *share your phone number*:',
        parseMode: 'Markdown',
        replyMarkup: ReplyKeyboardMarkup(
          keyboard: [[KeyboardButton(text: '📞 Share Phone Number', requestContact: true)]],
          resizeKeyboard: true,
          oneTimeKeyboard: true,
        ),
      );
    } else if (state == 'awaiting_location') {
      orderInfo.location = text;
      _userState.remove(userId);

      final flowerIds = Cart.getCart(userId);
      int total = 0;
      String items = '';
      for (final id in flowerIds) {
        final flower = allFlowers.firstWhere((f) => f.id == id);
        total += flower.price;
        items += '🌸 ${flower.name} - ${flower.price} UZS\n';
      }

      final summary = '''
🧾 *Order Summary*
👤 Name: ${orderInfo.name}
📱 Phone: ${orderInfo.phone}
📍 Address: ${orderInfo.location}

$items
💰 *Total:* $total UZS

✅ Your order has been received!
''';

      print('\n--- ORDER RECEIVED ---');
      print(summary);

      bot.sendMessage(chatId, summary, parseMode: 'Markdown');
      Cart.clearCart(userId);
    }
  });
}
