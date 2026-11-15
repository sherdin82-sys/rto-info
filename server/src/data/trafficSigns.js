// Indian Traffic Signs Database (IRC & Motor Vehicles Act)

export const TRAFFIC_SIGNS = [
  // Mandatory / Regulatory Signs (Violation attracts direct fine)
  {
    id: 'M01',
    category: 'Mandatory',
    name: 'Stop Sign (Octagonal)',
    shape: 'Octagon',
    color: 'Red with White Lettering',
    meaning: 'Driver must bring vehicle to a complete halt before stop line and check traffic before moving.',
    iconName: 'OctagonAlert',
    fineUnderAct: '₹1,000 (Section 177/184)'
  },
  {
    id: 'M02',
    category: 'Mandatory',
    name: 'Give Way (Inverted Triangle)',
    shape: 'Inverted Triangle',
    color: 'White with Red Border',
    meaning: 'Yield right of way to traffic on main road or roundabout before proceeding.',
    iconName: 'Triangle',
    fineUnderAct: '₹500 (Section 177)'
  },
  {
    id: 'M03',
    category: 'Mandatory',
    name: 'No Entry / Straight Prohibited',
    shape: 'Circle',
    color: 'Red Circle with Slash / Bar',
    meaning: 'Strictly prohibited for all vehicles to enter this street or corridor.',
    iconName: 'Ban',
    fineUnderAct: '₹1,000 (Section 184 Dangerous Driving)'
  },
  {
    id: 'M04',
    category: 'Mandatory',
    name: 'Speed Limit (50 km/h)',
    shape: 'Circle',
    color: 'Red Border with Number 50',
    meaning: 'Vehicle speed must not exceed 50 km/h under any circumstances.',
    iconName: 'Gauge',
    fineUnderAct: '₹2,000 (Section 183 Speeding)'
  },
  {
    id: 'M05',
    category: 'Mandatory',
    name: 'No Parking',
    shape: 'Circle',
    color: 'Blue Circle with Red Border & Diagonal Slash',
    meaning: 'Vehicles cannot be parked in this zone; passenger drop-off briefly allowed.',
    iconName: 'CircleParking',
    fineUnderAct: '₹500 + Towing charges (Section 122/177)'
  },
  {
    id: 'M06',
    category: 'Mandatory',
    name: 'No Stopping or Standing',
    shape: 'Circle',
    color: 'Blue Circle with Red Cross (X)',
    meaning: 'Absolute prohibition of stopping even for a second.',
    iconName: 'CircleSlash2',
    fineUnderAct: '₹1,000 (Section 122)'
  },
  {
    id: 'M07',
    category: 'Mandatory',
    name: 'Overtaking Prohibited',
    shape: 'Circle',
    color: 'Red Border with Two Cars Side-by-Side',
    meaning: 'Passing other moving vehicles is dangerous and forbidden.',
    iconName: 'CarFront',
    fineUnderAct: '₹1,000 (Section 184)'
  },
  {
    id: 'M08',
    category: 'Mandatory',
    name: 'Horn Prohibited (Silent Zone)',
    shape: 'Circle',
    color: 'Red Border with Crossed Trumpet',
    meaning: 'Honking is banned near hospitals, educational institutes, and court areas.',
    iconName: 'VolumeX',
    fineUnderAct: '₹1,000 (Section 194F)'
  },

  // Cautionary / Warning Signs (Triangular with Red Border)
  {
    id: 'C01',
    category: 'Cautionary',
    name: 'Right / Left Hand Curve Ahead',
    shape: 'Upright Triangle',
    color: 'Red Border with Bent Arrow',
    meaning: 'Sharp curve ahead; reduce speed and stay within your lane.',
    iconName: 'CornerUpRight',
    fineUnderAct: 'Warning Sign'
  },
  {
    id: 'C02',
    category: 'Cautionary',
    name: 'Pedestrian Crossing Ahead',
    shape: 'Upright Triangle',
    color: 'Red Border with Walking Symbol',
    meaning: 'Zebra crossing ahead; slow down and prepare to yield to pedestrians.',
    iconName: 'Footprints',
    fineUnderAct: 'Warning Sign'
  },
  {
    id: 'C03',
    category: 'Cautionary',
    name: 'School Ahead',
    shape: 'Upright Triangle',
    color: 'Red Border with School Children Icon',
    meaning: 'Children frequently cross road; maintain lower speed (25 km/h max).',
    iconName: 'Backpack',
    fineUnderAct: 'Warning Sign'
  },
  {
    id: 'C04',
    category: 'Cautionary',
    name: 'Speed Breaker / Hump Ahead',
    shape: 'Upright Triangle',
    color: 'Red Border with Road Bumps',
    meaning: 'Speed bump ahead; decelerate smoothly to prevent vehicle damage.',
    iconName: 'Activity',
    fineUnderAct: 'Warning Sign'
  },
  {
    id: 'C05',
    category: 'Cautionary',
    name: 'Narrow Road Ahead',
    shape: 'Upright Triangle',
    color: 'Red Border with Tapering Road',
    meaning: 'Roadway reduces in width; merge into single stream safely.',
    iconName: 'ArrowDownUp',
    fineUnderAct: 'Warning Sign'
  },
  {
    id: 'C06',
    category: 'Cautionary',
    name: 'Steep Ascent / Descent',
    shape: 'Upright Triangle',
    color: 'Red Border with Gradient Slope',
    meaning: 'Steep hill incline or decline; use engine braking in lower gears.',
    iconName: 'TrendingUp',
    fineUnderAct: 'Warning Sign'
  },

  // Informatory Signs (Rectangular Blue/Green)
  {
    id: 'I01',
    category: 'Informatory',
    name: 'Hospital / Medical Aid',
    shape: 'Rectangle',
    color: 'Blue Background with White Bed & Red Cross',
    meaning: 'Emergency medical center or hospital facility available nearby.',
    iconName: 'Cross',
    fineUnderAct: 'Information Sign'
  },
  {
    id: 'I02',
    category: 'Informatory',
    name: 'Fuel / Petrol Pump',
    shape: 'Rectangle',
    color: 'Blue Background with Fuel Pump Dispenser',
    meaning: 'Fuel dispensing station located within short distance.',
    iconName: 'Fuel',
    fineUnderAct: 'Information Sign'
  },
  {
    id: 'I03',
    category: 'Informatory',
    name: 'Designated Parking Area',
    shape: 'Square / Rectangle',
    color: 'Blue Background with White Letter P',
    meaning: 'Authorized parking zone for vehicles.',
    iconName: 'ParkingSquare',
    fineUnderAct: 'Information Sign'
  },
  {
    id: 'I04',
    category: 'Informatory',
    name: 'First Aid Post',
    shape: 'Square',
    color: 'White/Blue with Green/Red Cross',
    meaning: 'First aid emergency assistance post stationed ahead.',
    iconName: 'BriefcaseMedical',
    fineUnderAct: 'Information Sign'
  }
];
