// transaction_activity_screen.dart
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Load transactions when screen initializes
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const CustomText(
          text: 'Transaction Activity',
          size: 20,
          weight: FontWeight.bold,
          color: Colors.black87,
        ),
        centerTitle: true,
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          // Trigger animation when transactions are loaded
          if (state is TransactionLoaded) {
            _animationController.forward(from: 0);
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: AppLoadingPage("Fetching transactions...")
              );
            }

            if (state is TransactionError) {
              return NotFoundContainer(
                title: 'Error Loading Transactions',
                description: state.message,
                icon: Icons.error_outline,
                actionLabel: 'Retry',
                onActionTap: () {
                  context.read<TransactionBloc>().add(LoadTransactions());
                },
              );
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
                          _buildFilterSection(state, isWebOrTablet),
                          Expanded(
                            child: _buildTransactionList(state),
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

  Widget _buildFilterSection(TransactionLoaded state, bool isWebOrTablet) {
    return Container(
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
              children: TransactionFilter.values.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterWidget(
                    label: filter.displayName,
                    isSelected: state.currentFilter == filter,
                    onTap: () {
                      context
                          .read<TransactionBloc>()
                          .add(FilterTransactions(filter));
                      _animationController.forward(from: 0);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(TransactionLoaded state) {
    if (state.filteredTransactions.isEmpty) {
      return NotFoundContainer(
        title: 'No Transactions Found',
        description: 'There are no ${state.currentFilter.displayName.toLowerCase()} transactions.',
        icon: Icons.receipt_long_outlined,
        actionLabel: 'Show All',
        onActionTap: () {
          context
              .read<TransactionBloc>()
              .add(const FilterTransactions(TransactionFilter.all));
        },
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = state.filteredTransactions[index];
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: TransactionContainer(
              key: ValueKey(transaction.id),
              transaction: transaction,
            ),
          );
        },
      ),
    );
  }
}