import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/models/dl_entity.dart';
import 'providers/dl_provider.dart';

/// DlScreen handles Driving Licence verification with Sarathi Parivahan standards.
class DlScreen extends ConsumerStatefulWidget {
  const DlScreen({super.key});

  @override
  ConsumerState<DlScreen> createState() => _DlScreenState();
}

class _DlScreenState extends ConsumerState<DlScreen> {
  final _dlController = TextEditingController(text: 'DL0420110149632');
  final _dobController = TextEditingController(text: '1990-05-14');
  String _activeSearchDl = 'DL0420110149632';

  @override
  void dispose() {
    _dlController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _search() {
    final clean = _dlController.text.trim();
    if (clean.isNotEmpty) {
      setState(() {
        _activeSearchDl = clean;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dlAsync = ref.watch(dlDetailsProvider(_activeSearchDl));

    return Scaffold(
      appBar: AppBar(title: const Text('Driving Licence Verification')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // DL Search Box
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'DRIVING LICENCE NUMBER',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _dlController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 1.1,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. DL-0420110149632',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _dlController.clear(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'DATE OF BIRTH (DD-MM-YYYY)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      hintText: '14-05-1990',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _search,
                    icon: const Icon(Icons.verified),
                    label: const Text('Verify Licence with Sarathi'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quick Sample Pills
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Try:',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _sampleChip('DL-0420110149632', 'Delhi (LMV+Bike)'),
                      _sampleChip('MH-1420180019284', 'Maharashtra (Cab)'),
                      _sampleChip('KA-0120150038192', 'Karnataka (Car)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // DL Results
          dlAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Card(
              color: Colors.red.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error retrieving DL record: $err'),
              ),
            ),
            data: (dl) {
              if (dl == null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: const [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No Driving Licence found',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Please check the DL number and format.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return _buildDlCardAndDetails(dl);
            },
          ),
        ],
      ),
    );
  }

  Widget _sampleChip(String dlNum, String label) {
    return ActionChip(
      label: Text(
        '$dlNum ($label)',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        _dlController.text = dlNum;
        _search();
      },
    );
  }

  Widget _buildDlCardAndDetails(DlEntity dl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Digital DL Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF042F2E), Color(0xFF0D9488), Color(0xFF115E59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white24, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'IND',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'UNION OF INDIA • DRIVING LICENCE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  StatusBadge(
                    label: dl.status,
                    type: dl.isValid ? BadgeType.active : BadgeType.expired,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // DL Number
              Text(
                dl.dlNumber,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  color: Colors.amberAccent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Holder & Guardian
              Text(
                dl.maskedHolderName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'S/D/W OF: ${dl.maskedFatherName}',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const Divider(color: Colors.white24, height: 24),
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dlCardMeta('DOB', dl.dob),
                  _dlCardMeta('BLOOD GROUP', dl.bloodGroup),
                  _dlCardMeta('ISSUE DATE', dl.issueDate),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Validity Section Card
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      color: AppColors.electricBlue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Licence Validity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _specRow(
                  'Non-Transport (NT)',
                  dl.validityNonTransport,
                  isHighlight: true,
                ),
                _specRow('Transport (TR)', dl.validityTransport),
                _specRow('Issuing Authority', dl.issuingAuthority),
                _specRow('State Transport Dept', dl.state),
                if (dl.isCommercial && dl.badgeNumber != null)
                  _specRow(
                    'Commercial Badge',
                    dl.badgeNumber!,
                    isHighlight: true,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Endorsed Vehicle Classes
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.drive_eta, color: AppColors.saffron, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Endorsed Vehicle Classes (COV)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                ...dl.vehicleClasses.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c.classCode,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: AppColors.electricBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Issued: ${c.issueDate}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Privacy note
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, size: 20, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Data is queried from Sarathi Parivahan. Personal identification is masked in compliance with Motor Vehicles Act and IT Privacy norms.',
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dlCardMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _specRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isHighlight ? AppColors.electricBlue : null,
            ),
          ),
        ],
      ),
    );
  }
}
