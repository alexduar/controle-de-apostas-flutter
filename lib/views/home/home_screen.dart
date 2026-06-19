import 'package:flutter/material.dart';
import '../../controllers/bet_controller.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/add_bet_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BetController _controller = BetController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openAddBetModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1e1e1e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddBetModal(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = _controller.totalBalance;
    
    // Pegamos os dados já separados por dia do nosso controller
    final groupedBets = _controller.betsGroupedByDate;
    final dates = groupedBets.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Painel de Saldo Geral (Geral de todo o histórico)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff1e1e1e),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: totalBalance >= 0 ? const Color(0xff1fefb4) : const Color(0xffff4a4a),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.totalBalance, style: TextStyle(color: Colors.grey, fontSize: 16)),
                          SizedBox(height: 5),
                          Text(AppStrings.accumulatedHistory, style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      Text(
                        '${totalBalance >= 0 ? "+" : ""} R\$ ${totalBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: totalBalance >= 0 ? const Color(0xff1fefb4) : const Color(0xffff4a4a),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppStrings.yourBets, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                // LISTA ESTILO EXTRATO BANCÁRIO
                Expanded(
                  child: groupedBets.isEmpty
                      ? const Center(child: Text(AppStrings.noBetsRegistered, style: TextStyle(color: Colors.white30)))
                      : ListView.builder(
                          itemCount: dates.length,
                          itemBuilder: (ctx, dateIndex) {
                            final date = dates[dateIndex];
                            final dayBets = groupedBets[date]!;

                            // Calcula o resumo/saldo específico deste dia
                            double dayBalance = dayBets.fold(0, (sum, item) => sum + item.profitOrLoss);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SEÇÃO DE DIAS (Cabeçalho do Extrato)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        date, // Data do grupo (ex: 18/06/2026)
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 14),
                                      ),
                                      // Resumo de lucro/perda do dia do extrato
                                      Text(
                                        'Saldo do dia: ${dayBalance >= 0 ? "+" : ""} R\$ ${dayBalance.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: dayBalance >= 0 ? const Color(0xff1fefb4).withOpacity(0.8) : const Color(0xffff4a4a).withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // APOSTAS DAQUELE DIA ESPECÍFICO
                                ...dayBets.map((bet) {
                                  final isWin = bet.status == AppStrings.statusWin;

                                  return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: const Color(0xffff4a4a).withOpacity(0.8),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    onDismissed: (direction) {
                                      _controller.deleteBet(bet);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${bet.game} ${AppStrings.betRemovedFeedback}'),
                                          backgroundColor: Colors.grey[900],
                                        ),
                                      );
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: isWin
                                              ? const Color(0xff1fefb4).withOpacity(0.2)
                                              : const Color(0xffff4a4a).withOpacity(0.2),
                                          child: Icon(
                                            isWin ? Icons.arrow_upward : Icons.arrow_downward,
                                            color: isWin ? const Color(0xff1fefb4) : const Color(0xffff4a4a),
                                          ),
                                        ),
                                        title: Text(bet.game, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        // Mostra apenas a hora no subtitle já que o dia está no topo
                                        subtitle: Text('${AppStrings.betAmountLabel} ${bet.amount.toStringAsFixed(2)} • ${bet.dateTime.split(' ')[1]}', style: const TextStyle(height: 1.3)),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${isWin ? "+" : ""} R\$ ${bet.profitOrLoss.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: isWin ? const Color(0xff1fefb4) : const Color(0xffff4a4a),
                                              ),
                                            ),
                                            Text(
                                              bet.status,
                                              style: TextStyle(fontSize: 11, color: isWin ? const Color(0xff1fefb4) : const Color(0xffff4a4a)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1fefb4),
        foregroundColor: Colors.black,
        onPressed: _openAddBetModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}