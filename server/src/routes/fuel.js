import express from 'express';
import { getAllFuelPrices, getFuelPriceByCity } from '../data/fuelPrices.js';

const router = express.Router();

// Get fuel prices for all tracked cities
router.get('/all', (req, res) => {
  return res.json({
    success: true,
    data: getAllFuelPrices(),
    nationalAverage: {
      petrol: 98.40,
      diesel: 89.20,
      cng: 81.30,
      lpg: 53.20
    }
  });
});

// Search fuel prices by city or state
router.get('/city/:name', (req, res) => {
  const price = getFuelPriceByCity(req.params.name);
  if (!price) {
    return res.status(404).json({ error: 'Fuel rate not found for specified location' });
  }
  return res.json({ success: true, data: price });
});

export default router;
