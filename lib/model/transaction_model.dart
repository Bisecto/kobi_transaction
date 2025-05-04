import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:kobi_test/res/app_icons.dart';

import '../res/app_colors.dart';
import '../res/app_enums.dart';



class Transaction extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionStatus status;
  final String description;

  const Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
  });

  @override
  List<Object> get props => [id, amount, date, status, description];
}

extension TransactionStatusExtension on TransactionStatus {
  String get displayName {
    switch (this) {
      case TransactionStatus.successful:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  String get iconAsset {
    switch (this) {
      case TransactionStatus.successful:
        return AppSvgImages.successIcon;
      case TransactionStatus.pending:
        return AppSvgImages.pendingIcon;
      case TransactionStatus.failed:
        return AppSvgImages.failedIcon;
    }
  }

  Color get colorHex {
    switch (this) {
      case TransactionStatus.successful:
        return AppColors.green;
      case TransactionStatus.pending:
        return AppColors.orange;
      case TransactionStatus.failed:
        return AppColors.red;
    }
  }
}

extension TransactionFilterExtension on TransactionFilter {
  String get displayName {
    switch (this) {
      case TransactionFilter.all:
        return 'All';
      case TransactionFilter.successful:
        return 'Successful';
      case TransactionFilter.pending:
        return 'Pending';
      case TransactionFilter.failed:
        return 'Failed';
    }
  }
}