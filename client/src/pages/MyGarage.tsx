import React from 'react';
import { SavedVehicle } from '../types';
import { Bookmark, Car, Trash2, ShieldCheck, AlertCircle, ArrowRight, Zap, Plus } from 'lucide-react';

interface MyGarageProps {
  savedVehicles: SavedVehicle[];
  onRemoveVehicle: (cleanRegNo: string) => void;
  onSelectVehicle: (regNo: string) => void;
  onCheckChallans: (regNo: string) => void;
  onNavigateToSearch: () => void;
}

export const MyGarage: React.FC<MyGarageProps> = ({
  savedVehicles,
  onRemoveVehicle,
  onSelectVehicle,
  onCheckChallans,
  onNavigateToSearch
}) => {
  return (
    <div className="max-w-4xl mx-auto space-y-8 px-4">
      {/* Header */}
      <div className="text-center space-y-2">
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 dark:bg-amber-950/80 border border-amber-200 dark:border-amber-800 text-amber-700 dark:text-amber-300 text-xs font-semibold">
          <Bookmark className="w-3.5 h-3.5 text-amber-500" />
          <span>Personal Vehicle Safe & Garage</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
          My Saved Vehicles
        </h1>
        <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
          Save your personal and family vehicles for 1-click access to insurance, PUC, and challan tracking
        </p>
      </div>

      {/* Empty State */}
      {savedVehicles.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-8 sm:p-12 text-center max-w-md mx-auto space-y-4 shadow-sm">
          <div className="w-16 h-16 rounded-3xl bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 flex items-center justify-center mx-auto">
            <Car className="w-8 h-8" />
          </div>
          <div className="space-y-1">
            <h3 className="font-bold text-slate-900 dark:text-white text-base">Your Garage is Empty</h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
              Lookup any vehicle via RC Details and click "Add to Garage" to keep its insurance and challans on watch.
            </p>
          </div>
          <button
            onClick={onNavigateToSearch}
            className="bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 py-2.5 rounded-xl text-xs flex items-center justify-center gap-2 mx-auto shadow-md transition-all"
          >
            <Plus className="w-4 h-4" />
            <span>Search & Add Vehicle</span>
          </button>
        </div>
      ) : (
        /* Saved Vehicles Grid */
        <div className="space-y-4">
          <div className="flex items-center justify-between text-xs text-slate-500">
            <span>{savedVehicles.length} vehicle(s) saved in local garage</span>
            <button
              onClick={onNavigateToSearch}
              className="text-blue-600 dark:text-blue-400 font-bold hover:underline flex items-center gap-1"
            >
              <Plus className="w-3.5 h-3.5" />
              <span>Add Another</span>
            </button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {savedVehicles.map((v) => (
              <div
                key={v.cleanRegNo}
                className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-sm space-y-4 relative hover:border-blue-500/50 transition-colors"
              >
                <div className="flex items-start justify-between border-b border-slate-100 dark:border-slate-800 pb-3">
                  <div>
                    <span className="inline-block px-2.5 py-1 rounded-lg bg-slate-100 dark:bg-slate-800 font-mono font-black text-sm text-slate-900 dark:text-white border border-slate-200 dark:border-slate-700">
                      {v.regNo}
                    </span>
                    <h4 className="font-bold text-slate-900 dark:text-white text-sm mt-1.5">
                      {v.maker} - {v.model}
                    </h4>
                    <span className="text-xs text-slate-400">
                      {v.vehicleClass} • {v.fuel}
                    </span>
                  </div>

                  <button
                    onClick={() => onRemoveVehicle(v.cleanRegNo)}
                    className="p-1.5 text-slate-400 hover:text-rose-500 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors"
                    title="Remove from Garage"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>

                {/* Expiry Reminders */}
                <div className="grid grid-cols-2 gap-2 text-[11px] bg-slate-50 dark:bg-slate-800/40 p-2.5 rounded-xl">
                  <div>
                    <span className="text-slate-400 block text-[10px]">Insurance Valid Upto</span>
                    <span className="font-semibold text-slate-700 dark:text-slate-300">
                      {v.insuranceValidUpto || 'Recorded in RC'}
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-400 block text-[10px]">PUC Valid Upto</span>
                    <span className="font-semibold text-slate-700 dark:text-slate-300">
                      {v.pucValidUpto || 'Recorded in RC'}
                    </span>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex items-center gap-2 pt-1">
                  <button
                    onClick={() => onSelectVehicle(v.regNo)}
                    className="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-3 rounded-xl text-xs flex items-center justify-center gap-1 shadow-sm transition-colors"
                  >
                    <ShieldCheck className="w-3.5 h-3.5" />
                    <span>View RC Card</span>
                  </button>

                  <button
                    onClick={() => onCheckChallans(v.cleanRegNo)}
                    className="bg-rose-50 hover:bg-rose-100 dark:bg-rose-950/60 dark:hover:bg-rose-900 text-rose-700 dark:text-rose-300 font-bold py-2 px-3 rounded-xl text-xs flex items-center justify-center gap-1 transition-colors"
                  >
                    <AlertCircle className="w-3.5 h-3.5" />
                    <span>Fines</span>
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
