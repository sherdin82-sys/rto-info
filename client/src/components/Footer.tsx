import React from 'react';
import { ExternalLink, Phone, ShieldCheck, Heart } from 'lucide-react';

export const Footer: React.FC = () => {
  return (
    <footer className="bg-slate-900 text-slate-300 border-t border-slate-800 mt-20 pt-12 pb-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          {/* Col 1: About & Info */}
          <div className="space-y-3">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white font-black text-sm">
                RTO
              </div>
              <span className="text-lg font-bold text-white">RTO INFO Portal</span>
            </div>
            <p className="text-xs text-slate-400 leading-relaxed">
              India's comprehensive vehicle & transport intelligence platform. Access RC details, DL verification, e-challan fines, RTO office directory, and daily fuel prices across all 36 Indian States and UTs.
            </p>
            <div className="flex items-center gap-2 text-xs text-emerald-400 font-medium">
              <ShieldCheck className="w-4 h-4" />
              <span>Conforms to Parivahan Vahan Standards</span>
            </div>
          </div>

          {/* Col 2: Parivahan Quick Portals */}
          <div>
            <h4 className="text-xs font-bold text-white uppercase tracking-wider mb-3">Official Indian Portals</h4>
            <ul className="space-y-2 text-xs">
              <li>
                <a
                  href="https://parivahan.gov.in"
                  target="_blank"
                  rel="noreferrer"
                  className="flex items-center gap-1.5 text-slate-400 hover:text-amber-400 transition-colors"
                >
                  <ExternalLink className="w-3 h-3 text-slate-500" />
                  <span>Ministry of Road Transport (MoRTH)</span>
                </a>
              </li>
              <li>
                <a
                  href="https://vahan.parivahan.gov.in"
                  target="_blank"
                  rel="noreferrer"
                  className="flex items-center gap-1.5 text-slate-400 hover:text-amber-400 transition-colors"
                >
                  <ExternalLink className="w-3 h-3 text-slate-500" />
                  <span>Vahan Citizen Services (RC)</span>
                </a>
              </li>
              <li>
                <a
                  href="https://sarathi.parivahan.gov.in"
                  target="_blank"
                  rel="noreferrer"
                  className="flex items-center gap-1.5 text-slate-400 hover:text-amber-400 transition-colors"
                >
                  <ExternalLink className="w-3 h-3 text-slate-500" />
                  <span>Sarathi Services (Driving Licence)</span>
                </a>
              </li>
              <li>
                <a
                  href="https://echallan.parivahan.gov.in"
                  target="_blank"
                  rel="noreferrer"
                  className="flex items-center gap-1.5 text-slate-400 hover:text-amber-400 transition-colors"
                >
                  <ExternalLink className="w-3 h-3 text-slate-500" />
                  <span>e-Challan Digital Traffic Enforcement</span>
                </a>
              </li>
            </ul>
          </div>

          {/* Col 3: Helplines & Support */}
          <div>
            <h4 className="text-xs font-bold text-white uppercase tracking-wider mb-3">Transport Helplines</h4>
            <div className="space-y-2.5 text-xs">
              <div className="flex items-start gap-2">
                <Phone className="w-4 h-4 text-blue-400 shrink-0 mt-0.5" />
                <div>
                  <span className="text-white font-medium">Parivahan Toll Free</span>
                  <p className="text-slate-400">1800-180-0151 (06:00 AM - 10:00 PM)</p>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <Phone className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
                <div>
                  <span className="text-white font-medium">National Emergency (All States)</span>
                  <p className="text-slate-400">112 (Police, Fire, Ambulance)</p>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <Phone className="w-4 h-4 text-orange-400 shrink-0 mt-0.5" />
                <div>
                  <span className="text-white font-medium">National Highway Emergency</span>
                  <p className="text-slate-400">1033 (NHAI Road Assistance)</p>
                </div>
              </div>
            </div>
          </div>

          {/* Col 4: Statutory Disclaimer */}
          <div>
            <h4 className="text-xs font-bold text-white uppercase tracking-wider mb-3">Public Disclaimer</h4>
            <p className="text-[11px] text-slate-400 leading-relaxed">
              This application is designed as an informational vehicle utility platform. All data is structured per official Indian Motor Vehicles guidelines. Always carry digital documents on DigiLocker or mParivahan as recognized under IT Act 2000 & MV Act Section 139.
            </p>
          </div>
        </div>

        <div className="border-t border-slate-800 pt-6 flex flex-col sm:flex-row items-center justify-between text-xs text-slate-500 gap-4">
          <p>© 2026 RTO INFO. Made with <Heart className="w-3.5 h-3.5 inline text-rose-500 mx-0.5" /> for Indian motorists & commuters.</p>
          <div className="flex items-center gap-4">
            <span className="hover:text-slate-300">Privacy Policy</span>
            <span>•</span>
            <span className="hover:text-slate-300">Motor Vehicles Act (1988/2019)</span>
            <span>•</span>
            <span className="hover:text-slate-300">Terms of Service</span>
          </div>
        </div>
      </div>
    </footer>
  );
};
