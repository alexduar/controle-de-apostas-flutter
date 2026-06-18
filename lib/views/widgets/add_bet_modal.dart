import 'package:flutter/material.dart';
import '../../controllers/bet_controller.dart';
import '../../core/constants/app_strings.dart';

class AddBetModal extends StatefulWidget {
  final BetController controller;

  const AddBetModal({super.key, required this.controller});

  @override
  State<AddBetModal> createState() => _AddBetModalState();
}

class _AddBetModalState extends State<AddBetModal> {
  final _gameController = TextEditingController();
  final _amountController = TextEditingController();
  final _profitController = TextEditingController();
  String _selectedStatus = AppStrings.statusWin;

  void _submitData() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final double profit = double.tryParse(_profitController.text) ?? 0.0;

    widget.controller.addBet(
      game: _gameController.text,
      amount: amount,
      status: _selectedStatus,
      profitInput: profit,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.newBetTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _gameController,
            decoration: const InputDecoration(labelText: AppStrings.gameFieldName, border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: AppStrings.winChip, border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('Ganhei 🟢'),
                selected: _selectedStatus == 'Ganhei',
                selectedColor: const Color(0xff1fefb4).withOpacity(0.3),
                onSelected: (val) => setState(() => _selectedStatus = 'Ganhei'),
              ),
              ChoiceChip(
                label: const Text('Perdi 🔴'),
                selected: _selectedStatus == 'Perdi',
                selectedColor: const Color(0xffff4a4a).withOpacity(0.3),
                onSelected: (val) => setState(() => _selectedStatus = 'Perdi'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedStatus == 'Ganhei')
            TextField(
              controller: _profitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Lucro Obtido (R\$)', border: OutlineInputBorder()),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1fefb4),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _submitData,
              child: const Text('Salvar Aposta', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}