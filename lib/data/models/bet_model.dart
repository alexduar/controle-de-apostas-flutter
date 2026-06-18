class Bet {
  final String game;
  final double amount;
  final String status; // 'Ganhei' ou 'Perdi'
  final double profitOrLoss;
  final String dateTime;

  Bet({
    required this.game,
    required this.amount,
    required this.status,
    required this.profitOrLoss,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() => {
        'game': game,
        'amount': amount,
        'status': status,
        'profitOrLoss': profitOrLoss,
        'dateTime': dateTime,
      };

  factory Bet.fromMap(Map<String, dynamic> map) => Bet(
        game: map['game'],
        amount: map['amount'],
        status: map['status'],
        profitOrLoss: map['profitOrLoss'],
        dateTime: map['dateTime'],
      );
}