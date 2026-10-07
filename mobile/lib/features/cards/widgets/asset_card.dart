import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../market/models/financial_history.dart';
import '../../market/models/financial_quote.dart';
import '../../market/repositories/market_repository.dart';
import '../models/asset_card_model.dart';

import 'recto/asset_card_front.dart';
import 'verso/asset_card_back.dart';

class AssetCard extends StatefulWidget {
  final AssetCardModel card;
  final int totalCards;
  final MarketRepository marketRepository;

  const AssetCard({
    super.key,
    required this.card,
    required this.totalCards,
    required this.marketRepository,
  });

  @override
  State<AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _showBack = false;

  // Quote
  FinancialQuote? _quote;
  bool _loading = false;
  Object? _error;

  // Historique / courbe
  FinancialHistory? _history;
  bool _historyLoading = false;
  Object? _historyError;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 550,
      ),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  // ---------------------------------------------------------
  // FLIP
  // ---------------------------------------------------------

  Future<void> _flip() async {
    if (!_showBack) {
      _controller.forward();

      setState(() {
        _showBack = true;
      });

      // Charge les deux en parallèle.
      if (_quote == null && !_loading) {
        unawaited(_loadQuote());
      }

      if (_history == null && !_historyLoading) {
        unawaited(_loadHistory());
      }
    } else {
      await _controller.reverse();

      if (!mounted) {
        return;
      }

      setState(() {
        _showBack = false;
      });
    }
  }

  // ---------------------------------------------------------
  // QUOTE
  // ---------------------------------------------------------

  Future<void> _loadQuote() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result =
      await widget.marketRepository.getQuote(
        widget.card.financialAssetId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _quote = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  // ---------------------------------------------------------
  // HISTORY
  // ---------------------------------------------------------

  Future<void> _loadHistory() async {
    setState(() {
      _historyLoading = true;
      _historyError = null;
    });

    try {
      final result =
      await widget.marketRepository.getHistory(
        widget.card.financialAssetId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _history = result;
        _historyLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _historyError = e;
        _historyLoading = false;
      });
    }
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.72,

      child: GestureDetector(
        onTap: _flip,

        child: AnimatedBuilder(
          animation: _animation,

          builder: (context, child) {
            final angle =
                _animation.value * math.pi;

            final showFront =
                angle < math.pi / 2;

            final transform =
            Matrix4.identity()
              ..setEntry(
                3,
                2,
                0.0014,
              )
              ..rotateY(angle);

            return Transform(
              alignment: Alignment.center,
              transform: transform,

              child: showFront
                  ? AssetCardFront(
                card: widget.card,
                totalCards:
                widget.totalCards,
              )
                  : Transform(
                alignment:
                Alignment.center,

                transform:
                Matrix4.identity()
                  ..rotateY(
                    math.pi,
                  ),

                child: AssetCardBack(
                  card: widget.card,

                  // Quote
                  quote: _quote,
                  loading: _loading,
                  error: _error,

                  // Courbe
                  history: _history,
                  historyLoading:
                  _historyLoading,
                  historyError:
                  _historyError,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}