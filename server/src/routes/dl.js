import express from 'express';
import { lookupDrivingLicence, SEEDED_DL_RECORDS } from '../data/dlRecords.js';

const router = express.Router();

// Verify Driving Licence
router.get('/verify', (req, res) => {
  try {
    const { dlNumber, dob } = req.query;
    if (!dlNumber) {
      return res.status(400).json({ error: 'Please enter a Driving Licence number (e.g. DL-0420110149632)' });
    }

    const record = lookupDrivingLicence(dlNumber, dob);
    if (!record) {
      return res.status(404).json({ error: 'Driving Licence record not found. Please verify the licence number.' });
    }

    return res.json({
      success: true,
      data: record
    });
  } catch (error) {
    console.error('DL verify error:', error);
    return res.status(500).json({ error: 'Server error while verifying Driving Licence' });
  }
});

// Get sample DLs for 1-click test
router.get('/samples', (req, res) => {
  const samples = Object.values(SEEDED_DL_RECORDS).map(d => ({
    dlNumber: d.dlNumber,
    holderName: d.holderName,
    dob: d.dob,
    status: d.status,
    issuingAuthority: d.issuingAuthority
  }));
  return res.json({ success: true, data: samples });
});

export default router;
