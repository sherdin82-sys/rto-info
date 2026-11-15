import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import rcRouter from './routes/rc.js';
import dlRouter from './routes/dl.js';
import challanRouter from './routes/challan.js';
import rtoRouter from './routes/rto.js';
import fuelRouter from './routes/fuel.js';
import resaleRouter from './routes/resale.js';
import rulesRouter from './routes/rules.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/rc', rcRouter);
app.use('/api/dl', dlRouter);
app.use('/api/challan', challanRouter);
app.use('/api/rto', rtoRouter);
app.use('/api/fuel', fuelRouter);
app.use('/api/resale', resaleRouter);
app.use('/api/rules', rulesRouter);

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ONLINE',
    service: 'RTO INFO - Parivahan Indian Vehicle Information API',
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚗 [RTO INFO] Server running on http://localhost:${PORT}`);
});
