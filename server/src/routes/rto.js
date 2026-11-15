import express from 'express';
import { STATE_CODES, RTO_OFFICES, findRtoByRegistration } from '../data/rtoOffices.js';

const router = express.Router();

// Get list of all states and UTs
router.get('/states', (req, res) => {
  return res.json({ success: true, data: STATE_CODES });
});

// Search and list RTO offices
router.get('/offices', (req, res) => {
  try {
    const { state, search } = req.query;
    let list = [...RTO_OFFICES];

    if (state) {
      list = list.filter(r => r.stateCode.toLowerCase() === state.toLowerCase() || r.state.toLowerCase() === state.toLowerCase());
    }

    if (search) {
      const q = search.toLowerCase().trim();
      list = list.filter(r =>
        r.code.toLowerCase().includes(q) ||
        r.city.toLowerCase().includes(q) ||
        r.location.toLowerCase().includes(q) ||
        r.state.toLowerCase().includes(q)
      );
    }

    return res.json({
      success: true,
      data: list,
      count: list.length
    });
  } catch (error) {
    console.error('RTO offices list error:', error);
    return res.status(500).json({ error: 'Server error retrieving RTO directory' });
  }
});

// Lookup RTO by plate prefix or specific code
router.get('/lookup/:code', (req, res) => {
  const { code } = req.params;
  const result = findRtoByRegistration(code);
  if (!result) {
    return res.status(404).json({ error: 'RTO Office not found for given code' });
  }
  return res.json({ success: true, data: result });
});

export default router;
