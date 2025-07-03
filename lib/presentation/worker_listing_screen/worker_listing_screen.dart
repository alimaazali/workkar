import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';
import './widgets/worker_card_widget.dart';

class WorkerListingScreen extends StatefulWidget {
  const WorkerListingScreen({Key? key}) : super(key: key);

  @override
  State<WorkerListingScreen> createState() => _WorkerListingScreenState();
}

class _WorkerListingScreenState extends State<WorkerListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String selectedCategory = 'Electrician';
  String selectedSort = 'Distance';
  List<String> activeFilters = ['Electrician', 'Available'];
  bool isLoading = false;
  bool isLoadingMore = false;
  List<Map<String, dynamic>> workers = [];
  List<Map<String, dynamic>> filteredWorkers = [];

  final List<Map<String, dynamic>> mockWorkers = [
    {
      "id": 1,
      "name": "Rajesh Kumar",
      "category": "Electrician",
      "phone": "+91 9876543210",
      "pincode": "110001",
      "latitude": 28.6139,
      "longitude": 77.2090,
      "distance": 1.2,
      "isAvailable": true,
      "rating": 4.8,
      "profileImage":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isFavorite": false
    },
    {
      "id": 2,
      "name": "Amit Singh",
      "category": "Plumber",
      "phone": "+91 9876543211",
      "pincode": "110002",
      "latitude": 28.6129,
      "longitude": 77.2080,
      "distance": 2.1,
      "isAvailable": true,
      "rating": 4.6,
      "profileImage":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isFavorite": true
    },
    {
      "id": 3,
      "name": "Suresh Sharma",
      "category": "Carpenter",
      "phone": "+91 9876543212",
      "pincode": "110003",
      "latitude": 28.6149,
      "longitude": 77.2100,
      "distance": 0.8,
      "isAvailable": false,
      "rating": 4.9,
      "profileImage":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isFavorite": false
    },
    {
      "id": 4,
      "name": "Vikram Yadav",
      "category": "Electrician",
      "phone": "+91 9876543213",
      "pincode": "110004",
      "latitude": 28.6159,
      "longitude": 77.2110,
      "distance": 3.5,
      "isAvailable": true,
      "rating": 4.7,
      "profileImage":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isFavorite": false
    },
    {
      "id": 5,
      "name": "Manoj Gupta",
      "category": "Plumber",
      "phone": "+91 9876543214",
      "pincode": "110005",
      "latitude": 28.6169,
      "longitude": 77.2120,
      "distance": 1.9,
      "isAvailable": true,
      "rating": 4.5,
      "profileImage":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isFavorite": false
    },
    {
      "id": 6,
      "name": "Ravi Verma",
      "category": "Carpenter",
      "phone": "+91 9876543215",
      "pincode": "110006",
      "latitude": 28.6179,
      "longitude": 77.2130,
      "distance": 4.2,
      "isAvailable": false,
      "rating": 4.4,
      "profileImage":
          "https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isFavorite": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        workers = List.from(mockWorkers);
        _applyFilters();
        isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      _loadMoreWorkers();
    }
  }

  void _loadMoreWorkers() {
    setState(() {
      isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isLoadingMore = false;
      });
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(workers);

    // Filter by category
    if (activeFilters.contains('Electrician') ||
        activeFilters.contains('Plumber') ||
        activeFilters.contains('Carpenter')) {
      filtered = filtered.where((worker) {
        return activeFilters.contains(worker['category'] as String);
      }).toList();
    }

    // Filter by availability
    if (activeFilters.contains('Available')) {
      filtered =
          filtered.where((worker) => worker['isAvailable'] as bool).toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((worker) {
        final name = (worker['name'] as String).toLowerCase();
        final pincode = (worker['pincode'] as String).toLowerCase();
        return name.contains(query) || pincode.contains(query);
      }).toList();
    }

    // Sort workers
    _sortWorkers(filtered);

    setState(() {
      filteredWorkers = filtered;
    });
  }

  void _sortWorkers(List<Map<String, dynamic>> workerList) {
    switch (selectedSort) {
      case 'Distance':
        workerList.sort((a, b) =>
            (a['distance'] as double).compareTo(b['distance'] as double));
        break;
      case 'Rating':
        workerList.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'Availability':
        workerList.sort((a, b) {
          if (a['isAvailable'] as bool && !(b['isAvailable'] as bool))
            return -1;
          if (!(a['isAvailable'] as bool) && b['isAvailable'] as bool) return 1;
          return 0;
        });
        break;
    }
  }

  void _removeFilter(String filter) {
    setState(() {
      activeFilters.remove(filter);
      _applyFilters();
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        selectedSort: selectedSort,
        onSortSelected: (sort) {
          setState(() {
            selectedSort = sort;
            _applyFilters();
          });
        },
      ),
    );
  }

  Future<void> _refreshWorkers() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      workers = List.from(mockWorkers);
      _applyFilters();
      isLoading = false;
    });
  }

  void _toggleFavorite(int workerId) {
    setState(() {
      final workerIndex =
          workers.indexWhere((worker) => worker['id'] == workerId);
      if (workerIndex != -1) {
        workers[workerIndex]['isFavorite'] =
            !(workers[workerIndex]['isFavorite'] as bool);
        _applyFilters();
      }
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Make Call',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Do you want to call $phoneNumber?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style:
                  TextStyle(color: AppTheme.lightTheme.colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Call'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 25.w,
                  height: 1.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 30.w,
                  height: 1.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 20.w,
              color: AppTheme.textSecondaryLight,
            ),
            SizedBox(height: 3.h),
            Text(
              'No workers found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try expanding your search area or adjusting filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  activeFilters.clear();
                  _searchController.clear();
                  _applyFilters();
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        title: Text(
          selectedCategory,
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.surfaceLight,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Search by area or pincode',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondaryLight,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondaryLight,
                          size: 5.w,
                        ),
                      )
                    : null,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppTheme.primaryLight, width: 2),
                ),
              ),
            ),
          ),

          // Filter Chips
          if (activeFilters.isNotEmpty)
            Container(
              height: 8.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: activeFilters.length,
                itemBuilder: (context, index) {
                  return FilterChipWidget(
                    label: activeFilters[index],
                    onRemove: () => _removeFilter(activeFilters[index]),
                  );
                },
              ),
            ),

          // Workers List
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => _buildShimmerCard(),
                  )
                : filteredWorkers.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshWorkers,
                        color: AppTheme.primaryLight,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount:
                              filteredWorkers.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredWorkers.length) {
                              return _buildShimmerCard();
                            }

                            final worker = filteredWorkers[index];
                            return WorkerCardWidget(
                              worker: worker,
                              onCall: () =>
                                  _makePhoneCall(worker['phone'] as String),
                              onFavoriteToggle: () =>
                                  _toggleFavorite(worker['id'] as int),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
