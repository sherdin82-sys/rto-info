import React, { useState, useEffect } from 'react';
import { Navbar } from './components/Navbar';
import { Footer } from './components/Footer';
import { Home } from './pages/Home';
import { RcLookup } from './pages/RcLookup';
import { DlVerification } from './pages/DlVerification';
import { ChallanChecker } from './pages/ChallanChecker';
import { RtoDirectory } from './pages/RtoDirectory';
import { FuelPrices } from './pages/FuelPrices';
import { ResaleCalculator } from './pages/ResaleCalculator';
import { ExamPractice } from './pages/ExamPractice';
import { TrafficSigns } from './pages/TrafficSigns';
import { MyGarage } from './pages/MyGarage';
import { SavedVehicle, VehicleDetails } from './types';

export const App: React.FC = () => {
  const [currentTab, setCurrentTab] = useState<string>('home');
  const [activePlateForRc, setActivePlateForRc] = useState<string>('');
  const [activePlateForChallan, setActivePlateForChallan] = useState<string>('');

  // Garage Local Storage
  const [savedVehicles, setSavedVehicles] = useState<SavedVehicle[]>(() => {
    try {
      const stored = localStorage.getItem('rto_garage_vehicles');
      return stored ? JSON.parse(stored) : [];
    } catch {
      return [];
    }
  });

  // Dark Mode Local Storage
  const [darkMode, setDarkMode] = useState<boolean>(() => {
    try {
      const stored = localStorage.getItem('rto_dark_mode');
      return stored !== null ? JSON.parse(stored) : true;
    } catch {
      return true;
    }
  });

  useEffect(() => {
    localStorage.setItem('rto_garage_vehicles', JSON.stringify(savedVehicles));
  }, [savedVehicles]);

  useEffect(() => {
    localStorage.setItem('rto_dark_mode', JSON.stringify(darkMode));
    if (darkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [darkMode]);

  const handleToggleSaveGarage = (vehicle: VehicleDetails) => {
    setSavedVehicles((prev) => {
      const exists = prev.some((v) => v.cleanRegNo === vehicle.cleanRegNo);
      if (exists) {
        return prev.filter((v) => v.cleanRegNo !== vehicle.cleanRegNo);
      } else {
        const newEntry: SavedVehicle = {
          regNo: vehicle.regNo,
          cleanRegNo: vehicle.cleanRegNo,
          maker: vehicle.maker,
          model: vehicle.model,
          fuel: vehicle.fuel,
          vehicleClass: vehicle.vehicleClass,
          savedAt: new Date().toISOString().split('T')[0],
          insuranceValidUpto: vehicle.insurance.validUpto,
          pucValidUpto: vehicle.puc.validUpto
        };
        return [newEntry, ...prev];
      }
    });
  };

  const handleRemoveGarage = (cleanRegNo: string) => {
    setSavedVehicles((prev) => prev.filter((v) => v.cleanRegNo !== cleanRegNo));
  };

  const handleSearchRcFromHome = (plate: string) => {
    setActivePlateForRc(plate);
    setCurrentTab('rc');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleCheckChallansForVehicle = (regNo: string) => {
    setActivePlateForChallan(regNo);
    setCurrentTab('challan');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleViewRcFromGarage = (regNo: string) => {
    setActivePlateForRc(regNo);
    setCurrentTab('rc');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="min-h-screen flex flex-col bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 transition-colors">
      <Navbar
        currentTab={currentTab}
        setCurrentTab={setCurrentTab}
        garageCount={savedVehicles.length}
        darkMode={darkMode}
        setDarkMode={setDarkMode}
      />

      <main className="flex-1 py-8">
        {currentTab === 'home' && (
          <Home
            onSearchRc={handleSearchRcFromHome}
            onNavigateTab={(tab) => {
              setCurrentTab(tab);
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
          />
        )}

        {currentTab === 'rc' && (
          <RcLookup
            initialPlate={activePlateForRc}
            onCheckChallans={handleCheckChallansForVehicle}
            savedVehicles={savedVehicles}
            onToggleSaveGarage={handleToggleSaveGarage}
          />
        )}

        {currentTab === 'dl' && <DlVerification />}

        {currentTab === 'challan' && (
          <ChallanChecker initialRegNo={activePlateForChallan} />
        )}

        {currentTab === 'rto' && <RtoDirectory />}

        {currentTab === 'fuel' && <FuelPrices />}

        {currentTab === 'resale' && <ResaleCalculator />}

        {currentTab === 'exam' && <ExamPractice />}

        {currentTab === 'signs' && <TrafficSigns />}

        {currentTab === 'garage' && (
          <MyGarage
            savedVehicles={savedVehicles}
            onRemoveVehicle={handleRemoveGarage}
            onSelectVehicle={handleViewRcFromGarage}
            onCheckChallans={handleCheckChallansForVehicle}
            onNavigateToSearch={() => setCurrentTab('rc')}
          />
        )}
      </main>

      <Footer />
    </div>
  );
};

export default App;
