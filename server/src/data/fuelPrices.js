// Live Fuel Prices across major Indian Metro Cities and States

export const FUEL_PRICES = [
  {
    city: 'New Delhi',
    state: 'Delhi',
    petrol: 94.72,
    diesel: 87.62,
    cng: 75.09,
    lpg: 51.20,
    changePetrol: 0.00,
    changeDiesel: 0.00,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Mumbai',
    state: 'Maharashtra',
    petrol: 103.44,
    diesel: 89.97,
    cng: 79.50,
    lpg: 54.30,
    changePetrol: -0.15,
    changeDiesel: -0.10,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Bengaluru',
    state: 'Karnataka',
    petrol: 102.86,
    diesel: 88.94,
    cng: 82.50,
    lpg: 53.80,
    changePetrol: +0.22,
    changeDiesel: +0.18,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Chennai',
    state: 'Tamil Nadu',
    petrol: 100.75,
    diesel: 92.34,
    cng: 84.00,
    lpg: 55.10,
    changePetrol: 0.00,
    changeDiesel: 0.00,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Kolkata',
    state: 'West Bengal',
    petrol: 103.94,
    diesel: 90.76,
    cng: 81.00,
    lpg: 52.90,
    changePetrol: -0.05,
    changeDiesel: -0.04,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Hyderabad',
    state: 'Telangana',
    petrol: 107.41,
    diesel: 95.65,
    cng: 89.00,
    lpg: 56.40,
    changePetrol: +0.10,
    changeDiesel: +0.08,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Ahmedabad',
    state: 'Gujarat',
    petrol: 94.44,
    diesel: 90.11,
    cng: 78.20,
    lpg: 49.80,
    changePetrol: 0.00,
    changeDiesel: 0.00,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Pune',
    state: 'Maharashtra',
    petrol: 103.98,
    diesel: 90.52,
    cng: 86.00,
    lpg: 54.10,
    changePetrol: -0.12,
    changeDiesel: -0.08,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Jaipur',
    state: 'Rajasthan',
    petrol: 104.88,
    diesel: 90.36,
    cng: 83.50,
    lpg: 53.60,
    changePetrol: 0.00,
    changeDiesel: 0.00,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    petrol: 94.65,
    diesel: 87.76,
    cng: 83.00,
    lpg: 51.50,
    changePetrol: +0.05,
    changeDiesel: +0.03,
    lastUpdated: 'Today, 06:00 AM'
  },
  {
    city: 'Chandigarh',
    state: 'Chandigarh',
    petrol: 94.24,
    diesel: 82.40,
    cng: 76.50,
    lpg: 48.90,
    changePetrol: 0.00,
    changeDiesel: 0.00,
    lastUpdated: 'Today, 06:00 AM'
  }
];

export function getAllFuelPrices() {
  return FUEL_PRICES;
}

export function getFuelPriceByCity(city) {
  if (!city) return null;
  const c = city.toLowerCase().trim();
  return FUEL_PRICES.find(p => p.city.toLowerCase().includes(c) || p.state.toLowerCase().includes(c)) || null;
}
