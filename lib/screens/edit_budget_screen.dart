import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/constants/app_colors.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../core/widgets/widgets.dart';

class EditBudgetScreen extends ConsumerStatefulWidget {
  const EditBudgetScreen({super.key});

  @override
  ConsumerState<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends ConsumerState<EditBudgetScreen> {
  int _weeklyBudget = 0;
  int _monthlyBudget = 0;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final provider = ref.read(transactionProvider);
      _weeklyBudget = provider.weeklyBudget;
      _monthlyBudget = provider.monthlyBudget;
      _isInit = true;
    }
  }

  Future<void> _saveBudgets() async {
    final notifier = ref.read(transactionProvider.notifier);
    await notifier.setWeeklyBudget(_weeklyBudget);
    await notifier.setMonthlyBudget(_monthlyBudget);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anggaran berhasil diperbarui!'),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CoffeeAppBar(
        title: 'Ubah Anggaran',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentukan batas pengeluaran kopi kamu agar tidak melampaui rencana finansialmu.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Monthly Budget Input
            PriceInputField(
              label: 'Anggaran Bulanan',
              initialValue: _monthlyBudget,
              hint: 'Rp 300.000',
              helperText: 'Anggaran default untuk pengeluaran sebulan',
              onChanged: (val) {
                setState(() {
                  _monthlyBudget = val;
                });
              },
            ),
            const SizedBox(height: 20),

            // Weekly Budget Input
            PriceInputField(
              label: 'Anggaran Mingguan',
              initialValue: _weeklyBudget,
              hint: 'Rp 75.000',
              helperText: 'Anggaran default untuk pengeluaran seminggu',
              onChanged: (val) {
                setState(() {
                  _weeklyBudget = val;
                });
              },
            ),
            const SizedBox(height: 36),

            // Save Button
            PrimaryButton(
              label: 'Simpan Perubahan',
              onPressed: _saveBudgets,
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Batal',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
