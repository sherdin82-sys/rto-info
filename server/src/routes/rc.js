import express from 'express';
import { lookupVehicle, SEEDED_VEHICLES } from '../data/vehicles.js';

const router = express.Router();

// Search vehicle RC details by registration number
router.get('/search', (req, res) => {
  try {
    const { regNo } = req.query;
    if (!regNo) {
      return res.status(400).json({ error: 'Please provide a vehicle registration number (e.g. DL01AB1234)' });
    }

    const vehicle = lookupVehicle(regNo);
    if (!vehicle) {
      return res.status(404).json({
        error: 'Vehicle details could not be found for this registration number. Please check the plate format.'
      });
    }

    return res.json({
      success: true,
      data: vehicle
    });
  } catch (error) {
    console.error('RC search error:', error);
    return res.status(500).json({ error: 'Server error while searching vehicle details' });
  }
});

// Get sample vehicles for 1-click exploration
router.get('/samples', (req, res) => {
  const samples = Object.values(SEEDED_VEHICLES).map(v => ({
    regNo: v.regNo,
    cleanRegNo: v.cleanRegNo,
    maker: v.maker,
    model: v.model,
    fuel: v.fuel,
    vehicleClass: v.vehicleClass,
    insuranceStatus: v.insurance.status
  }));
  return res.json({ success: true, data: samples });
});

export default router;
