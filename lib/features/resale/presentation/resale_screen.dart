import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../domain/models/resale_valuation_model.dart';
import '../domain/models/loan_emi_model.dart';

class ResaleScreen extends StatefulWidget {
  const ResaleScreen({super.key});

  @override
  State<ResaleScreen> createState() => _ResaleScreenState();
}

class _ResaleScreenState extends State<ResaleScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resale & Loan Calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.price_check), text: 'Resale Valuation'),
            Tab(icon: Icon(Icons.account_balance), text: 'Loan EMI'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResaleTab(),
          _buildEmiTab(),
        ],
      ),
    );
  }

  // --- Resale Tab ---

  Widget _buildResaleTab() {
    final currentYear = DateTime.now().year;
    final years = List.generate(12, (index) => currentYear - index);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('VEHICLE CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: ['Two Wheeler', 'Hatchback', 'Sedan', 'SUV', 'Electric'].map((type) {
                    final isSel = _selectedVehicleType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) {
                          setState(() => _selectedVehicleType = type);
                          _calculateResale();
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Text('ORIGINAL PURCHASE PRICE (₹)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 6),
                TextField(
                  controller: _originalPriceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateResale(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee),
                    hintText: 'e.g. 850000',
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PURCHASE YEAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<int>(
                            value: _purchaseYear,
                            items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _purchaseYear = val);
                                _calculateResale();
                              }
                            },
                            decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_month)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('KILOMETERS DRIVEN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _kmController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _calculateResale(),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.speed),
                              suffixText: 'km',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('OVERALL CONDITION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
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
        ),
        const SizedBox(height: 16),

        // Valuation Output
        if (_valuationResult != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text('ESTIMATED MARKET RESALE VALUE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  '₹${_valuationResult!.estimatedValue.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.amberAccent),
                ),
                const SizedBox(height: 10),
                Text(
                  'Expected Range: ₹${_valuationResult!.rangeLow.toStringAsFixed(0)} - ₹${_valuationResult!.rangeHigh.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _resaleStat('OVERALL DEPRECIATION', '${_valuationResult!.depreciationPercentage.toStringAsFixed(1)}%'),
                    _resaleStat('VEHICLE AGE', '${currentYear - _purchaseYear} Years'),
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
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // --- Loan EMI Tab ---

  Widget _buildEmiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('LOAN AMOUNT (₹)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 6),
                TextField(
                  controller: _loanAmountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateEmi(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee),
                    hintText: 'e.g. 600000',
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('INTEREST RATE (% P.A.)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text('${_interestRate.toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.electricBlue)),
                  ],
                ),
                Slider(
                  value: _interestRate,
                  min: 7.0,
                  max: 18.0,
                  divisions: 110,
                  onChanged: (val) {
                    setState(() => _interestRate = val);
                    _calculateEmi();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('LOAN TENURE (YEARS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text('$_tenureYears Years (${_tenureYears * 12} Mos)', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.saffron)),
                  ],
                ),
                Slider(
                  value: _tenureYears.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  onChanged: (val) {
                    setState(() => _tenureYears = val.toInt());
                    _calculateEmi();
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // EMI Output
        if (_emiResult != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B1B3D), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('MONTHLY EMI', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  '₹${_emiResult!.monthlyEmi.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.amberAccent),
                ),
                const SizedBox(height: 16),
                // Visual ratio
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      Expanded(
                        flex: (_emiResult!.principalRatio * 100).round(),
                        child: Container(height: 10, color: AppColors.electricBlue),
                      ),
                      Expanded(
                        flex: (_emiResult!.interestRatio * 100).round(),
                        child: Container(height: 10, color: AppColors.saffron),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.electricBlue, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        const Text('Principal', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.saffron, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        const Text('Interest', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _resaleStat('PRINCIPAL AMOUNT', '₹${_emiResult!.principal.toStringAsFixed(0)}'),
                    _resaleStat('TOTAL INTEREST', '₹${_emiResult!.totalInterest.toStringAsFixed(0)}'),
                    _resaleStat('TOTAL PAYMENT', '₹${_emiResult!.totalPayment.toStringAsFixed(0)}'),
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
      label: Text(label, style: const TextStyle(fontSize: 10)),
      onPressed: () {
        _loanAmountController.text = amount.toStringAsFixed(0);
        _calculateEmi();
      },
    );
  }
}
