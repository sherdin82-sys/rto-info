import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/loan_emi_model.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
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
      appBar: AppAppBar(
        title: isHindi ? 'ऑटो ऋण ईएमआई' : 'Vehicle Loan EMI',
        subtitle: isHindi
            ? 'मासिक किस्त व ब्याज गणना'
            : 'Monthly installment calculator',
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PremiumCard(
              padding: AppSpacing.edgeInsetsL,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _amountController,
                    label: isHindi ? 'ऋण राशि (₹)' : 'Loan Amount (₹)',
                    hint: '500000',
                    prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AppTextField(
                    controller: _rateController,
                    label: isHindi
                        ? 'वार्षिक ब्याज दर (%)'
                        : 'Annual Interest Rate (%)',
                    hint: '9.5',
                    prefixIcon: const Icon(Icons.percent, size: 20),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AppTextField(
                    controller: _tenureController,
                    label: isHindi
                        ? 'अवधि (महीनों में)'
                        : 'Loan Tenure (Months)',
                    hint: '60',
                    prefixIcon: const Icon(Icons.calendar_month, size: 20),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  AppButton(
                    label: isHindi
                        ? 'ईएमआई की गणना करें'
                        : 'Calculate Monthly EMI',
                    variant: AppButtonVariant.primary,
                    onPressed: _calculate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (_result != null) ...[
              PremiumCard(
                accentColor: AppColors.electricBlue,
                padding: AppSpacing.edgeInsetsXl,
                child: Column(
                  children: [
                    Text(
                      isHindi ? 'मासिक किस्त (ईएमआई)' : 'Estimated Monthly EMI',
                      style: AppTypography.labelLarge(
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${_result!.monthlyEmi.toStringAsFixed(0)}',
                      style: AppTypography.currencyValue(
                        color: AppColors.electricBlue,
                        fontSize: 34,
                      ),
                    ),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          isHindi ? 'मूल राशि' : 'Principal',
                          '₹${_result!.principal.toStringAsFixed(0)}',
                          isDark,
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                        _buildStat(
                          isHindi ? 'कुल ब्याज' : 'Total Interest',
                          '₹${_result!.totalInterest.toStringAsFixed(0)}',
                          isDark,
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
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
          label,
          style: AppTypography.labelSmall(
            isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }
}
