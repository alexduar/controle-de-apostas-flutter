import 'package:flutter/material.dart';
import '../../controllers/bet_controller.dart';
import '../widgets/add_bet_modal.dart';
import '../../core/constants/app_strings.dart';

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
                    child: Text('Suas Apostas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _controller.bets.isEmpty
                      ? const Center(child: Text('Nenhuma aposta registrada ainda.', style: TextStyle(color: Colors.white30)))
                      : ListView.builder(
                          itemCount: _controller.bets.length,
                          itemBuilder: (ctx, index) {
                            final bet = _controller.bets[index];
                            final isWin = bet.status == 'Ganhei';
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isWin ? const Color(0xff1fefb4).withOpacity(0.2) : const Color(0xffff4a4a).withOpacity(0.2),
                                  child: Icon(
                                    isWin ? Icons.arrow_upward : Icons.arrow_downward,
                                    color: isWin ? const Color(0xff1fefb4) : const Color(0xffff4a4a),
                                  ),
                                ),
                                title: Text(bet.game, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Apostado: R\$ ${bet.amount.toStringAsFixed(2)}\n${bet.dateTime}', style: const TextStyle(height: 1.3)),
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