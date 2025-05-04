import 'package:bloc/bloc.dart';
import 'package:kobi_test/bloc/transaction_bloc/transaction_event.dart';
import 'package:kobi_test/bloc/transaction_bloc/transaction_state.dart';
import 'package:meta/meta.dart';

import '../../model/transaction_model.dart';
import '../../res/app_enums.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<FilterTransactions>(_onFilterTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      final transactions = _getMockTransactions();
      emit(
        TransactionLoaded(
          transactions: transactions,
          filteredTransactions: transactions,
          currentFilter: TransactionFilter.all,
        ),
      );
    } catch (e) {
      emit(TransactionError('Failed to load transactions'));
    }
  }

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      final filteredTransactions = _filterTransactions(
        currentState.transactions,
        event.filter,
      );

      emit(
        currentState.copyWith(
          filteredTransactions: filteredTransactions,
          currentFilter: event.filter,
        ),
      );
    }
  }

  List<Transaction> _filterTransactions(
    List<Transaction> transactions,
    TransactionFilter filter,
  ) {
    switch (filter) {
      case TransactionFilter.all:
        return transactions;
      case TransactionFilter.successful:
        return transactions
            .where((t) => t.status == TransactionStatus.successful)
            .toList();
      case TransactionFilter.pending:
        return transactions
            .where((t) => t.status == TransactionStatus.pending)
            .toList();
      case TransactionFilter.failed:
        return transactions
            .where((t) => t.status == TransactionStatus.failed)
            .toList();
    }
  }

  List<Transaction> _getMockTransactions() {
    return [
      Transaction(
        id: '1',
        amount: 25000.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: TransactionStatus.successful,
        description: 'Payment to KOBI',
      ),
      Transaction(
        id: '2',
        amount: 7500.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.pending,
        description: 'Transfer to OKAFOR PRECIOUS',
      ),
      Transaction(
        id: '3',
        amount: 3000.00,
        date: DateTime.now().subtract(const Duration(hours: 12)),
        status: TransactionStatus.failed,
        description: 'withdrawal',
      ),
      Transaction(
        id: '4',
        amount: 2000.99,
        date: DateTime.now().subtract(const Duration(hours: 6)),
        status: TransactionStatus.successful,
        description: 'Subscription',
      ),
      Transaction(
        id: '5',
        amount: 50000.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: TransactionStatus.pending,
        description: 'Bill Payment',
      ),
    ];
  }
}
