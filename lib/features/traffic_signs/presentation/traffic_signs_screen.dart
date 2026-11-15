import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../domain/models/traffic_sign_entity.dart';
import '../data/traffic_signs_data.dart';

class TrafficSignsScreen extends StatefulWidget {
  const TrafficSignsScreen({super.key});

  @override
  State<TrafficSignsScreen> createState() => _TrafficSignsScreenState();
}

class _TrafficSignsScreenState extends State<TrafficSignsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Signs & MV Act Fines'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Mandatory Signs'),
            Tab(text: 'Cautionary Signs'),
            Tab(text: 'Informatory Signs'),
            Tab(text: 'MV Act Fines'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase().trim()),
              decoration: InputDecoration(
                hintText: 'Search sign name, rule or offence...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSignsList('Mandatory'),
                _buildSignsList('Cautionary'),
                _buildSignsList('Informatory'),
                _buildFinesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignsList(String category) {
    final filtered = TrafficSignsData.signs.where((s) {
      final matchesCat = s.category == category;
      if (!matchesCat) return false;
      if (_searchQuery.isEmpty) return true;
      return s.title.toLowerCase().contains(_searchQuery) || s.description.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No signs found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final sign = filtered[index];
        return _buildSignCard(sign);
      },
    );
  }

  Widget _buildSignCard(TrafficSignEntity sign) {
    Color borderColor;
    Color bgColor;
    IconData iconData;

    if (sign.category == 'Mandatory') {
      borderColor = const Color(0xFFDC2626);
      bgColor = const Color(0xFFFEF2F2);
      iconData = Icons.do_not_disturb_on;
    } else if (sign.category == 'Cautionary') {
      borderColor = const Color(0xFFD97706);
      bgColor = const Color(0xFFFFFBEB);
      iconData = Icons.warning_amber_rounded;
    } else {
      borderColor = const Color(0xFF2563EB);
      bgColor = const Color(0xFFEFF6FF);
      iconData = Icons.info_outline;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sign Visual Badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                shape: sign.shape == 'Circle' || sign.shape == 'Octagon' ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: sign.shape != 'Circle' && sign.shape != 'Octagon' ? BorderRadius.circular(8) : null,
                border: Border.all(color: borderColor, width: 3),
              ),
              child: Center(
                child: Icon(iconData, color: borderColor, size: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sign.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sign.description,
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey, height: 1.3),
                  ),
                  if (sign.fineForViolation != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Fine: ${sign.fineForViolation}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinesList() {
    final filtered = TrafficSignsData.fines.where((f) {
      if (_searchQuery.isEmpty) return true;
      return f.offence.toLowerCase().contains(_searchQuery) ||
          f.section.toLowerCase().contains(_searchQuery) ||
          f.penalty.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No offences found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fine = filtered[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.electricBlue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        fine.section,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.electricBlue),
                      ),
                    ),
                    Text(
                      fine.category,
                      style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  fine.offence,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.gavel, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        fine.penalty,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
