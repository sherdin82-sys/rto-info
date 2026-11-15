import express from 'express';

const router = express.Router();

// Vehicle Resale Valuation Engine based on Indian used-car market trends
router.post('/calculate', (req, res) => {
  try {
    const { vehicleType, originalPrice, purchaseYear, kmsDriven, condition, fuelType, owners } = req.body;

    const basePrice = parseFloat(originalPrice) || 800000;
    const year = parseInt(purchaseYear, 10) || 2021;
    const kms = parseInt(kmsDriven, 10) || 45000;
    const cond = condition || 'Good';
    const numOwners = parseInt(owners, 10) || 1;

    const currentYear = 2026;
    const age = Math.max(0, currentYear - year);

    // Depreciation by age: Year 1: 15%, Year 2: 25%, Year 3: 35%, Year 4: 45%, Year 5: 55%, Year 6+: +5%/yr up to 80% max
    let ageDepreciation = 0;
    if (age === 0) ageDepreciation = 0.08;
    else if (age === 1) ageDepreciation = 0.15;
    else if (age === 2) ageDepreciation = 0.25;
    else if (age === 3) ageDepreciation = 0.35;
    else if (age === 4) ageDepreciation = 0.45;
    else if (age === 5) ageDepreciation = 0.55;
    else ageDepreciation = Math.min(0.82, 0.55 + (age - 5) * 0.05);

    // Condition multiplier
    let conditionFactor = 1.0;
    if (cond === 'Excellent') conditionFactor = 1.06;
    else if (cond === 'Fair') conditionFactor = 0.90;
    else if (cond === 'Poor') conditionFactor = 0.80;

    // Mileage impact (standard is 12,000 km/year)
    const expectedKms = Math.max(10000, age * 12000);
    const kmRatio = kms / expectedKms;
    let kmFactor = 1.0;
    if (kmRatio > 1.3) kmFactor = 0.93;
    else if (kmRatio < 0.7) kmFactor = 1.04;

    // Ownership penalty
    let ownerFactor = 1.0;
    if (numOwners === 2) ownerFactor = 0.94;
    else if (numOwners >= 3) ownerFactor = 0.87;

    const fairMarketValue = Math.round(basePrice * (1 - ageDepreciation) * conditionFactor * kmFactor * ownerFactor);
    const dealerResalePrice = Math.round(fairMarketValue * 1.08); // Dealer retail
    const exchangePrice = Math.round(fairMarketValue * 0.91); // Instant showroom trade-in

    return res.json({
      success: true,
      data: {
        fairMarketValue,
        dealerResalePrice,
        exchangePrice,
        priceRange: {
          min: Math.round(fairMarketValue * 0.95),
          max: Math.round(fairMarketValue * 1.05)
        },
        depreciationPercentage: Math.round(((basePrice - fairMarketValue) / basePrice) * 100),
        estimatedDemand: fairMarketValue > 400000 ? 'High in Pre-owned Market' : 'Moderate',
        metrics: {
          ageYears: age,
          conditionFactor,
          kmFactor,
          ownerFactor
        }
      }
    });
  } catch (error) {
    console.error('Resale calculation error:', error);
    return res.status(500).json({ error: 'Failed to calculate resale valuation' });
  }
});

// Vehicle Loan EMI Calculator
router.post('/loan', (req, res) => {
  try {
    const { vehiclePrice, downPayment, interestRate, tenureMonths } = req.body;

    const price = parseFloat(vehiclePrice) || 1000000;
    const down = parseFloat(downPayment) || 200000;
    const ratePerAnnum = parseFloat(interestRate) || 8.75;
    const months = parseInt(tenureMonths, 10) || 60;

    const principal = Math.max(0, price - down);
    const monthlyRate = ratePerAnnum / (12 * 100);

    // EMI formula: P * r * (1 + r)^n / ((1 + r)^n - 1)
    let emi = 0;
    if (monthlyRate > 0) {
      emi = Math.round((principal * monthlyRate * Math.pow(1 + monthlyRate, months)) / (Math.pow(1 + monthlyRate, months) - 1));
    } else {
      emi = Math.round(principal / months);
    }

    const totalPayment = emi * months;
    const totalInterest = Math.max(0, totalPayment - principal);

    return res.json({
      success: true,
      data: {
        monthlyEmi: emi,
        principalLoanAmount: principal,
        totalInterestPayable: totalInterest,
        totalAmountPayable: totalPayment + down,
        breakdownPercentage: {
          principalRatio: Math.round((principal / totalPayment) * 100) || 0,
          interestRatio: Math.round((totalInterest / totalPayment) * 100) || 0
        }
      }
    });
  } catch (error) {
    console.error('Loan calculation error:', error);
    return res.status(500).json({ error: 'Failed to calculate loan EMI' });
  }
});

export default router;
