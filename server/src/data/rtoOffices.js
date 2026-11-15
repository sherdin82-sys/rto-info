// All-India RTO Office Directory and State Database
export const STATE_CODES = [
  { code: 'AN', name: 'Andaman and Nicobar Islands', capital: 'Port Blair' },
  { code: 'AP', name: 'Andhra Pradesh', capital: 'Amaravati' },
  { code: 'AR', name: 'Arunachal Pradesh', capital: 'Itanagar' },
  { code: 'AS', name: 'Assam', capital: 'Dispur' },
  { code: 'BR', name: 'Bihar', capital: 'Patna' },
  { code: 'CH', name: 'Chandigarh', capital: 'Chandigarh' },
  { code: 'CG', name: 'Chhattisgarh', capital: 'Raipur' },
  { code: 'DD', name: 'Daman and Diu', capital: 'Daman' },
  { code: 'DL', name: 'Delhi', capital: 'New Delhi' },
  { code: 'DN', name: 'Dadra and Nagar Haveli', capital: 'Silvassa' },
  { code: 'GA', name: 'Goa', capital: 'Panaji' },
  { code: 'GJ', name: 'Gujarat', capital: 'Gandhinagar' },
  { code: 'HR', name: 'Haryana', capital: 'Chandigarh' },
  { code: 'HP', name: 'Himachal Pradesh', capital: 'Shimla' },
  { code: 'JH', name: 'Jharkhand', capital: 'Ranchi' },
  { code: 'JK', name: 'Jammu and Kashmir', capital: 'Srinagar / Jammu' },
  { code: 'KA', name: 'Karnataka', capital: 'Bengaluru' },
  { code: 'KL', name: 'Kerala', capital: 'Thiruvananthapuram' },
  { code: 'LA', name: 'Ladakh', capital: 'Leh' },
  { code: 'LD', name: 'Lakshadweep', capital: 'Kavaratti' },
  { code: 'MP', name: 'Madhya Pradesh', capital: 'Bhopal' },
  { code: 'MH', name: 'Maharashtra', capital: 'Mumbai' },
  { code: 'MN', name: 'Manipur', capital: 'Imphal' },
  { code: 'ML', name: 'Meghalaya', capital: 'Shillong' },
  { code: 'MZ', name: 'Mizoram', capital: 'Aizawl' },
  { code: 'NL', name: 'Nagaland', capital: 'Kohima' },
  { code: 'OD', name: 'Odisha', capital: 'Bhubaneswar' },
  { code: 'PB', name: 'Punjab', capital: 'Chandigarh' },
  { code: 'PY', name: 'Puducherry', capital: 'Puducherry' },
  { code: 'RJ', name: 'Rajasthan', capital: 'Jaipur' },
  { code: 'SK', name: 'Sikkim', capital: 'Gangtok' },
  { code: 'TN', name: 'Tamil Nadu', capital: 'Chennai' },
  { code: 'TS', name: 'Telangana', capital: 'Hyderabad' },
  { code: 'TR', name: 'Tripura', capital: 'Agartala' },
  { code: 'UP', name: 'Uttar Pradesh', capital: 'Lucknow' },
  { code: 'UK', name: 'Uttarakhand', capital: 'Dehradun' },
  { code: 'WB', name: 'West Bengal', capital: 'Kolkata' },
];

export const RTO_OFFICES = [
  // Delhi (DL)
  { code: 'DL-01', stateCode: 'DL', state: 'Delhi', city: 'North Delhi', location: 'Mall Road, Civil Lines', address: 'Transport Department, 5/9 Under Hill Road, Mall Road, Delhi - 110054', phone: '011-23930811', email: 'dtnorth@nic.in' },
  { code: 'DL-02', stateCode: 'DL', state: 'Delhi', city: 'New Delhi', location: 'IP Estate / Tilak Marg', address: 'Transport Dept, PCO Building, Tilak Marg, New Delhi - 110001', phone: '011-23378516', email: 'dtcentral@nic.in' },
  { code: 'DL-03', stateCode: 'DL', state: 'Delhi', city: 'South Delhi', location: 'Sheikh Sarai', address: 'DDA Market, Phase-II, Sheikh Sarai, New Delhi - 110017', phone: '011-29251810', email: 'dtsouth@nic.in' },
  { code: 'DL-04', stateCode: 'DL', state: 'Delhi', city: 'West Delhi (1)', location: 'Janakpuri', address: 'Block C, Janakpuri, New Delhi - 110058', phone: '011-25556214', email: 'dtwest1@nic.in' },
  { code: 'DL-05', stateCode: 'DL', state: 'Delhi', city: 'North East Delhi', location: 'Loni Road', address: 'Loni Road, Shahdara, Delhi - 110032', phone: '011-22811453', email: 'dtne@nic.in' },
  { code: 'DL-06', stateCode: 'DL', state: 'Delhi', city: 'Central Delhi', location: 'Sarai Kale Khan', address: 'Near ISBT, Sarai Kale Khan, New Delhi - 110013', phone: '011-24355325', email: 'dtse@nic.in' },
  { code: 'DL-07', stateCode: 'DL', state: 'Delhi', city: 'East Delhi (1)', location: 'Mayur Vihar', address: 'Mayur Vihar Phase-1, Delhi - 110091', phone: '011-22752109', email: 'dteast@nic.in' },
  { code: 'DL-08', stateCode: 'DL', state: 'Delhi', city: 'North West Delhi (1)', location: 'Wazirpur', address: 'Ashok Vihar, Wazirpur Industrial Area, Delhi - 110052', phone: '011-27376363', email: 'dtnw1@nic.in' },
  { code: 'DL-09', stateCode: 'DL', state: 'Delhi', city: 'South West Delhi (1)', location: 'Palam / Janakpuri', address: 'Dwarka Sector 10, New Delhi - 110075', phone: '011-28082910', email: 'dtsw1@nic.in' },
  { code: 'DL-10', stateCode: 'DL', state: 'Delhi', city: 'West Delhi (2)', location: 'Raja Garden', address: 'Ring Road, Raja Garden, New Delhi - 110027', phone: '011-25164800', email: 'dtwest2@nic.in' },
  { code: 'DL-11', stateCode: 'DL', state: 'Delhi', city: 'North West Delhi (2)', location: 'Rohini', address: 'Sector 16, Rohini, Delhi - 110085', phone: '011-27891230', email: 'dtrohini@nic.in' },
  { code: 'DL-12', stateCode: 'DL', state: 'Delhi', city: 'South West Delhi (2)', location: 'Vasant Vihar', address: 'DTC Depot, Vasant Vihar, New Delhi - 110057', phone: '011-26154321', email: 'dtsw2@nic.in' },
  { code: 'DL-13', stateCode: 'DL', state: 'Delhi', city: 'East Delhi (2)', location: 'Surajmal Vihar', address: 'CBD Ground, Surajmal Vihar, Delhi - 110092', phone: '011-22302324', email: 'dtsurajmal@nic.in' },

  // Maharashtra (MH)
  { code: 'MH-01', stateCode: 'MH', state: 'Maharashtra', city: 'Mumbai Central', location: 'Tardeo', address: 'Old Bodyguard Lane, Tulsiwadi, Tardeo, Mumbai - 400034', phone: '022-23532333', email: 'rto.mumbaicentral-mh@gov.in' },
  { code: 'MH-02', stateCode: 'MH', state: 'Maharashtra', city: 'Mumbai West', location: 'Andheri', address: 'D/111, Ambawadi, S.V. Road, Andheri West, Mumbai - 400053', phone: '022-26366952', email: 'rto.mumbaiwest-mh@gov.in' },
  { code: 'MH-03', stateCode: 'MH', state: 'Maharashtra', city: 'Mumbai East', location: 'Wadala', address: 'B/2, 3rd Floor, Truck Terminal, Wadala, Mumbai - 400037', phone: '022-24036472', email: 'rto.mumbaieast-mh@gov.in' },
  { code: 'MH-04', stateCode: 'MH', state: 'Maharashtra', city: 'Thane', location: 'Thane West', address: 'Opp. Central Jail, Court Naka, Thane West - 400601', phone: '022-25363838', email: 'rto.thane-mh@gov.in' },
  { code: 'MH-05', stateCode: 'MH', state: 'Maharashtra', city: 'Kalyan', location: 'Kalyan', address: 'Sahyadri Nagar, Rambaug, Kalyan West - 421301', phone: '0251-2200234', email: 'rto.kalyan-mh@gov.in' },
  { code: 'MH-12', stateCode: 'MH', state: 'Maharashtra', city: 'Pune', location: 'Sangam Bridge, Pune City', address: 'Near Sangam Bridge, Raja Bahadur Mill Road, Pune - 411001', phone: '020-26058080', email: 'rto.pune-mh@gov.in' },
  { code: 'MH-14', stateCode: 'MH', state: 'Maharashtra', city: 'Pimpri-Chinchwad', location: 'Nigdi / Bhosari', address: 'Sector 17, Chikhali Pradhikaran, Nigdi, Pimpri-Chinchwad - 411019', phone: '020-27650888', email: 'rto.pcmc-mh@gov.in' },
  { code: 'MH-20', stateCode: 'MH', state: 'Maharashtra', city: 'Chhatrapati Sambhajinagar', location: 'Railway Station Road', address: 'Near Railway Station, Chhatrapati Sambhajinagar - 431005', phone: '0240-2331580', email: 'rto.aurangabad-mh@gov.in' },
  { code: 'MH-31', stateCode: 'MH', state: 'Maharashtra', city: 'Nagpur Urban', location: 'Civil Lines', address: 'Opp. Giripeth Post Office, Civil Lines, Nagpur - 440001', phone: '0712-2561698', email: 'rto.nagpur-mh@gov.in' },
  { code: 'MH-43', stateCode: 'MH', state: 'Maharashtra', city: 'Navi Mumbai', location: 'Vashi', address: 'Sector 19B, APMC Market, Vashi, Navi Mumbai - 400705', phone: '022-27882200', email: 'rto.navimumbai-mh@gov.in' },
  { code: 'MH-47', stateCode: 'MH', state: 'Maharashtra', city: 'Mumbai North', location: 'Borivali', address: 'Link Road, Dahisar West, Mumbai - 400068', phone: '022-28926002', email: 'rto.borivali-mh@gov.in' },

  // Karnataka (KA)
  { code: 'KA-01', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru Central', location: 'Koramangala', address: 'B Block, 3rd Floor, BMTC Building, Koramangala, Bengaluru - 560034', phone: '080-25533525', email: 'rtobangalorec-ka@nic.in' },
  { code: 'KA-02', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru West', location: 'Rajajinagar', address: 'Opp. BMTC Bus Depot, 2nd Block, Rajajinagar, Bengaluru - 560010', phone: '080-23324390', email: 'rtobangalorew-ka@nic.in' },
  { code: 'KA-03', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru East', location: 'Indiranagar / Kasturinagar', address: '2nd Main Road, Kasturinagar, Bengaluru - 560043', phone: '080-25424567', email: 'rtobangaloree-ka@nic.in' },
  { code: 'KA-04', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru North', location: 'Yeshwanthpur', address: 'Subhash Nagar, Yeshwanthpur, Bengaluru - 560022', phone: '080-23376039', email: 'rtobangaloren-ka@nic.in' },
  { code: 'KA-05', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru South', location: 'Jayanagar', address: '9th Main, 4th Block, Jayanagar, Bengaluru - 560011', phone: '080-26630800', email: 'rtobangalores-ka@nic.in' },
  { code: 'KA-50', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru', location: 'Yelahanka', address: 'NES Office Compound, Major Sandeep Unnikrishnan Road, Yelahanka, Bengaluru - 560064', phone: '080-28561330', email: 'rtoyelahanka-ka@nic.in' },
  { code: 'KA-51', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru Electronic City', location: 'Electronic City', address: 'Behind Infosys Gate 1, Electronics City Phase 1, Bengaluru - 560100', phone: '080-28520288', email: 'rtoecity-ka@nic.in' },
  { code: 'KA-53', stateCode: 'KA', state: 'Karnataka', city: 'Bengaluru East', location: 'K.R. Puram', address: 'Old Madras Road, K.R. Puram, Bengaluru - 560036', phone: '080-25617890', email: 'rtokrpuram-ka@nic.in' },
  { code: 'KA-09', stateCode: 'KA', state: 'Karnataka', city: 'Mysuru', location: 'Mysuru West', address: 'JLB Road, Chamrajpura, Mysuru - 570005', phone: '0821-2495678', email: 'rtomysore-ka@nic.in' },
  { code: 'KA-19', stateCode: 'KA', state: 'Karnataka', city: 'Mangaluru', location: 'Mangaluru', address: 'Near Railway Station, Pandeshwar, Mangaluru - 575001', phone: '0824-2422201', email: 'rtomangalore-ka@nic.in' },

  // Tamil Nadu (TN)
  { code: 'TN-01', stateCode: 'TN', state: 'Tamil Nadu', city: 'Chennai Central', location: 'Ayanavaram', address: 'Anderson Road, Ayanavaram, Chennai - 600023', phone: '044-26741234', email: 'rtochn01@tn.gov.in' },
  { code: 'TN-02', stateCode: 'TN', state: 'Tamil Nadu', city: 'Chennai North West', location: 'Anna Nagar', address: 'Plot No. 1242, 6th Avenue, Anna Nagar West, Chennai - 600040', phone: '044-26154567', email: 'rtochn02@tn.gov.in' },
  { code: 'TN-07', stateCode: 'TN', state: 'Tamil Nadu', city: 'Chennai South', location: 'Thiruvanmiyur', address: 'East Coast Road, Thiruvanmiyur, Chennai - 600041', phone: '044-24412233', email: 'rtochn07@tn.gov.in' },
  { code: 'TN-09', stateCode: 'TN', state: 'Tamil Nadu', city: 'Chennai West', location: 'K.K. Nagar', address: 'P.T. Rajan Salai, K.K. Nagar, Chennai - 600078', phone: '044-24740055', email: 'rtochn09@tn.gov.in' },
  { code: 'TN-10', stateCode: 'TN', state: 'Tamil Nadu', city: 'Chennai South West', location: 'Virugambakkam', address: 'Arcot Road, Virugambakkam, Chennai - 600092', phone: '044-23640987', email: 'rtochn10@tn.gov.in' },
  { code: 'TN-38', stateCode: 'TN', state: 'Tamil Nadu', city: 'Coimbatore North', location: 'Coimbatore', address: 'Balasundaram Road, Coimbatore - 641018', phone: '0422-2245678', email: 'rtocbe@tn.gov.in' },
  { code: 'TN-58', stateCode: 'TN', state: 'Tamil Nadu', city: 'Madurai South', location: 'Madurai', address: 'Near Collectorate, Madurai - 625020', phone: '0452-2531122', email: 'rtomdu@tn.gov.in' },

  // Uttar Pradesh (UP)
  { code: 'UP-32', stateCode: 'UP', state: 'Uttar Pradesh', city: 'Lucknow', location: 'Transport Nagar', address: 'Sector C, Transport Nagar, Kanpur Road, Lucknow - 226012', phone: '0522-2436780', email: 'rtolucknow-up@nic.in' },
  { code: 'UP-16', stateCode: 'UP', state: 'Uttar Pradesh', city: 'Gautam Buddha Nagar', location: 'Noida', address: 'Sector 32, Noida, Gautam Buddha Nagar - 201301', phone: '0120-2505500', email: 'rtonoida-up@nic.in' },
  { code: 'UP-14', stateCode: 'UP', state: 'Uttar Pradesh', city: 'Ghaziabad', location: 'Kavi Nagar', address: 'Industrial Area, Bulandshahr Road, Ghaziabad - 201009', phone: '0120-2701234', email: 'rtoghaziabad-up@nic.in' },
  { code: 'UP-78', stateCode: 'UP', state: 'Uttar Pradesh', city: 'Kanpur Nagar', location: 'Sarvodaya Nagar', address: 'Sarvodaya Nagar, GT Road, Kanpur - 208005', phone: '0512-2216500', email: 'rtokanpur-up@nic.in' },
  { code: 'UP-80', stateCode: 'UP', state: 'Uttar Pradesh', city: 'Agra', location: 'Transport Nagar', address: 'Transport Nagar, Agra - 282007', phone: '0562-2601112', email: 'rtoagra-up@nic.in' },
  { code: 'UP-65', stateCode: 'UP', state: 'Uttar Pradesh', city: 'Varanasi', location: 'Nadesar', address: 'Near Circuit House, Nadesar, Varanasi - 221002', phone: '0542-2501098', email: 'rtovaranasi-up@nic.in' },

  // Haryana (HR)
  { code: 'HR-26', stateCode: 'HR', state: 'Haryana', city: 'Gurugram North', location: 'Gurugram', address: 'Mini Secretariat, Sector 12, Gurugram - 122001', phone: '0124-2321144', email: 'sdm-gurgaon.hry@gov.in' },
  { code: 'HR-51', stateCode: 'HR', state: 'Haryana', city: 'Faridabad', location: 'Faridabad', address: 'Sector 12, Mini Secretariat, Faridabad - 121007', phone: '0129-2227700', email: 'sdm-faridabad.hry@gov.in' },
  { code: 'HR-72', stateCode: 'HR', state: 'Haryana', city: 'Gurugram South', location: 'Sohna', address: 'Tehsil Complex, Sohna, Gurugram - 122103', phone: '0124-2362244', email: 'sdm-sohna.hry@gov.in' },
  { code: 'HR-01', stateCode: 'HR', state: 'Haryana', city: 'Ambala', location: 'Ambala', address: 'District Administrative Complex, Ambala City - 134003', phone: '0171-2530055', email: 'sdm-ambala.hry@gov.in' },

  // Gujarat (GJ)
  { code: 'GJ-01', stateCode: 'GJ', state: 'Gujarat', city: 'Ahmedabad (West)', location: 'Subhash Bridge', address: 'Near Subhash Bridge, Ashram Road, Ahmedabad - 380027', phone: '079-27559211', email: 'rto-ahd-guj@nic.in' },
  { code: 'GJ-27', stateCode: 'GJ', state: 'Gujarat', city: 'Ahmedabad (East)', location: 'Vastral', address: 'Near Ring Road, Vastral, Ahmedabad - 382418', phone: '079-22971200', email: 'rto-vastral-guj@nic.in' },
  { code: 'GJ-05', stateCode: 'GJ', state: 'Gujarat', city: 'Surat', location: 'Majura Gate', address: 'Nanpura / Majura Gate, Ring Road, Surat - 395001', phone: '0261-2465111', email: 'rto-sur-guj@nic.in' },
  { code: 'GJ-06', stateCode: 'GJ', state: 'Gujarat', city: 'Vadodara', location: 'Warasiya Ring Road', address: 'Near Warasiya Police Station, Vadodara - 390006', phone: '0265-2562200', email: 'rto-brd-guj@nic.in' },
  { code: 'GJ-03', stateCode: 'GJ', state: 'Gujarat', city: 'Rajkot', location: 'Aji Dam', address: 'Bhavnagar Highway, Rajkot - 360003', phone: '0281-2387111', email: 'rto-raj-guj@nic.in' },

  // Telangana (TS / AP)
  { code: 'TS-07', stateCode: 'TS', state: 'Telangana', city: 'Ranga Reddy / Cyberabad', location: 'Attapur / Kondapur', address: 'RTO Office, Pillar 143, Inner Ring Road, Attapur, Hyderabad - 500048', phone: '040-23321155', email: 'dto_rr@tstransport.in' },
  { code: 'TS-09', stateCode: 'TS', state: 'Telangana', city: 'Hyderabad Central', location: 'Khairatabad', address: 'Transport Bhavan, Khairatabad, Hyderabad - 500004', phone: '040-23311205', email: 'tc_hyd@tstransport.in' },
  { code: 'TS-08', stateCode: 'TS', state: 'Telangana', city: 'Medchal-Malkajgiri', location: 'Uppal', address: 'Near Survey of India, Uppal, Hyderabad - 500039', phone: '040-27204455', email: 'dto_medchal@tstransport.in' },

  // Rajasthan (RJ)
  { code: 'RJ-14', stateCode: 'RJ', state: 'Rajasthan', city: 'Jaipur (South)', location: 'Jhalana Doongri', address: 'Transport HQ, Parivahan Marg, Sahakar Marg, Jaipur - 302005', phone: '0141-2740200', email: 'rtojaipur-rj@nic.in' },
  { code: 'RJ-45', stateCode: 'RJ', state: 'Rajasthan', city: 'Jaipur (North)', location: 'Vidyadhar Nagar', address: 'Sector 2, Vidyadhar Nagar, Jaipur - 302039', phone: '0141-2234500', email: 'rtonorthjaipur-rj@nic.in' },

  // West Bengal (WB)
  { code: 'WB-01', stateCode: 'WB', state: 'West Bengal', city: 'Kolkata (Two Wheeler)', location: 'Beltala', address: '38 Beltala Road, Bhowanipore, Kolkata - 700020', phone: '033-24751234', email: 'rtobeltala-wb@gov.in' },
  { code: 'WB-02', stateCode: 'WB', state: 'West Bengal', city: 'Kolkata (Four Wheeler)', location: 'Beltala / PVD', address: 'Public Vehicles Dept, 38 Beltala Road, Kolkata - 700020', phone: '033-24755678', email: 'pvd-kolkata@wb.gov.in' },
  { code: 'WB-04', stateCode: 'WB', state: 'West Bengal', city: 'Kolkata Commercial', location: 'Salt Lake', address: 'Bikash Bhavan, Salt Lake City, Kolkata - 700091', phone: '033-23371000', email: 'rtosaltlake-wb@gov.in' },

  // Kerala (KL)
  { code: 'KL-01', stateCode: 'KL', state: 'Kerala', city: 'Thiruvananthapuram', location: 'Fort / East Fort', address: 'Transport Bhavan, Fort PO, Thiruvananthapuram - 695023', phone: '0471-2333334', email: 'kl01@keralamvd.gov.in' },
  { code: 'KL-07', stateCode: 'KL', state: 'Kerala', city: 'Ernakulam / Kochi', location: 'Kakkanad', address: 'Civil Station, Kakkanad, Kochi - 682030', phone: '0484-2422246', email: 'kl07@keralamvd.gov.in' },

  // Punjab (PB) & Chandigarh (CH)
  { code: 'CH-01', stateCode: 'CH', state: 'Chandigarh', city: 'Chandigarh', location: 'Sector 17 / Sector 42', address: 'Registering & Licensing Authority, Sector 17, Chandigarh - 160017', phone: '0172-2700341', email: 'rlachandigarh@nic.in' },
  { code: 'PB-65', stateCode: 'PB', state: 'Punjab', city: 'Mohali / SAS Nagar', location: 'Phase 1 / Sector 76', address: 'District Administrative Complex, Sector 76, SAS Nagar - 160071', phone: '0172-2219500', email: 'rtomohali@punjab.gov.in' },
  { code: 'PB-10', stateCode: 'PB', state: 'Punjab', city: 'Ludhiana', location: 'Mini Secretariat', address: 'Ferozepur Road, Ludhiana - 141001', phone: '0161-2401234', email: 'rtoludhiana@punjab.gov.in' }
];

// Helper to look up an RTO from a vehicle registration string
export function findRtoByRegistration(regNo) {
  if (!regNo) return null;
  const clean = regNo.toUpperCase().replace(/[^A-Z0-9]/g, '');
  if (clean.length < 4) return null;

  const stateCode = clean.substring(0, 2);
  const rtoNum = clean.substring(2, 4);
  const formattedCode = `${stateCode}-${rtoNum}`;

  // Direct code match
  const matched = RTO_OFFICES.find(r => r.code === formattedCode);
  if (matched) return matched;

  // Fallback to state match
  const state = STATE_CODES.find(s => s.code === stateCode);
  if (state) {
    return {
      code: formattedCode,
      stateCode: state.code,
      state: state.name,
      city: `${state.capital} District RTO`,
      location: `Regional Transport Office ${formattedCode}`,
      address: `Regional Transport Office, ${formattedCode}, ${state.capital}, ${state.name}`,
      phone: '1800-180-0151',
      email: `rto.${formattedCode.toLowerCase()}@nic.in`
    };
  }

  return null;
}
