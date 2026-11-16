import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/vehicle_number_formatter.dart';

/// VehicleSearchBar presents a compact, authentic Indian HSRP-styled number plate search input.
class VehicleSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String? initialValue;
  final bool isLoading;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final String? hintText;

  const VehicleSearchBar({
    super.key,
    required this.onSearch,
    this.initialValue,
    this.isLoading = false,
    this.onChanged,
    this.autofocus = false,
    this.hintText,
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
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(VehicleSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue!;
    }
  }

  void _onTextChanged() {
    setState(() {});
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // HSRP Number Plate Container with comfortable height
        Container(
          height: 54,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _errorMessage != null
                  ? AppColors.error
                  : (isDark ? AppColors.darkBorder : AppColors.primaryNavy),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNavy.withOpacity(isDark ? 0.2 : 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Blue IND Strip with Ashoka Chakra Dot
              Container(
                width: 42,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.hsrpBlueStrip,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 1.2),
                      ),
                      child: const Center(
                        child: CircleAvatar(
                          radius: 1.5,
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.5),
                    const Text(
                      'IND',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                        letterSpacing: 0.8,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              // Number Plate Text Input directly inside container with NO inner outline
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    autofocus: widget.autofocus,
                    inputFormatters: [VehicleNumberFormatter()],
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    autocorrect: false,
                    enableSuggestions: false,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: AppColors.electricBlue,
                    cursorWidth: 2.0,
                    cursorRadius: const Radius.circular(1),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      letterSpacing: 1.5,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.hintText ?? 'DL 01 AB 1234',
                      hintStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        letterSpacing: 1.2,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      filled: false,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => _submitSearch(),
                  ),
                ),
              ),

              // Clear Button
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.clear_rounded,
                      size: 19,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),

              // Perfectly Aligned Compact Search Button
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Material(
                  color: AppColors.electricBlue,
                  borderRadius: BorderRadius.circular(9),
                  child: InkWell(
                    onTap: widget.isLoading ? null : _submitSearch,
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
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
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 12,
                  color: AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 11,
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
