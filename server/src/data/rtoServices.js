// RTO Services, Forms and Official Fee Schedule (Rule 81 Central Motor Vehicles Rules)

export const RTO_SERVICES = [
  {
    id: 's1',
    name: 'Learner’s Licence (LL) Issue',
    form: 'Form 2',
    govtFee: '₹150 + ₹50 (Test fee per class of vehicle)',
    documents: [
      'Proof of Age (Aadhaar / Birth Certificate / 10th Marksheet)',
      'Proof of Address (Aadhaar / Voter ID / Passport / Electricity bill)',
      'Form 1 / Form 1A Medical Certificate (if age > 40 years or commercial)',
      'Passport size photos (uploaded online via Parivahan)'
    ],
    timeline: 'Instant (after online automated test pass)'
  },
  {
    id: 's2',
    name: 'Permanent Driving Licence (DL)',
    form: 'Form 4',
    govtFee: '₹200 (DL issuance) + ₹300 (Automated driving track test)',
    documents: [
      'Valid Learner’s Licence (minimum 30 days old)',
      'Form 5 Driving School Certificate (for Transport vehicles)',
      'Vehicle of chosen class with valid RC, Insurance, and PUC for track test'
    ],
    timeline: '7 to 15 working days by Speed Post'
  },
  {
    id: 's3',
    name: 'Transfer of Vehicle Ownership (Sale/Purchase)',
    form: 'Form 29 & Form 30',
    govtFee: 'Two Wheeler: ₹150 | Car/LMV: ₹300 + Smart card fee (₹200)',
    documents: [
      'Form 29 (Notice of Transfer) signed by seller',
      'Form 30 (Application for Intimation and Transfer) signed by both',
      'Original RC Smart Card',
      'Valid Insurance Certificate',
      'Valid PUC Certificate',
      'Buyer Address & Identity proof (Aadhaar)',
      'Chassis imprint on plain paper'
    ],
    timeline: '15 to 21 working days'
  },
  {
    id: 's4',
    name: 'Change of Address in RC',
    form: 'Form 33',
    govtFee: '₹150 (Two Wheeler) | ₹300 (Car) + ₹200 Smart card',
    documents: [
      'Original Registration Certificate (RC)',
      'New address proof (Aadhaar, Passport, Registered Rent Agreement)',
      'Valid Insurance and PUC Certificate',
      'NOC from Financier (if vehicle is under hypothecation)'
    ],
    timeline: '10 to 14 working days'
  },
  {
    id: 's5',
    name: 'Duplicate RC (Lost / Damaged / Thefts)',
    form: 'Form 26',
    govtFee: '₹150 (Two Wheeler) | ₹300 (Car) + ₹200 Smart card',
    documents: [
      'Police Non-Cognizable Report (NCR) / FIR (in case of loss/theft)',
      'Form 26 with chassis pencil print',
      'Damaged physical card (if applicable)',
      'Valid Insurance and PUC copy',
      'Aadhaar card copy of owner'
    ],
    timeline: '15 to 30 working days'
  },
  {
    id: 's6',
    name: 'Hypothecation Addition / Termination (Loan Close)',
    form: 'Form 34 (Addition) / Form 35 (Termination)',
    govtFee: 'Two Wheeler: ₹500 | Car: ₹1,500',
    documents: [
      'Form 35 in duplicate from Bank with official stamp & signature',
      'NOC letter from Bank / Financier',
      'Original RC Smart card',
      'Valid Insurance and PUC'
    ],
    timeline: '7 to 10 working days'
  },
  {
    id: 's7',
    name: 'No Objection Certificate (NOC) for Inter-State Transfer',
    form: 'Form 28',
    govtFee: '₹100 (in triplicate)',
    documents: [
      'Form 28 (4 copies with chassis pencil impression)',
      'Original RC Smart Card',
      'Clearance certificate from Traffic Police (No pending challans)',
      'Clearance from National Crime Records Bureau (NCRB) / Local Police',
      'Valid Insurance and PUC'
    ],
    timeline: '15 to 30 working days'
  }
];
