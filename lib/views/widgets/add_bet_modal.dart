import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/bet_controller.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';

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

  double _parseCurrency(String text) {
    if (text.isEmpty) return 0.0;
    String cleaned = text.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _submitData() {
    final double amount = _parseCurrency(_amountController.text);
    final double profit = _parseCurrency(_profitController.text);

    widget.controller.addBet(
      game: _gameController.text,
      amount: amount,
      status: _selectedStatus,
      profitInput: profit,
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _gameController.dispose();
    _amountController.dispose();
    _profitController.dispose();
    super.dispose();
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(),
            ],
            decoration: const InputDecoration(labelText: AppStrings.amountFieldLabel, border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text(AppStrings.winChip),
                selected: _selectedStatus == AppStrings.statusWin,
                selectedColor: const Color(0xff1fefb4).withOpacity(0.3),
                onSelected: (val) => setState(() => _selectedStatus = AppStrings.statusWin),
              ),
              ChoiceChip(
                label: const Text(AppStrings.loseChip),
                selected: _selectedStatus == AppStrings.statusLose,
                selectedColor: const Color(0xffff4a4a).withOpacity(0.3),
                onSelected: (val) => setState(() => _selectedStatus = AppStrings.statusLose),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedStatus == AppStrings.statusWin)
            TextField(
              controller: _profitController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              decoration: const InputDecoration(labelText: AppStrings.profitFieldLabel, border: OutlineInputBorder()),
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
              child: const Text(AppStrings.saveButton, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}