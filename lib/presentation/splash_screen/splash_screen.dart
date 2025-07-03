import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _screenFadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Screen fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Screen fade animation for transition
    _screenFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set status bar style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );

      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _verifyLocationPermissions(),
        _prepareCachedData(),
      ]);

      // Minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      setState(() {
        _isInitialized = true;
      });

      // Navigate after initialization
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
      });

      // Auto retry after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _hasError) {
          _retryInitialization();
        }
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock authentication logic would go here
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock preferences loading would go here
  }

  Future<void> _verifyLocationPermissions() async {
    // Simulate location permission check
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock location permission logic would go here
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached worker data
    await Future.delayed(const Duration(milliseconds: 700));
    // Mock data preparation would go here
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // Start fade out animation
    _fadeAnimationController.forward().then((_) {
      if (mounted) {
        // Mock navigation logic - in real app this would check auth status
        // For demo purposes, navigate to role selection
        Navigator.pushReplacementNamed(context, '/role-selection');
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isInitialized = false;
    });

    // Reset animations
    _logoAnimationController.reset();
    _fadeAnimationController.reset();

    // Restart initialization
    _logoAnimationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _screenFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _screenFadeAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryLight,
                    AppTheme.secondaryLight,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: _hasError
                          ? _buildErrorContent()
                          : _buildMainContent(),
                    ),
                    _buildLoadingIndicator(),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _logoAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: _buildLogo(),
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          AnimatedBuilder(
            animation: _logoAnimationController,
            builder: (context, child) {
              return Opacity(
                opacity: _logoFadeAnimation.value,
                child: Text(
                  'WorkKar',
                  style: AppTheme.lightTheme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          AnimatedBuilder(
            animation: _logoAnimationController,
            builder: (context, child) {
              return Opacity(
                opacity: _logoFadeAnimation.value * 0.8,
                child: Text(
                  'Find Local Service Experts',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'work',
          color: AppTheme.primaryLight,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'error_outline',
                color: Colors.white,
                size: 10.w,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryLight,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Retry',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (_hasError) {
      return SizedBox(height: 4.h);
    }

    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Column(
            children: [
              SizedBox(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                _isInitialized ? 'Ready!' : 'Initializing...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
