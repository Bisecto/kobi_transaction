import 'package:equatable/equatable.dart';

import '../../model/transaction_model.dart';
import '../../res/app_enums.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;
  final TransactionFilter currentFilter;

  const TransactionLoaded({
    required this.transactions,
    required this.filteredTransactions,
    required this.currentFilter,
  });

  @override
  List<Object> get props => [transactions, filteredTransactions, currentFilter];

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    List<Transaction>? filteredTransactions,
    TransactionFilter? currentFilter,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
