import 'package:flutter/material.dart';

import 'core/api/api_client.dart';
import 'features/cards/pages/cards_page.dart';
import 'features/cards/repositories/card_repository.dart';
import 'features/market/repositories/market_repository.dart';

void main() {
  final apiClient = ApiClient();

  final cardRepository =
  CardRepository(
    apiClient: apiClient,
  );

  final marketRepository =
  MarketRepository(
    apiClient: apiClient,
  );

  runApp(
    VestoryApp(
      cardRepository:
      cardRepository,
      marketRepository:
      marketRepository,
    ),
  );
}

class VestoryApp extends StatelessWidget {
  final CardRepository cardRepository;
  final MarketRepository marketRepository;

  const VestoryApp({
    super.key,
    required this.cardRepository,
    required this.marketRepository,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Vestory',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      home: CardsPage(
        cardRepository: cardRepository,
        marketRepository: marketRepository,
      ),
    );
  }
}