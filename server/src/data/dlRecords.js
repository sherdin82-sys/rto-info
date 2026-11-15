// Driving Licence (DL) Database and Verification Module
// Conforms to Sarathi Parivahan standard format (e.g. DL-0420110149632, MH1420190012345)

export const SEEDED_DL_RECORDS = {
  'DL0420110149632': {
    dlNumber: 'DL-0420110149632',
    cleanDlNumber: 'DL0420110149632',
    holderName: 'RAGHAV SHARMA',
    fatherName: 'SURESH CHANDRA SHARMA',
    dob: '1990-05-14',
    bloodGroup: 'B+ Positive',
    issueDate: '2011-06-20',
    validityNonTransport: {
      from: '2011-06-20',
      to: '2030-05-13',
      status: 'ACTIVE'
    },
    validityTransport: {
      from: 'NA',
      to: 'NA',
      status: 'NOT ENDORSED'
    },
    status: 'ACTIVE / VALID',
    issuingAuthority: 'Regional Transport Office, Janakpuri, West Delhi (DL-04)',
    address: 'B-142, Janakpuri, New Delhi - 110058',
    covDetails: [
      { covCode: 'MCWG', covDescription: 'Motorcycle with Gear (Two Wheeler)', issueDate: '2011-06-20' },
      { covCode: 'LMV', covDescription: 'Light Motor Vehicle (Car / Jeep / Van)', issueDate: '2011-06-20' }
    ],
    hazardEndorsement: 'NO',
    hillEndorsement: 'YES'
  },
  'MH1420190012345': {
    dlNumber: 'MH-1420190012345',
    cleanDlNumber: 'MH1420190012345',
    holderName: 'ANIKET JOSHI',
    fatherName: 'VIKRAM JOSHI',
    dob: '1995-11-22',
    bloodGroup: 'O+ Positive',
    issueDate: '2019-03-15',
    validityNonTransport: {
      from: '2019-03-15',
      to: '2035-11-21',
      status: 'ACTIVE'
    },
    validityTransport: {
      from: 'NA',
      to: 'NA',
      status: 'NOT ENDORSED'
    },
    status: 'ACTIVE / VALID',
    issuingAuthority: 'Dy. Regional Transport Office, Pimpri Chinchwad (MH-14)',
    address: 'Nigdi Pradhikaran, Pune - 411019',
    covDetails: [
      { covCode: 'MCWG', covDescription: 'Motorcycle with Gear', issueDate: '2019-03-15' },
      { covCode: 'LMV', covDescription: 'Light Motor Vehicle', issueDate: '2019-03-15' }
    ],
    hazardEndorsement: 'NO',
    hillEndorsement: 'NO'
  }
};

// Generates realistic DL details for any DL number if not seeded
export function lookupDrivingLicence(dlNumber, dob = null) {
  if (!dlNumber) return null;
  const clean = dlNumber.toUpperCase().replace(/[^A-Z0-9]/g, '');

  if (clean.length < 9) return null;

  if (SEEDED_DL_RECORDS[clean]) {
    return SEEDED_DL_RECORDS[clean];
  }

  const stateCode = clean.substring(0, 2);
  const rtoNum = clean.substring(2, 4);
  const yearStr = clean.substring(4, 8);
  const year = parseInt(yearStr, 10) > 1980 && parseInt(yearStr, 10) <= 2026 ? parseInt(yearStr, 10) : 2018;

  const hash = clean.split('').reduce((acc, c, idx) => acc + c.charCodeAt(0) * (idx + 1), 0);
  const names = ['ADITYA VERMA', 'ROHIT DESHMUKH', 'SNEHA NAIR', 'VIKAS GUPTA', 'PRIYA PATEL', 'KAVITA SINGH', 'MANISH REDDY'];
  const fathers = ['SANJAY VERMA', 'ANAND DESHMUKH', 'RAMESH NAIR', 'MAHESH GUPTA', 'BHARAT PATEL', 'RAJENDRA SINGH', 'VENKAT REDDY'];
  const bloodGroups = ['O+', 'B+', 'A+', 'AB+', 'O-', 'A-'];

  const birthYear = year - 20;
  const birthMonth = String((hash % 12) + 1).padStart(2, '0');
  const birthDay = String((hash % 28) + 1).padStart(2, '0');
  const generatedDob = dob || `${birthYear}-${birthMonth}-${birthDay}`;

  const validUntilYear = birthYear + 50 > 2026 ? birthYear + 50 : 2035;

  return {
    dlNumber: `${stateCode}-${rtoNum}${year}${clean.substring(8) || '0098471'}`,
    cleanDlNumber: clean,
    holderName: names[hash % names.length],
    fatherName: fathers[hash % fathers.length],
    dob: generatedDob,
    bloodGroup: bloodGroups[hash % bloodGroups.length],
    issueDate: `${year}-04-16`,
    validityNonTransport: {
      from: `${year}-04-16`,
      to: `${validUntilYear}-${birthMonth}-${birthDay}`,
      status: 'ACTIVE'
    },
    validityTransport: {
      from: (hash % 3 === 0) ? `${year + 2}-01-10` : 'NA',
      to: (hash % 3 === 0) ? '2028-01-09' : 'NA',
      status: (hash % 3 === 0) ? 'ACTIVE' : 'NOT ENDORSED'
    },
    status: 'ACTIVE / VALID',
    issuingAuthority: `Regional Transport Office (${stateCode}-${rtoNum})`,
    address: `House #${(hash % 200) + 1}, Civil Lines, District Transport Office, ${stateCode}`,
    covDetails: [
      { covCode: 'MCWG', covDescription: 'Motorcycle with Gear (Two Wheeler)', issueDate: `${year}-04-16` },
      { covCode: 'LMV', covDescription: 'Light Motor Vehicle (Car / LMV)', issueDate: `${year}-04-16` },
      ...((hash % 3 === 0) ? [{ covCode: 'TRANS', covDescription: 'Transport Vehicle (Heavy/Medium)', issueDate: `${year + 2}-01-10` }] : [])
    ],
    hazardEndorsement: 'NO',
    hillEndorsement: (hash % 2 === 0) ? 'YES' : 'NO'
  };
}
