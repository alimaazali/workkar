import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoleCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String iconName;
  final Color color;
  final VoidCallback onTap;
  final List<String> features;

  const RoleCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.iconName,
    required this.color,
    required this.onTap,
    required this.features,
  }) : super(key: key);

  @override
  State<RoleCardWidget> createState() => _RoleCardWidgetState();
}

class _RoleCardWidgetState extends State<RoleCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 25.h,
                maxHeight: 30.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isPressed
                      ? widget.color
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: _isPressed ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? widget.color.withValues(alpha: 0.2)
                        : AppTheme.lightTheme.shadowColor,
                    blurRadius: _isPressed ? 20 : 8,
                    offset: Offset(0, _isPressed ? 8 : 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 3.h),
                    _buildDescription(),
                    SizedBox(height: 2.h),
                    _buildFeatures(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 7.h,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: widget.iconName,
              color: widget.color,
              size: 28,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                height: 3,
                width: 12.w,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: widget.color,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.description,
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
    );
  }

  Widget _buildFeatures() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Features:',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  widget.features.length > 2 ? 2 : widget.features.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: EdgeInsets.only(top: 1.h, right: 3.w),
                        decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.features[index],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
