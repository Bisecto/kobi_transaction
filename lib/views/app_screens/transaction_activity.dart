import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobi_test/model/transaction_model.dart';
import 'package:kobi_test/views/app_screens/app_widgets/filter_widget.dart';
import 'package:kobi_test/views/app_screens/app_widgets/not_found_widget.dart';
import 'package:kobi_test/views/app_screens/app_widgets/transaction_container.dart';
import 'package:kobi_test/views/widgets/app_loading_widget.dart';

import '../../bloc/transaction_bloc/transaction_bloc.dart';
import '../../bloc/transaction_bloc/transaction_event.dart';
import '../../bloc/transaction_bloc/transaction_state.dart';
import '../../res/app_enums.dart';
import '../widgets/app_custom_text.dart';




class TransactionActivityPage extends StatefulWidget {
  const TransactionActivityPage({Key? key}) : super(key: key);

  @override
  State<TransactionActivityPage> createState() =>
      _TransactionActivityPageState();
}

class _TransactionActivityPageState extends State<TransactionActivityPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _staggerController;
  late AnimationController _filterController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isInitialLoad = true;
  TransactionFilter? _previousFilter;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: _buildAnimatedAppBar(),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionLoaded) {
            if (_isInitialLoad) {
              _animationController.forward();
              _staggerController.forward();
              _isInitialLoad = false;
            } else {
              _staggerController.forward(from: 0);
            }
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return _buildLoadingIndicator();
            }

            if (state is TransactionError) {
              return _buildErrorState(state);
            }

            if (state is TransactionLoaded) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWebOrTablet = constraints.maxWidth > 600;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWebOrTablet ? 800 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          _buildAnimatedFilterSection(state, isWebOrTablet),
                          Expanded(
                            child: _buildAnimatedTransactionList(state),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: const CustomText(
                text: 'Transaction Activity',
                size: 20,
                weight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        },
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.5 + (0.5 * value),
            child: Opacity(
              opacity: value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(Colors.grey, const Color(0xFF4CAF50), value)!,
                      ),
                      strokeWidth: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    text: 'Loading transactions...',
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(TransactionError state) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: NotFoundContainer(
            title: 'Error Loading Transactions',
            description: state.message,
            icon: Icons.error_outline,
            actionLabel: 'Retry',
            onActionTap: () {
              context.read<TransactionBloc>().add(LoadTransactions());
            },
          ),
        );
      },
    );
  }

  Widget _buildAnimatedFilterSection(TransactionLoaded state, bool isWebOrTablet) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isWebOrTablet ? 24.0 : 16.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Filter Transactions',
                size: isWebOrTablet ? 18 : 16,
                weight: FontWeight.w600,
                color: Colors.black87,
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TransactionFilter.values.asMap().entries.map((entry) {
                    final index = entry.key;
                    final filter = entry.value;

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 200 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildEnhancedFilterChip(filter, state),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFilterChip(TransactionFilter filter, TransactionLoaded state) {
    final isSelected = state.currentFilter == filter;

    return AnimatedBuilder(
      animation: _filterController,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? 1.0 + (_filterController.value * 0.05) : 1.0,
          child: FilterWidget(
            label: filter.displayName,
            isSelected: isSelected,
            onTap: () {
              if (state.currentFilter != filter) {
                _previousFilter = state.currentFilter;
                context.read<TransactionBloc>().add(FilterTransactions(filter));
                _triggerFilterAnimation();
              }
            },
          ),
        );
      },
    );
  }

  void _triggerFilterAnimation() {
    _filterController.forward(from: 0).then((_) {
      _filterController.reverse();
    });
    _staggerController.forward(from: 0);
  }

  Widget _buildAnimatedTransactionList(TransactionLoaded state) {
    if (state.filteredTransactions.isEmpty) {
      return _buildAnimatedEmptyState(state);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.filteredTransactions.length,
            itemBuilder: (context, index) {
              return _buildStaggeredTransactionItem(
                state.filteredTransactions[index],
                index,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStaggeredTransactionItem(Transaction transaction, int index) {
    final double start = index * 0.1;
    final double end = start + 0.5;

    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        final double progress = _staggerController.value;
        final double itemProgress = ((progress - start) / (end - start)).clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, 30 * (1 - itemProgress)),
          child: Opacity(
            opacity: itemProgress,
            child: Transform.scale(
              scale: 0.8 + (0.2 * itemProgress),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: TransactionContainer(
                  key: ValueKey(transaction.id),
                  transaction: transaction,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedEmptyState(TransactionLoaded state) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: NotFoundContainer(
              title: 'No Transactions Found',
              description: 'There are no ${state.currentFilter.displayName.toLowerCase()} transactions.',
              icon: Icons.receipt_long_outlined,
              actionLabel: 'Show All',
              onActionTap: () {
                context
                    .read<TransactionBloc>()
                    .add(const FilterTransactions(TransactionFilter.all));
              },
            ),
          ),
        );
      },
    );
  }
}