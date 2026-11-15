import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/status_badge.dart';

/// DlScreen handles Driving Licence verification.
class DlScreen extends StatefulWidget {
  const DlScreen({super.key});

  @override
  State<DlScreen> createState() => _DlScreenState();
}

class _DlScreenState extends State<DlScreen> {
  final _dlController = TextEditingController(text: 'DL-0420110149632');
  final _dobController = TextEditingController(text: '1990-05-14');

  @override
  void dispose() {
    _dlController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Licence Verification'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // DL Search Inputs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('DRIVING LICENCE NUMBER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _dlController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                    decoration: const InputDecoration(
                      hintText: 'DL-0420110149632',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('DATE OF BIRTH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      hintText: 'YYYY-MM-DD',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.verified),
                    label: const Text('Verify Licence Details'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Digital DL Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF0F766E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.success.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'UNION OF INDIA • DRIVING LICENCE',
                      style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    StatusBadge(label: 'ACTIVE / VALID', type: BadgeType.active),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'DL-0420110149632',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'RAGHAV SHARMA',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'S/O: SURESH CHANDRA SHARMA',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const Divider(color: Colors.white24, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DOB', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text('14-MAY-1990', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BLOOD GROUP', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text('B+ POSITIVE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VALIDITY', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text('13-MAY-2030', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
