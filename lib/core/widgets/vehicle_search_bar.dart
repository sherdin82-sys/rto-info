import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../utils/vehicle_number_formatter.dart';

/// VehicleSearchBar presents a prominent Indian HSRP-styled number plate search input.
class VehicleSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String? initialValue;
  final bool isLoading;

  const VehicleSearchBar({
    super.key,
    required this.onSearch,
    this.initialValue,
    this.isLoading = false,
  });

  @override
  State<VehicleSearchBar> createState() => _VehicleSearchBarState();
}

class _VehicleSearchBarState extends State<VehicleSearchBar> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final text = _controller.text.trim();
    final clean = VehicleNumberFormatter.cleanPlate(text);

    if (clean.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a vehicle registration number';
      });
      return;
    }

    if (!VehicleNumberFormatter.isValid(clean)) {
      setState(() {
        _errorMessage = 'Invalid format. Example: DL01AB1234 or HR26DQ5551';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    widget.onSearch(clean);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HSRP Number Plate Container
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _errorMessage != null
                  ? AppColors.error
                  : (isDark ? AppColors.darkBorder : AppColors.primaryNavy),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNavy.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Blue IND Strip with Ashoka Chakra Dot
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: const BoxDecoration(
                  color: AppColors.hsrpBlueStrip,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(13)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 1.5),
                      ),
                      child: const Center(
                        child: CircleAvatar(
                          radius: 2,
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'IND',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1.0,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              // Number Plate Text Input
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    controller: _controller,
                    inputFormatters: [VehicleNumberFormatter()],
                    textCapitalization: TextCapitalization.characters,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 2.0,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'DL 01 AB 1234',
                      hintStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 1.5,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => _submitSearch(),
                  ),
                ),
              ),

              // Action / Clear Button
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                ),

              // Search Button
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Material(
                  color: AppColors.electricBlue,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: widget.isLoading ? null : _submitSearch,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message if validation failed
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Row(
              children: [
                const Icon(Icons.error_outline, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
