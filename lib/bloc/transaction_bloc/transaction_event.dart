import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../res/app_enums.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class FilterTransactions extends TransactionEvent {
  final TransactionFilter filter;

  const FilterTransactions(this.filter);

  @override
  List<Object> get props => [filter];
}
