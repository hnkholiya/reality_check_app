import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// Input Type Enum
// ─────────────────────────────────────────────

enum FieldType {
  text,       // General text input
  number,     // Numeric — salary, price, goal
  currency,   // Currency with ₹ prefix
  url,        // Product link paste
  multiline,  // Notes / item description
  password,   // Masked input
}

// ─────────────────────────────────────────────
// CustomTextField — Main Reusable Input Widget
// ─────────────────────────────────────────────

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final FieldType fieldType;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.fieldType = FieldType.text,
    this.prefixIcon,
    this.suffixWidget,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _focusAnimController;
  late Animation<double> _focusAnim;
  late Animation<double> _labelScaleAnim;

  bool _isFocused = false;
  bool _hasText = false;
  bool _obscureText = true; // for password
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    _focusAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _focusAnim = CurvedAnimation(
      parent: _focusAnimController,
      curve: Curves.easeOutCubic,
    );

    _labelScaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _focusAnimController, curve: Curves.easeOut),
    );

    _focusNode.addListener(_onFocusChange);

    // Check if controller already has text
    if (widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_onTextChange);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _focusAnimController.dispose();
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _focusAnimController.forward();
    } else {
      _focusAnimController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = (widget.controller?.text ?? '').isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  // ── Keyboard & Input Type Resolvers ──

  TextInputType get _keyboardType {
    switch (widget.fieldType) {
      case FieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case FieldType.currency:
        return const TextInputType.numberWithOptions(decimal: true);
      case FieldType.url:
        return TextInputType.url;
      case FieldType.multiline:
        return TextInputType.multiline;
      case FieldType.password:
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> get _inputFormatters {
    switch (widget.fieldType) {
      case FieldType.number:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ];
      case FieldType.currency:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ];
      default:
        return [];
    }
  }

  int? get _maxLines {
    switch (widget.fieldType) {
      case FieldType.multiline:
        return 4;
      case FieldType.password:
        return 1;
      default:
        return 1;
    }
  }

  int? get _minLines {
    switch (widget.fieldType) {
      case FieldType.multiline:
        return 3;
      default:
        return null;
    }
  }

  // ── Prefix Widget ──

  Widget? get _prefixWidget {
    if (widget.fieldType == FieldType.currency) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppTheme.spacingMd,
          right: AppTheme.spacingSm,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _isFocused
                ? AppTheme.primaryColor
                : (Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary),
          ),
          child: const Text('₹'),
        ),
      );
    }
    if (widget.prefixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppTheme.spacingMd,
          right: AppTheme.spacingSm,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            widget.prefixIcon,
            key: ValueKey(_isFocused),
            size: 20,
            color: _isFocused
                ? AppTheme.primaryColor
                : (Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary),
          ),
        ),
      );
    }
    return null;
  }

  // ── Suffix Widget ──

  Widget? get _suffixWidget {
    if (widget.fieldType == FieldType.password) {
      return IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            _obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            key: ValueKey(_obscureText),
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary,
          ),
        ),
      );
    }

    if (widget.fieldType == FieldType.url && _hasText) {
      return IconButton(
        onPressed: () {
          widget.controller?.clear();
          setState(() => _hasText = false);
          HapticFeedback.lightImpact();
        },
        icon: Icon(
          Icons.close_rounded,
          size: 18,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkTextMuted
              : AppTheme.lightTextMuted,
        ),
      );
    }

    return widget.suffixWidget;
  }

  // ── Focus Border Color ──

  Color _borderColor(bool isDark) {
    if (_errorText != null) return AppTheme.dangerRed;
    if (_isFocused) return AppTheme.primaryColor;
    return isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
  }

  double _borderWidth() {
    if (_isFocused || _errorText != null) return 2.0;
    return 1.0;
  }

  // ── Validate ──

  void _runValidation(String value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _focusAnim,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Label ──
            if (widget.label.isNotEmpty) ...[
              _buildLabel(isDark),
              const SizedBox(height: AppTheme.spacingSm),
            ],

            // ── Input Container ──
            _buildInputContainer(isDark),

            // ── Helper / Error Text ──
            _buildHelperRow(isDark),
          ],
        );
      },
    );
  }

  Widget _buildLabel(bool isDark) {
    return Row(
      children: [
        ScaleTransition(
          scale: _labelScaleAnim,
          alignment: Alignment.centerLeft,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: _isFocused
                  ? AppTheme.primaryColor
                  : (_errorText != null
                  ? AppTheme.dangerRed
                  : (isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary)),
            ),
            child: Text(widget.label),
          ),
        ),
        if (widget.validator != null) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _errorText != null
                  ? AppTheme.dangerRed
                  : AppTheme.primaryColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInputContainer(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: _borderColor(isDark),
          width: _borderWidth(),
        ),
        boxShadow: _isFocused
            ? [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ]
            : [],
      ),
      child: Row(
        crossAxisAlignment: widget.fieldType == FieldType.multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          // Prefix
          if (_prefixWidget != null) _prefixWidget!,

          // Text Field
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              obscureText: widget.fieldType == FieldType.password
                  ? _obscureText
                  : false,
              keyboardType: _keyboardType,
              inputFormatters: _inputFormatters,
              maxLines: _maxLines,
              minLines: _minLines,
              maxLength: widget.maxLength,
              textInputAction: widget.textInputAction ??
                  (widget.fieldType == FieldType.multiline
                      ? TextInputAction.newline
                      : TextInputAction.next),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: widget.enabled
                    ? (isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary)
                    : (isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted),
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppTheme.darkTextMuted
                      : AppTheme.lightTextMuted,
                  fontWeight: FontWeight.w400,
                ),
                // Remove all default borders — container handles them
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.prefixIcon != null ||
                      widget.fieldType == FieldType.currency
                      ? AppTheme.spacingSm
                      : AppTheme.spacingMd,
                  vertical: widget.fieldType == FieldType.multiline
                      ? AppTheme.spacingMd
                      : 15,
                ),
              ),
              onChanged: (val) {
                _onTextChange();
                widget.onChanged?.call(val);
                // Clear error on change
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
              onFieldSubmitted: (val) {
                _runValidation(val);
                widget.onSubmitted?.call(val);
              },
              validator: (val) {
                final err = widget.validator?.call(val);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _errorText = err);
                });
                return null; // We handle error display manually
              },
            ),
          ),

          // Suffix
          if (_suffixWidget != null) _suffixWidget!,
        ],
      ),
    );
  }

  Widget _buildHelperRow(bool isDark) {
    final showError = _errorText != null && _errorText!.isNotEmpty;
    final showHelper =
        widget.helperText != null && widget.helperText!.isNotEmpty;

    if (!showError && !showHelper) return const SizedBox(height: 4);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppTheme.spacingXs + 2,
          left: AppTheme.spacingXs,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.3),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: showError
              ? Row(
            key: const ValueKey('error'),
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 13,
                color: AppTheme.dangerRed,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _errorText!,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.dangerRed,
                  ),
                ),
              ),
            ],
          )
              : Row(
            key: const ValueKey('helper'),
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: isDark
                    ? AppTheme.darkTextMuted
                    : AppTheme.lightTextMuted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.helperText!,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppTheme.darkTextMuted
                        : AppTheme.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CurrencyInputField — Specialized salary/price input
// Wraps CustomTextField with currency-specific UX
// ─────────────────────────────────────────────

class CurrencyInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const CurrencyInputField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: hint ?? '0.00',
      helperText: helperText,
      controller: controller,
      fieldType: FieldType.currency,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      textInputAction: textInputAction,
    );
  }
}

// ─────────────────────────────────────────────
// UrlInputField — Paste product link field
// Auto-detect platform from URL
// ─────────────────────────────────────────────

class UrlInputField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const UrlInputField({
    super.key,
    this.label = 'Product Link',
    this.controller,
    this.validator,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<UrlInputField> createState() => _UrlInputFieldState();
}

class _UrlInputFieldState extends State<UrlInputField> {
  String? _detectedPlatform;

  String? _detectPlatform(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('amazon')) return 'Amazon';
    if (lower.contains('flipkart')) return 'Flipkart';
    if (lower.contains('myntra')) return 'Myntra';
    if (lower.contains('meesho')) return 'Meesho';
    if (lower.contains('snapdeal')) return 'Snapdeal';
    if (lower.contains('nykaa')) return 'Nykaa';
    if (lower.contains('ajio')) return 'AJIO';
    if (lower.contains('tatacliq')) return 'Tata CLiQ';
    if (lower.contains('jiomart')) return 'JioMart';
    if (lower.contains('shopsy')) return 'Shopsy';
    if (url.isNotEmpty && url.startsWith('http')) return 'Other';
    return null;
  }

  IconData _platformIcon(String platform) {
    switch (platform) {
      case 'Amazon':
        return Icons.shopping_bag_rounded;
      case 'Flipkart':
        return Icons.local_mall_rounded;
      default:
        return Icons.link_rounded;
    }
  }

  Color _platformColor(String platform) {
    switch (platform) {
      case 'Amazon':
        return const Color(0xFFFF9900);
      case 'Flipkart':
        return const Color(0xFF2874F0);
      case 'Myntra':
        return const Color(0xFFFF3F6C);
      case 'Meesho':
        return const Color(0xFF9B2FFF);
      default:
        return AppTheme.accentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: widget.label,
          hint: 'Paste Amazon / Flipkart / any product link',
          controller: widget.controller,
          fieldType: FieldType.url,
          prefixIcon: Icons.link_rounded,
          validator: widget.validator,
          focusNode: widget.focusNode,
          helperText: 'Supports Amazon, Flipkart, Myntra & more',
          onChanged: (val) {
            setState(() {
              _detectedPlatform = _detectPlatform(val);
            });
            widget.onChanged?.call(val);
          },
          textInputAction: TextInputAction.done,
        ),

        // ── Platform Detection Badge ──
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: _detectedPlatform != null
              ? Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacingSm),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Container(
                key: ValueKey(_detectedPlatform),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: _platformColor(_detectedPlatform!)
                      .withOpacity(isDark ? 0.15 : 0.08),
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(
                    color: _platformColor(_detectedPlatform!)
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _platformIcon(_detectedPlatform!),
                      size: 14,
                      color: _platformColor(_detectedPlatform!),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_detectedPlatform!} link detected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _platformColor(_detectedPlatform!),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: _platformColor(_detectedPlatform!),
                    ),
                  ],
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Common Validators — Used across all screens
// ─────────────────────────────────────────────

class FieldValidators {
  FieldValidators._();

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? salary(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Monthly salary is required';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return 'Enter a valid salary amount';
    if (amount <= 0) return 'Salary must be greater than ₹0';
    if (amount > 10000000) return 'Please enter a realistic salary';
    return null;
  }

  static String? spendingLimit(String? value, {double? salary}) {
    if (value == null || value.trim().isEmpty) {
      return 'Spending limit is required';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return 'Enter a valid amount';
    if (amount <= 0) return 'Spending limit must be greater than ₹0';
    if (salary != null && amount > salary) {
      return 'Spending limit cannot exceed your salary';
    }
    return null;
  }

  static String? savingsGoal(String? value, {double? salary}) {
    if (value == null || value.trim().isEmpty) {
      return 'Savings goal is required';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return 'Enter a valid amount';
    if (amount < 0) return 'Savings goal cannot be negative';
    if (salary != null && amount >= salary) {
      return 'Savings goal should be less than your salary';
    }
    return null;
  }

  static String? itemPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item price is required';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return 'Enter a valid price';
    if (amount <= 0) return 'Price must be greater than ₹0';
    return null;
  }

  static String? productUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please paste a product link';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL starting with http(s)://';
    }
    if (!value.startsWith('http')) {
      return 'URL must start with https://';
    }
    return null;
  }

  static String? itemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required';
    }
    if (value.trim().length < 2) {
      return 'Item name is too short';
    }
    if (value.trim().length > 100) {
      return 'Item name is too long (max 100 characters)';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}