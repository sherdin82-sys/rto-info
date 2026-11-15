import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/loan_emi_model.dart';
import '../../../shared/widgets/premium_card.dart';

class LoanEmiScreen extends ConsumerStatefulWidget {
  const LoanEmiScreen({super.key});

  @override
  ConsumerState<LoanEmiScreen> createState() => _LoanEmiScreenState();
}

class _LoanEmiScreenState extends ConsumerState<LoanEmiScreen> {
  final _amountController = TextEditingController(text: '500000');
  final _rateController = TextEditingController(text: '9.5');
  final _tenureController = TextEditingController(text: '60');
  LoanEmiResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _calculate() {
    final principal = double.tryParse(_amountController.text) ?? 0.0;
    final annualRate = double.tryParse(_rateController.text) ?? 0.0;
    final months = int.tryParse(_tenureController.text) ?? 0;

    if (principal > 0 && annualRate > 0 && months > 0) {
      final monthlyRate = annualRate / 12 / 100;
      final emi =
          (principal * monthlyRate * pow(1 + monthlyRate, months)) /
          (pow(1 + monthlyRate, months) - 1);
      final totalPayment = emi * months;
      final totalInterest = totalPayment - principal;

      setState(() {
        _result = LoanEmiResult(
          principal: principal,
          annualInterestRate: annualRate,
          tenureMonths: months,
          monthlyEmi: emi,
          totalInterest: totalInterest,
          totalPayment: totalPayment,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'वाहन ऋण ईएमआई' : 'Vehicle Loan EMI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'ऋण का विवरण' : 'Loan Parameters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: isHindi ? 'ऋण राशि (₹)' : 'Loan Amount (₹)',
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: isHindi
                          ? 'ब्याज दर (% प्रति वर्ष)'
                          : 'Interest Rate (% p.a.)',
                      prefixIcon: const Icon(Icons.percent),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _tenureController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: isHindi ? 'अवधि (महीने)' : 'Tenure (Months)',
                      prefixIcon: const Icon(Icons.calendar_month),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (_result != null) ...[
              PremiumCard(
                backgroundColor: isDark
                    ? AppColors.darkSurfaceAlt
                    : AppColors.lightSurfaceVariant,
                borderColor: AppColors.electricBlue.withOpacity(0.4),
                child: Column(
                  children: [
                    Text(
                      isHindi ? 'मासिक ईएमआई' : 'Monthly EMI',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${_result!.monthlyEmi.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.electricBlue,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          isHindi ? 'कुल ब्याज' : 'Total Interest',
                          '₹${_result!.totalInterest.toStringAsFixed(0)}',
                          isDark,
                        ),
                        _buildStat(
                          isHindi ? 'कुल भुगतान' : 'Total Payable',
                          '₹${_result!.totalPayment.toStringAsFixed(0)}',
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
