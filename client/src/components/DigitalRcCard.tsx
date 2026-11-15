import React from 'react';
import { VehicleDetails } from '../types';
import { ShieldCheck, Share2, Printer, QrCode, Cpu, CheckCircle2 } from 'lucide-react';

interface DigitalRcCardProps {
  vehicle: VehicleDetails;
  onShare?: () => void;
}

export const DigitalRcCard: React.FC<DigitalRcCardProps> = ({ vehicle, onShare }) => {
  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="w-full max-w-xl mx-auto space-y-4">
      {/* Smart Card Visual Representation */}
      <div className="relative rounded-2xl p-6 overflow-hidden shadow-2xl border-2 border-slate-700 bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 text-white select-none">
        {/* Subtle Guilloche / Security Pattern Background */}
        <div className="absolute inset-0 opacity-10 bg-[radial-gradient(#38bdf8_1px,transparent_1px)] [background-size:16px_16px] pointer-events-none"></div>

        {/* Card Header with Tricolor accent */}
        <div className="relative z-10 flex items-start justify-between border-b border-white/10 pb-4 mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-amber-500/20 border border-amber-400/40 flex items-center justify-center text-amber-300 font-bold text-xs shadow-inner">
              <ShieldCheck className="w-6 h-6 text-amber-400" />
            </div>
            <div>
              <div className="text-[10px] tracking-widest uppercase font-bold text-amber-400">
                Union of India • Ministry of Road Transport
              </div>
              <div className="text-base font-black tracking-tight text-white">
                CERTIFICATE OF REGISTRATION
              </div>
              <div className="text-[9px] text-slate-300 font-mono">
                FORM 23A (RULE 48) • SMART CARD RC
              </div>
            </div>
          </div>

          <div className="text-right">
            <span className="inline-block px-2 py-0.5 rounded-full text-[9px] font-bold bg-emerald-500/20 text-emerald-400 border border-emerald-500/40">
              {vehicle.status}
            </span>
          </div>
        </div>

        {/* Microchip & QR Section */}
        <div className="relative z-10 flex items-center justify-between mb-4">
          {/* Smart Card Gold Chip Simulation */}
          <div className="flex items-center gap-3">
            <div className="w-12 h-9 rounded-md bg-gradient-to-tr from-amber-600 via-yellow-400 to-amber-500 border border-amber-200 shadow-md flex items-center justify-center p-1 relative overflow-hidden">
              <Cpu className="w-6 h-6 text-amber-950 opacity-70" />
              <div className="absolute inset-x-0 h-0.5 bg-amber-700/40 top-1/2 -translate-y-1/2"></div>
              <div className="absolute inset-y-0 w-0.5 bg-amber-700/40 left-1/2 -translate-x-1/2"></div>
            </div>
            <div className="text-[10px] text-slate-400 font-mono leading-tight">
              <span>ELECTRONIC RC</span>
              <br />
              <span className="text-emerald-400">CHIP VERIFIED</span>
            </div>
          </div>

          {/* Registration Number Display */}
          <div className="bg-white/10 backdrop-blur-sm border border-white/20 px-4 py-2 rounded-xl text-center shadow-inner">
            <div className="text-[9px] font-bold tracking-widest text-sky-300 uppercase">Registration No</div>
            <div className="text-xl sm:text-2xl font-black font-mono tracking-wider text-amber-300">
              {vehicle.regNo}
            </div>
          </div>
        </div>

        {/* Key Vehicle Attributes Grid */}
        <div className="relative z-10 grid grid-cols-2 gap-3 text-xs bg-slate-800/40 backdrop-blur-sm p-4 rounded-xl border border-white/5 mb-4">
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Owner Name</span>
            <span className="font-bold text-white tracking-wide">{vehicle.ownerName}</span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Maker & Model</span>
            <span className="font-semibold text-slate-200 truncate block">{vehicle.model}</span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Vehicle Class</span>
            <span className="font-medium text-slate-200">{vehicle.vehicleClass}</span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Fuel / Emission</span>
            <span className="font-medium text-slate-200">{vehicle.fuel} • {vehicle.emissionNorms.split(' ')[0]}</span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Registration Date</span>
            <span className="font-mono text-slate-200">{vehicle.regDate}</span>
          </div>
          <div>
            <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Fitness Upto</span>
            <span className="font-mono text-emerald-300 font-bold">{vehicle.fitnessUpto}</span>
          </div>
        </div>

        {/* Card Footer: RTO and QR code */}
        <div className="relative z-10 flex items-end justify-between pt-2 border-t border-white/10">
          <div>
            <div className="text-[9px] text-slate-400 uppercase tracking-wider">Registering Authority</div>
            <div className="text-xs font-bold text-sky-300">
              {vehicle.rto ? `${vehicle.rto.location} (${vehicle.rto.code})` : 'Regional Transport Authority'}
            </div>
            <div className="text-[10px] text-slate-400 font-mono">
              Chassis: {vehicle.chassisNo.substring(0, 7)}****{vehicle.chassisNo.slice(-4)}
            </div>
          </div>

          <div className="w-12 h-12 bg-white rounded-lg p-1 shadow flex items-center justify-center">
            <QrCode className="w-10 h-10 text-slate-900" />
          </div>
        </div>
      </div>

      {/* Card Action Buttons */}
      <div className="flex items-center justify-end gap-2 text-xs">
        <button
          onClick={handlePrint}
          className="flex items-center gap-1.5 px-3 py-2 rounded-lg bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 font-medium transition-colors"
        >
          <Printer className="w-3.5 h-3.5" />
          <span>Print RC Slip</span>
        </button>

        {onShare && (
          <button
            onClick={onShare}
            className="flex items-center gap-1.5 px-3 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-medium shadow-sm transition-colors"
          >
            <Share2 className="w-3.5 h-3.5" />
            <span>Share Details</span>
          </button>
        )}
      </div>
    </div>
  );
};
