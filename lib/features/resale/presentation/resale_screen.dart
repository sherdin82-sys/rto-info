import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/premium_card.dart';
import '../domain/models/loan_emi_model.dart';
import '../domain/models/resale_valuation_model.dart';

/// ResaleScreen calculates Indian used-car fair market value depreciation
/// and auto loan EMI amortization schedules.
class ResaleScreen extends StatefulWidget {
  const ResaleScreen({super.key});

  @override
  State<ResaleScreen> createState() => _ResaleScreenState();
}

class _ResaleScreenState extends State<ResaleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Resale Form State
  String _selectedVehicleType = 'Hatchback';
  final _originalPriceController = TextEditingController(text: '850000');
  int _purchaseYear = 2022;
  final _kmController = TextEditingController(text: '35000');
  String _condition = 'Good';
  ResaleValuationResult? _valuationResult;

  // EMI Form State
  final _loanAmountController = TextEditingController(text: '600000');
  double _interestRate = 9.5;
  int _tenureYears = 5;
  LoanEmiResult? _emiResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _calculateResale();
    _calculateEmi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _originalPriceController.dispose();
    _kmController.dispose();
    _loanAmountController.dispose();
    super.dispose();
  }

  void _calculateResale() {
    final orig = double.tryParse(_originalPriceController.text) ?? 0.0;
    final km = double.tryParse(_kmController.text) ?? 0.0;
    setState(() {
      _valuationResult = ResaleValuationCalculator.estimate(
        originalPrice: orig,
        purchaseYear: _purchaseYear,
        kmDriven: km,
        condition: _condition,
        vehicleType: _selectedVehicleType,
      );
    });
  }

  void _calculateEmi() {
    final principal = double.tryParse(_loanAmountController.text) ?? 0.0;
    setState(() {
      _emiResult = LoanEmiCalculator.calculate(
        principal: principal,
        annualInterestRate: _interestRate,
        tenureMonths: _tenureYears * 12,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppAppBar(
        title: 'Resale & Loan Calculator',
        subtitle: 'Used Vehicle Valuation & Loan EMI',
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.electricBlue,
          indicatorWeight: 3,
          labelColor: AppColors.electricBlue,
          unselectedLabelColor: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          tabs: const [
            Tab(
              icon: Icon(Icons.price_check_rounded),
              text: 'Resale Valuation',
            ),
            Tab(
              icon: Icon(Icons.account_balance_rounded),
              text: 'Auto Loan EMI',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildResaleTab(isDark), _buildEmiTab(isDark)],
      ),
    );
  }

  // --- Resale Tab ---
  Widget _buildResaleTab(bool isDark) {
    final currentYear = DateTime.now().year;
    final years = List.generate(12, (index) => currentYear - index);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        PremiumCard(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'VEHICLE CATEGORY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    [
                      'Two Wheeler',
                      'Hatchback',
                      'Sedan',
                      'SUV',
                      'Electric',
                    ].map((type) {
                      final isSel = _selectedVehicleType == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSel,
                        selectedColor: AppColors.electricBlue.withOpacity(0.2),
                        side: BorderSide(
                          color: isSel
                              ? AppColors.electricBlue
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() => _selectedVehicleType = type);
                            _calculateResale();
                          }
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'ORIGINAL ON-ROAD PRICE (₹)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _originalPriceController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.currency_rupee_rounded,
                hintText: 'e.g. 850000',
                onChanged: (_) => _calculateResale(),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PURCHASE YEAR',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          value: _purchaseYear,
                          items: years
                              .map(
                                (y) => DropdownMenuItem(
                                  value: y,
                                  child: Text('$y'),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _purchaseYear = val);
                              _calculateResale();
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.calendar_month_rounded,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.input,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KILOMETERS DRIVEN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AppTextField(
                          controller: _kmController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.speed_rounded,
                          suffixText: 'km',
                          onChanged: (_) => _calculateResale(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'OVERALL VEHICLE CONDITION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Excellent', label: Text('Excellent')),
                  ButtonSegment(value: 'Good', label: Text('Good')),
                  ButtonSegment(value: 'Fair', label: Text('Fair')),
                ],
                selected: {_condition},
                onSelectionChanged: (val) {
                  setState(() => _condition = val.first);
                  _calculateResale();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Valuation Output Card
        if (_valuationResult != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.metallicGold.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'ESTIMATED FAIR RESALE VALUE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  '₹${_valuationResult!.estimatedValue.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: AppColors.metallicGold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Expected Range: ₹${_valuationResult!.rangeLow.toStringAsFixed(0)} - ₹${_valuationResult!.rangeHigh.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(color: Colors.white24, height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _resaleStat(
                      'TOTAL DEPRECIATION',
                      '${_valuationResult!.depreciationPercentage.toStringAsFixed(1)}%',
                    ),
                    _resaleStat(
                      'VEHICLE AGE',
                      '${currentYear - _purchaseYear} Years',
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _resaleStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // --- Loan EMI Tab ---
  Widget _buildEmiTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.l),
      children: [
        PremiumCard(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PRINCIPAL LOAN AMOUNT (₹)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _loanAmountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.currency_rupee_rounded,
                hintText: 'e.g. 600000',
                onChanged: (_) => _calculateEmi(),
              ),
              const SizedBox(height: AppSpacing.s),
              // Preset loan chips
              Wrap(
                spacing: 8,
                children: [
                  _presetLoanChip('₹2 Lakh', 200000),
                  _presetLoanChip('₹5 Lakh', 500000),
                  _presetLoanChip('₹8 Lakh', 800000),
                  _presetLoanChip('₹12 Lakh', 1200000),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'INTEREST RATE (% P.A.)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    '${_interestRate.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.electricBlue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _interestRate,
                min: 7.0,
                max: 18.0,
                divisions: 110,
                activeColor: AppColors.electricBlue,
                onChanged: (val) {
                  setState(() => _interestRate = val);
                  _calculateEmi();
                },
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LOAN TENURE (YEARS)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    '$_tenureYears Years (${_tenureYears * 12} Mos)',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.saffron,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _tenureYears.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                activeColor: AppColors.saffron,
                onChanged: (val) {
                  setState(() => _tenureYears = val.toInt());
                  _calculateEmi();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // EMI Output Card
        if (_emiResult != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B1B3D), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'MONTHLY EMI',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  '₹${_emiResult!.monthlyEmi.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: AppColors.metallicGold,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                // Visual ratio
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: Row(
                    children: [
                      Expanded(
                        flex: (_emiResult!.principalRatio * 100).round(),
                        child: Container(
                          height: 10,
                          color: AppColors.electricBlue,
                        ),
                      ),
                      Expanded(
                        flex: (_emiResult!.interestRatio * 100).round(),
                        child: Container(height: 10, color: AppColors.saffron),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.electricBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Principal',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.saffron,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Interest',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _resaleStat(
                      'PRINCIPAL',
                      '₹${_emiResult!.principal.toStringAsFixed(0)}',
                    ),
                    _resaleStat(
                      'TOTAL INTEREST',
                      '₹${_emiResult!.totalInterest.toStringAsFixed(0)}',
                    ),
                    _resaleStat(
                      'TOTAL PAYMENT',
                      '₹${_emiResult!.totalPayment.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _presetLoanChip(String label, double amount) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        _loanAmountController.text = amount.toStringAsFixed(0);
        _calculateEmi();
      },
    );
  }
}
