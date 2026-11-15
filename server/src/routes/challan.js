import express from 'express';
import { getChallansForVehicle, findChallanByNumber, payChallan } from '../data/challans.js';

const router = express.Router();

// Search challans by vehicle registration number or challan number
router.get('/search', (req, res) => {
  try {
    const { regNo, challanNo } = req.query;

    if (challanNo) {
      const challan = findChallanByNumber(challanNo);
      if (!challan) {
        return res.status(404).json({ error: 'No challan found matching this Challan Number' });
      }
      return res.json({ success: true, data: [challan] });
    }

    if (!regNo) {
      return res.status(400).json({ error: 'Please provide either a Vehicle Registration Number or Challan Number' });
    }

    const challans = getChallansForVehicle(regNo);
    const pendingTotal = challans
      .filter(c => c.status === 'PENDING')
      .reduce((sum, c) => sum + c.amount, 0);

    return res.json({
      success: true,
      data: challans,
      meta: {
        totalChallans: challans.length,
        pendingCount: challans.filter(c => c.status === 'PENDING').length,
        pendingAmount: pendingTotal
      }
    });
  } catch (error) {
    console.error('Challan search error:', error);
    return res.status(500).json({ error: 'Server error while checking challan records' });
  }
});

// Pay a challan online
router.post('/pay', (req, res) => {
  try {
    const { challanNo, paymentMode } = req.body;
    if (!challanNo) {
      return res.status(400).json({ error: 'Challan Number is required to settle payment' });
    }

    const result = payChallan(challanNo, paymentMode || 'UPI');
    if (!result.success) {
      return res.status(400).json(result);
    }

    return res.json(result);
  } catch (error) {
    console.error('Challan pay error:', error);
    return res.status(500).json({ error: 'Server error processing challan payment' });
  }
});

export default router;
