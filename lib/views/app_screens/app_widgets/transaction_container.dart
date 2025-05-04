import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/transaction_model.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_enums.dart';
import '../../widgets/app_custom_text.dart';

class TransactionContainer extends StatelessWidget {
  final Transaction transaction;

  const TransactionContainer({Key? key, required this.transaction})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatusIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: transaction.description,
                        size: 16,
                        weight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: _formatDate(transaction.date),
                        size: 14,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: _formatAmount(transaction.amount),
                      size: 16,
                      weight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                    const SizedBox(height: 4),
                    _buildStatusContainer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color color;

    switch (transaction.status) {
      case TransactionStatus.successful:
        iconData = Icons.check_circle;
        color = const Color(0xFF4CAF50);
        break;
      case TransactionStatus.pending:
        iconData = Icons.access_time;
        color = Colors.orange;
        break;
      case TransactionStatus.failed:
        iconData = Icons.error;
        color = Colors.red;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  Widget _buildStatusContainer() {
    Color color;
    Color backgroundColor;

    switch (transaction.status) {
      case TransactionStatus.successful:
        color = AppColors.green;
        backgroundColor = AppColors.green.withOpacity(0.1);
        break;
      case TransactionStatus.pending:
        color = AppColors.orange;
        backgroundColor = AppColors.orange.withOpacity(0.1);
        break;
      case TransactionStatus.failed:
        color = AppColors.red;
        backgroundColor = AppColors.red.withOpacity(0.1);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomText(
        text: transaction.status.displayName,
        size: 12,
        weight: FontWeight.w500,
        color: color,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }
}
