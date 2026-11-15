# 🚗 RTO INFO – Indian Vehicle & Transport Information Portal

> **A modern, comprehensive full-stack Indian Vehicle Information and Parivahan citizen utility application.**

Built with **React 18, TypeScript, Tailwind CSS, Vite, and Node.js / Express**, conforming to the **Ministry of Road Transport and Highways (MoRTH)** and **Central Motor Vehicles Rules (CMVR)** data standards.

---

## 🌟 Key Features

### 1. 🔍 Vehicle Registration Certificate (RC) Lookup
- **Authentic HSRP Plate Input**: High Security Registration Plate format with blue `IND` strip, Ashoka wheel badge, and hot-stamped chromium hologram.
- **Dynamic Parivahan Vahan Engine**: Supports **any valid Indian registration number** (e.g. `DL 01 AB 1234`, `MH 12 DE 1433`, `KA 05 MJ 5005`, `HR 26 DQ 5551`) with automatic State, RTO, and series resolution.
- **High-Fidelity Digital RC Smart Card**:
  - Parivahan Form 23A Smart Card visualization with simulated microchip, guilloche security patterns, and scannable QR verification.
  - Printable official RC slip and instant social/messaging sharing.
- **Detailed Specification Tabs**:
  - **Overview**: Registration date, vehicle age calculation, owner name (with mask/unmask privacy mode), father's name, and registering RTO authority.
  - **Technical Specs**: Maker, commercial model, vehicle class (LMV, MCWG, Electric, LGV), fuel type, BS-VI/OBD-II emission norms, engine & chassis numbers, seating capacity, unladen & gross weights, and wheelbase.
  - **Insurance & PUC**: Policy number, insurer name, live expiry countdown, Section 146 compliance status, and authorized PUC testing center details.
  - **Tax & Hypothecation**: Life Time Tax (LTT) status, receipt number, active vehicle loan financier (HDFC, SBI, ICICI, etc.), and lending branch.

---

### 2. 🪪 Driving Licence (DL) Verification
- **Sarathi Parivahan Verification**: Verify DL records using DL Number (e.g. `DL-0420110149632`, `MH-1420190012345`) and Date of Birth.
- **Form 7 Smart Card Display**: Holder profile, blood group, issuing RTO authority, and active status badge.
- **Endorsements & Validity**:
  - Non-Transport vs. Transport validity periods.
  - Class of Vehicle (COV) badges for Motorcycle with Gear (`MCWG`), Light Motor Vehicle (`LMV`), and Commercial Transport (`TRANS`).
  - Hill and Hazard driving endorsements.

---

### 3. 🚨 Traffic e-Challan Tracker & Fine Settlement Simulator
- **Unified Challan Search**: Query traffic violations by Vehicle Registration Number or Challan Number.
- **Comprehensive Violation Ledger**:
  - Offense description and penal sections under the **Motor Vehicles Amendment Act** (Speeding Section 183, Red Light Section 184, Helmet Section 129, Seatbelt Section 194B, etc.).
  - Automated Traffic Enforcement CCTV / ANPR camera codes, date, junction, and police division.
- **Online Payment Simulator**:
  - Settle fines using simulated **BHIM UPI, Debit/Credit Card, or Net Banking**.
  - Generates instant official **Parivahan e-Challan Payment Receipts** with transaction ID, receipt number, and printable slip.

---

### 4. 🏢 All-India RTO Office Directory
- **36 States & Union Territories**: Directory covering Delhi, Maharashtra, Karnataka, Tamil Nadu, Uttar Pradesh, Gujarat, Haryana, Rajasthan, Kerala, West Bengal, Telangana, and all other states.
- **Instant Search & Filter**: Filter by state code (`DL`, `MH`, `KA`, `UP`, `TN`, etc.) or search by RTO code (`MH-12`, `DL-01`, `KA-05`) or city/district name.
- **Official Office Records**: Physical postal address, jurisdiction area, telephone helpline, and official departmental email contacts.

---

### 5. ⛽ Live Fuel Rates & Trip Expense Calculator
- **Daily Revised Rates**: Real-time Petrol, Diesel, CNG, and Auto LPG rates across major Indian metro cities (Delhi, Mumbai, Bengaluru, Chennai, Kolkata, Hyderabad, Ahmedabad, Pune, etc.).
- **24-Hour Price Trend Indicators**: Visual markers for price cuts or hikes.
- **Trip Fuel Cost Estimator**:
  - Calculates exact fuel quantity needed and estimated journey cost (₹) based on distance (km), vehicle mileage (km/L), fuel type, and local pump rates.
  - Computes running cost per kilometer (`₹/km`).

---

### 6. 💰 Used Vehicle Resale Valuation & Loan EMI Calculator
- **Market Valuation Engine**: Multi-variable depreciation algorithm incorporating vehicle age, annual mileage, physical condition, and number of previous owners to output Fair Market Value, Dealer Price, and Showroom Exchange Value.
- **Vehicle Loan EMI Calculator**: Interactive loan planner with principal, down payment, interest rate, and tenure sliders with monthly EMI and amortization interest ratios.

---

### 7. 🎓 RTO Learner’s Licence Mock Exam
- **Parivahan Sarathi Exam Simulator**: 10 randomized computer-based test questions with a 10-minute countdown timer.
- **Official 60% Passing Standard**: Instant score percentage, pass/fail certification, and detailed rule-by-rule explanations under Central Motor Vehicles Rules.

---

### 8. 🛑 Traffic Signs Handbook & RTO Services Guide
- **Classified Traffic Signs**: Mandatory / Regulatory signs (Red circle), Cautionary / Warning signs (Triangle), and Informatory signs (Blue rectangle) with prescribed fines.
- **RTO Services & Fee Schedule**: Step-by-step procedures, required document checklists, timelines, and statutory fees for **Form 2 (LL), Form 4 (DL), Form 29 & 30 (Transfer of Ownership), Form 33 (Address Change), Form 26 (Duplicate RC), Form 35 (Hypothecation Termination)**, and **Form 28 (NOC)**.

---

### 9. 🧰 My Garage
- **Local Storage Bookmarking**: Save personal and family vehicles for immediate 1-click status checking.
- **Renewal Alert Badges**: Highlights upcoming Insurance and PUC expiry dates to ensure continuous road legality.

---

## 🛠️ Technology Stack

| Layer | Technologies |
|---|---|
| **Frontend** | React 18, TypeScript, Tailwind CSS, Vite, Lucide React Icons |
| **Backend** | Node.js (v24), Express, CORS, Dotenv |
| **Data Engine** | Parivahan Vahan & Sarathi compliant in-memory catalog + deterministic generator |
| **Architecture** | Client-Server architecture with Vite proxy for unified development |

---

## 🚀 Getting Started

### Prerequisites
- **Node.js** (v18 or higher)
- **npm** (v9 or higher)

### Installation
From the project root:
```bash
# Install dependencies for root, server, and client
npm run install:all
```

### Running in Development Mode
To start both the Node.js backend server (Port 5000) and the Vite frontend (Port 3000) concurrently:
```bash
npm run dev
```

Then open your browser at:
```
http://localhost:3000
```

### Building for Production
```bash
# Builds the production frontend bundle to client/dist
npm run build

# Runs the backend API server
npm start
```

---

## 📡 API Endpoints Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/rc/search?regNo=:plate` | Lookup RC details with state & RTO resolution |
| `GET` | `/api/rc/samples` | Curated sample vehicles for 1-click testing |
| `GET` | `/api/dl/verify?dlNumber=:dl&dob=:dob` | Verify driving licence credentials |
| `GET` | `/api/challan/search?regNo=:regNo` | Query all traffic challans for a vehicle |
| `POST` | `/api/challan/pay` | Settle a traffic fine & receive legal receipt |
| `GET` | `/api/rto/states` | List all 36 Indian States and Union Territories |
| `GET` | `/api/rto/offices?state=:code&search=:q` | Query RTO offices by code, city, or state |
| `GET` | `/api/fuel/all` | Live fuel prices across Indian metros |
| `POST` | `/api/resale/calculate` | Compute used vehicle market valuation |
| `POST` | `/api/resale/loan` | Calculate monthly vehicle loan EMI |
| `GET` | `/api/rules/exam/questions` | Fetch randomized LL exam questions |
| `POST` | `/api/rules/exam/evaluate` | Evaluate submitted exam answers |
| `GET` | `/api/rules/traffic-signs` | Catalog of traffic signs and penalties |
| `GET` | `/api/rules/services` | RTO forms, statutory fees, and document lists |

---

## 🇮🇳 Legal Disclaimer
*RTO INFO is designed as an informational citizen utility platform based on Indian Motor Vehicles Act guidelines. Digital Driving Licences and RC cards presented through DigiLocker or mParivahan are legally valid across India under the Information Technology Act 2000 and Section 139 of the Motor Vehicles Act.*
