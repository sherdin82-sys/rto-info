import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// FuelRatesScreen displays petrol, diesel, and CNG rates across Indian metros.
class FuelRatesScreen extends StatelessWidget {
  const FuelRatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rates = [
      {'city': 'New Delhi', 'petrol': '₹94.72', 'diesel': '₹87.62', 'cng': '₹75.09'},
      {'city': 'Mumbai', 'petrol': '₹103.44', 'diesel': '₹89.97', 'cng': '₹79.50'},
      {'city': 'Bengaluru', 'petrol': '₹102.86', 'diesel': '₹88.94', 'cng': '₹82.50'},
      {'city': 'Chennai', 'petrol': '₹100.75', 'diesel': '₹92.34', 'cng': '₹84.00'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Fuel Rates')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final r = rates[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r['city']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Petrol: ${r['petrol']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.saffron)),
                      Text('Diesel: ${r['diesel']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.electricBlue)),
                      Text('CNG: ${r['cng']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ResaleScreen provides market valuation and loan calculator.
class ResaleScreen extends StatelessWidget {
  const ResaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resale Value & Loan EMI')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Vehicle Resale Valuation & Loan Calculator Module',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

/// RtoDirectoryScreen lists RTO offices and state designations.
class RtoDirectoryScreen extends StatelessWidget {
  const RtoDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offices = [
      {'code': 'DL-01', 'name': 'Mall Road, Civil Lines', 'state': 'Delhi'},
      {'code': 'MH-12', 'name': 'Sangam Bridge, Pune City', 'state': 'Maharashtra'},
      {'code': 'KA-05', 'name': 'Jayanagar, Bengaluru South', 'state': 'Karnataka'},
      {'code': 'HR-26', 'name': 'Gurugram North', 'state': 'Haryana'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('All-India RTO Directory')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: offices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final o = offices[index];
          return Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  o['code']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                ),
              ),
              title: Text(o['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              subtitle: Text(o['state']!, style: const TextStyle(fontSize: 11)),
            ),
          );
        },
      ),
    );
  }
}

/// TrafficSignsScreen displays traffic safety signs and penalties.
class TrafficSignsScreen extends StatelessWidget {
  const TrafficSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indian Traffic Signs Guide')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Mandatory, Cautionary, and Informatory Traffic Signs',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

/// MockExamScreen provides Learner's Licence practice test.
class MockExamScreen extends StatelessWidget {
  const MockExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RTO Mock Exam')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Parivahan Sarathi Learner’s Licence Test Simulator',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
