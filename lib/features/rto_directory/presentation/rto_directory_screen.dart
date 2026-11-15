import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/models/rto_office_entity.dart';
import '../data/rto_directory_data.dart';

class RtoDirectoryScreen extends StatefulWidget {
  const RtoDirectoryScreen({super.key});

  @override
  State<RtoDirectoryScreen> createState() => _RtoDirectoryScreenState();
}

class _RtoDirectoryScreenState extends State<RtoDirectoryScreen> {
  final _searchController = TextEditingController();
  String _selectedState = 'All';
  List<RtoOfficeEntity> _filteredOffices = RtoDirectoryData.offices;

  final List<String> _states = [
    'All',
    'Delhi',
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'Uttar Pradesh',
    'Haryana',
    'Gujarat',
    'Rajasthan',
    'West Bengal',
    'Telangana',
    'Kerala',
    'Chandigarh',
    'Punjab',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchController.text.toUpperCase().replaceAll('-', '').trim();
    setState(() {
      _filteredOffices = RtoDirectoryData.offices.where((office) {
        final stateMatch =
            _selectedState == 'All' || office.state == _selectedState;
        if (!stateMatch) return false;

        if (q.isEmpty) return true;

        final cleanCode = office.rtoCode.replaceAll('-', '');
        return cleanCode.contains(q) ||
            office.city.toUpperCase().contains(q) ||
            office.officeName.toUpperCase().contains(q) ||
            office.pincode.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All-India RTO Directory')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filter(),
              decoration: InputDecoration(
                hintText: 'Search by RTO code (e.g. DL-01, MH-12) or city...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filter();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // State filter horizontal scroll
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _states.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final state = _states[index];
                final isSelected = _selectedState == state;
                return ChoiceChip(
                  label: Text(
                    state,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedState = state);
                      _filter();
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredOffices.length} RTO Offices Found',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // List of RTO Offices
          Expanded(
            child: _filteredOffices.isEmpty
                ? const Center(child: Text('No RTO office matching search'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOffices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final office = _filteredOffices[index];
                      return _buildOfficeCard(office);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeCard(RtoOfficeEntity office) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RTO Code Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    office.rtoCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        office.officeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${office.city}, ${office.state}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    office.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Phone & Pin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      office.phone,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.copy, size: 14),
                  label: const Text(
                    'Copy Code',
                    style: TextStyle(fontSize: 11),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: office.rtoCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied ${office.rtoCode} to clipboard'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
