import '../domain/models/traffic_sign_entity.dart';

class TrafficSignsData {
  static const List<TrafficSignEntity> signs = [
    // 1. Mandatory / Regulatory Signs
    TrafficSignEntity(
      id: 'm1',
      title: 'Stop',
      category: 'Mandatory',
      shape: 'Octagon',
      description: 'Driver must bring vehicle to a complete stop before the stop line and proceed only when clear.',
      fineForViolation: '₹1,000 to ₹5,000 (Jumping Signal / Stop)',
    ),
    TrafficSignEntity(
      id: 'm2',
      title: 'Give Way',
      category: 'Mandatory',
      shape: 'Inverted Triangle',
      description: 'Yield right of way to traffic on the main or intersecting road.',
      fineForViolation: '₹1,000 (Dangerous driving / Fail to yield)',
    ),
    TrafficSignEntity(
      id: 'm3',
      title: 'No Entry',
      category: 'Mandatory',
      shape: 'Circle',
      description: 'Entry of all vehicular traffic is strictly prohibited in this direction.',
      fineForViolation: '₹1,000 to ₹2,000 (Wrong way driving)',
    ),
    TrafficSignEntity(
      id: 'm4',
      title: 'Speed Limit 50',
      category: 'Mandatory',
      shape: 'Circle',
      description: 'Maximum allowable speed on this stretch is 50 km/h.',
      fineForViolation: '₹1,000 - ₹2,000 (LMV), ₹2,000 - ₹4,000 (HMV)',
    ),
    TrafficSignEntity(
      id: 'm5',
      title: 'No Parking',
      category: 'Mandatory',
      shape: 'Circle',
      description: 'Vehicles must not be parked here at any time. Towing charges apply.',
      fineForViolation: '₹500 (1st offence) / ₹1,500 + Towing',
    ),
    TrafficSignEntity(
      id: 'm6',
      title: 'No Overtaking',
      category: 'Mandatory',
      shape: 'Circle',
      description: 'Overtaking any moving vehicle is strictly prohibited on this stretch or curve.',
      fineForViolation: '₹1,000 (Improper overtaking)',
    ),
    TrafficSignEntity(
      id: 'm7',
      title: 'U-Turn Prohibited',
      category: 'Mandatory',
      shape: 'Circle',
      description: 'Taking a U-turn is strictly forbidden at this intersection or median cut.',
      fineForViolation: '₹1,000 (Illegal U-Turn)',
    ),
    TrafficSignEntity(
      id: 'm8',
      title: 'Compulsory Ahead or Turn Right',
      category: 'Mandatory',
      shape: 'Circle',
      description: 'Vehicles are required to only proceed straight or turn right.',
      fineForViolation: '₹500 - ₹1,000 (Disobeying direction)',
    ),

    // 2. Cautionary / Warning Signs
    TrafficSignEntity(
      id: 'c1',
      title: 'Right Hand Curve',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'Sharp road curve to the right ahead. Reduce speed and stay in lane.',
    ),
    TrafficSignEntity(
      id: 'c2',
      title: 'Pedestrian Crossing',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'Zebra crossing ahead. Drivers must slow down and give way to pedestrians.',
    ),
    TrafficSignEntity(
      id: 'c3',
      title: 'School Ahead',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'School zone ahead. Expect children crossing; slow down and observe strict speed limit.',
    ),
    TrafficSignEntity(
      id: 'c4',
      title: 'Speed Breaker / Bump',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'Road hump or speed breaker ahead. Decelerate to avoid vehicle damage or loss of control.',
    ),
    TrafficSignEntity(
      id: 'c5',
      title: 'Narrow Bridge Ahead',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'Carriageway narrows on approaching bridge. Allow opposing traffic to clear first.',
    ),
    TrafficSignEntity(
      id: 'c6',
      title: 'Steep Ascent',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'Steep uphill gradient ahead. Shift to lower gear to maintain traction and power.',
    ),
    TrafficSignEntity(
      id: 'c7',
      title: 'Roundabout Ahead',
      category: 'Cautionary',
      shape: 'Triangle',
      description: 'Traffic rotary/roundabout ahead. Yield to traffic already inside the circle on your right.',
    ),

    // 3. Informatory Signs
    TrafficSignEntity(
      id: 'i1',
      title: 'Hospital',
      category: 'Informatory',
      shape: 'Rectangle',
      description: 'Medical facility / hospital located nearby. No honking zone.',
    ),
    TrafficSignEntity(
      id: 'i2',
      title: 'Petrol Pump',
      category: 'Informatory',
      shape: 'Rectangle',
      description: 'Fuel filling station available along the road ahead.',
    ),
    TrafficSignEntity(
      id: 'i3',
      title: 'Parking Area - Cars',
      category: 'Informatory',
      shape: 'Rectangle',
      description: 'Designated parking spot for four-wheeler passenger cars.',
    ),
    TrafficSignEntity(
      id: 'i4',
      title: 'First Aid Post',
      category: 'Informatory',
      shape: 'Rectangle',
      description: 'Emergency first aid post accessible along highway.',
    ),
    TrafficSignEntity(
      id: 'i5',
      title: 'Eating Place',
      category: 'Informatory',
      shape: 'Rectangle',
      description: 'Highway restaurant / refreshment stop ahead.',
    ),
  ];

  static const List<TrafficFineItem> fines = [
    TrafficFineItem(
      offence: 'Driving without Valid Driving Licence',
      section: 'Section 181 MV Act',
      penalty: '₹5,000 fine and/or imprisonment upto 3 months',
      category: 'Licence & Registration',
    ),
    TrafficFineItem(
      offence: 'Driving without Valid Vehicle Insurance',
      section: 'Section 196 MV Act',
      penalty: '₹2,000 (1st) / ₹4,000 + upto 3 months jail (subsequent)',
      category: 'Licence & Registration',
    ),
    TrafficFineItem(
      offence: 'Driving without Helmet (Two-Wheeler)',
      section: 'Section 194D MV Act',
      penalty: '₹1,000 fine + 3 months DL disqualification',
      category: 'Safety Violations',
    ),
    TrafficFineItem(
      offence: 'Driving without Seatbelt',
      section: 'Section 194B MV Act',
      penalty: '₹1,000 fine',
      category: 'Safety Violations',
    ),
    TrafficFineItem(
      offence: 'Drunken Driving / Under Alcohol Influence',
      section: 'Section 185 MV Act',
      penalty: '₹10,000 and/or 6 months jail (1st) / ₹15,000 & 2 years (2nd)',
      category: 'Serious Offence',
    ),
    TrafficFineItem(
      offence: 'Over-speeding (Excess of Speed Limit)',
      section: 'Section 183 MV Act',
      penalty: '₹1,000 - ₹2,000 (LMV), ₹2,000 - ₹4,000 (Commercial)',
      category: 'Traffic Rules',
    ),
    TrafficFineItem(
      offence: 'Red Light Jumping / Signal Violation',
      section: 'Section 184 MV Act',
      penalty: '₹1,000 - ₹5,000 and/or 6-12 months imprisonment',
      category: 'Traffic Rules',
    ),
    TrafficFineItem(
      offence: 'Using Mobile Phone While Driving',
      section: 'Section 184(c) MV Act',
      penalty: '₹1,000 - ₹5,000 fine',
      category: 'Safety Violations',
    ),
    TrafficFineItem(
      offence: 'Blocking Emergency Vehicles (Ambulance/Fire)',
      section: 'Section 194E MV Act',
      penalty: '₹10,000 fine and/or imprisonment upto 6 months',
      category: 'Serious Offence',
    ),
    TrafficFineItem(
      offence: 'Driving without Valid PUC Certificate',
      section: 'Section 190(2) MV Act',
      penalty: '₹10,000 fine and/or 3 months imprisonment',
      category: 'Licence & Registration',
    ),
  ];
}
