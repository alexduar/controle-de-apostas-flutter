import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/bet_model.dart';
import '../data/services/storage_service.dart';

class BetController extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  final List<Bet> _bets = [];
  List<Bet> get bets => List.unmodifiable(_bets);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get totalBalance => _bets.fold(0, (sum, item) => sum + item.profitOrLoss);

  // NOVO: Agrupa as apostas por data (DD/MM/AAAA) para facilitar o extrato na View
  Map<String, List<Bet>> get betsGroupedByDate {
    final Map<String, List<Bet>> groups = {};
    for (var bet in _bets) {
      // Pega apenas a parte da data (ex: "18/06/2026") ignorando o horário
      String dateKey = bet.dateTime.split(' ')[0]; 
      if (groups[dateKey] == null) {
        groups[dateKey] = [];
      }
      groups[dateKey]!.add(bet);
    }
    return groups;
  }

  BetController() {
    loadBets();
  }

  Future<void> loadBets() async {
    _isLoading = true;
    notifyListeners();

    final String? betsString = await _storageService.getBets();
    if (betsString != null) {
      final List<dynamic> decoded = jsonDecode(betsString);
      _bets.clear();
      _bets.addAll(decoded.map((item) => Bet.fromMap(item)).toList());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBet({
    required String game,
    required double amount,
    required String status,
    required double profitInput,
  }) async {
    if (game.isEmpty || amount <= 0) return;

    double finalProfitOrLoss = status == 'Ganhei' ? profitInput : -amount;
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    final newBet = Bet(
      game: game,
      amount: amount,
      status: status,
      profitOrLoss: finalProfitOrLoss,
      dateTime: formattedDate,
    );

    _bets.insert(0, newBet);
    notifyListeners();

    await _saveToStorage();
  }

  Future<void> deleteBet(Bet bet) async {
    _bets.remove(bet);
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    final String encoded = jsonEncode(_bets.map((b) => b.toMap()).toList());
    await _storageService.saveBets(encoded);
  }
}