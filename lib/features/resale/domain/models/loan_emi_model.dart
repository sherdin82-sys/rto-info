import 'dart:math';

/// Domain calculator for auto / vehicle loan EMI amortization.
class LoanEmiCalculator {
  static LoanEmiResult calculate({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    if (principal <= 0 || annualInterestRate <= 0 || tenureMonths <= 0) {
      return const LoanEmiResult(
        principal: 0,
        annualInterestRate: 0,
        tenureMonths: 0,
        monthlyEmi: 0,
        totalInterest: 0,
        totalPayment: 0,
      );
    }

    final monthlyRate = (annualInterestRate / 12) / 100;
    final numerator = principal * monthlyRate * pow(1 + monthlyRate, tenureMonths);
    final denominator = pow(1 + monthlyRate, tenureMonths) - 1;

    final monthlyEmi = numerator / denominator;
    final totalPayment = monthlyEmi * tenureMonths;
    final totalInterest = totalPayment - principal;

    return LoanEmiResult(
      principal: principal,
      annualInterestRate: annualInterestRate,
      tenureMonths: tenureMonths,
      monthlyEmi: monthlyEmi,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
    );
  }
}

class LoanEmiResult {
  final double principal;
  final double annualInterestRate;
  final int tenureMonths;
  final double monthlyEmi;
  final double totalInterest;
  final double totalPayment;

  const LoanEmiResult({
    required this.principal,
    required this.annualInterestRate,
    required this.tenureMonths,
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalPayment,
  });

  double get interestRatio => totalPayment > 0 ? (totalInterest / totalPayment) : 0;
  double get principalRatio => totalPayment > 0 ? (principal / totalPayment) : 0;
}
