import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Chess_Cleverness/services/conquest_inventory_service.dart';

/// A coin pack sold for real money.
class CoinPack {
  final String id;

  /// Coins granted on successful purchase.
  final int coins;

  /// Display price (e.g. '\$0.99').
  final String priceLabel;

  /// In-app-purchase product ID (Google Play / App Store).
  final String productId;

  /// External payment link used on the web build (Stripe / PayPal).
  /// TODO: replace placeholders with real payment links.
  final String paymentLink;

  const CoinPack({
    required this.id,
    required this.coins,
    required this.priceLabel,
    required this.productId,
    required this.paymentLink,
  });
}

/// Real-money coin packs and purchase entry points.
///
/// - Web: opens an external payment link (configure [PaymentLinks]).
/// - Android/iOS: placeholder for store billing via `in_app_purchase` —
///   activate once store products are created in the consoles.
class PurchaseService {
  PurchaseService._();

  static const packs = <CoinPack>[
    CoinPack(
      id: 'coins_500',
      coins: 500,
      priceLabel: '\$0.99',
      productId: 'shatara_coins_500',
      paymentLink: PaymentLinks.coinPack500,
    ),
    CoinPack(
      id: 'coins_1500',
      coins: 1500,
      priceLabel: '\$2.49',
      productId: 'shatara_coins_1500',
      paymentLink: PaymentLinks.coinPack1500,
    ),
    CoinPack(
      id: 'coins_5000',
      coins: 5000,
      priceLabel: '\$6.99',
      productId: 'shatara_coins_5000',
      paymentLink: PaymentLinks.coinPack5000,
    ),
  ];

  /// Starts the purchase flow for [pack].
  ///
  /// Returns a user-facing Arabic status message, or null when the flow
  /// was handed off to an external page (web payment link).
  static Future<String?> buyPack(CoinPack pack, String? uid) async {
    if (kIsWeb) {
      final uri = Uri.tryParse(pack.paymentLink);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return null; // External page opened; coins arrive after payment.
      }
      return 'رابط الدفع غير متوفر حالياً';
    }

    // Android / iOS: store billing is wired here once products exist.
    // try {
    //   final available = await InAppPurchase.instance.isAvailable();
    //   ...query productDetails for pack.productId, buyConsumable...
    //   On PurchaseStatus.purchased → ConquestInventoryService.grantCoins(...)
    // } catch (_) {}
    return 'الشراء داخل التطبيق قريباً';
  }

  /// Credits coins after a confirmed payment (e.g. payment-return deep link
  /// or store purchase callback).
  static Future<void> deliverCoins(CoinPack pack, String? uid) {
    return ConquestInventoryService.grantCoins(uid, pack.coins);
  }
}

/// External payment links for the web build.
/// TODO: replace with real Stripe Payment Links / PayPal buttons.
class PaymentLinks {
  PaymentLinks._();

  static const coinPack500 = 'https://buy.stripe.com/replace-me-500';
  static const coinPack1500 = 'https://buy.stripe.com/replace-me-1500';
  static const coinPack5000 = 'https://buy.stripe.com/replace-me-5000';
}
