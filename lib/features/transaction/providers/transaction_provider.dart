import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/transaction.dart';
import '../../../helpers/database_helper.dart';

String _escapeCsvValue(Object? value) {
  var text = value?.toString() ?? '';
  if (text.startsWith('=') ||
      text.startsWith('+') ||
      text.startsWith('-') ||
      text.startsWith('@')) {
    text = '\'$text';
  }
  return '"${text.replaceAll('"', '""')}"';
}

class TransactionState {
  final List<CoffeeTransaction> transactions;
  final int weeklyBudget;
  final int monthlyBudget;
  final bool isLoading;

  TransactionState({
    required this.transactions,
    required this.weeklyBudget,
    required this.monthlyBudget,
    required this.isLoading,
  });

  TransactionState copyWith({
    List<CoffeeTransaction>? transactions,
    int? weeklyBudget,
    int? monthlyBudget,
    bool? isLoading,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // --- Computed values ---
  int get todayTotal {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return transactions
        .where((t) =>
            t.date.isAfter(today.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(today.add(const Duration(days: 1))))
        .fold(0, (sum, t) => sum + t.price);
  }

  int get weeklyTotal {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    return transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end))
        .fold(0, (sum, t) => sum + t.price);
  }

  int get monthlyTotal {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end.add(const Duration(seconds: 1))))
        .fold(0, (sum, t) => sum + t.price);
  }

  int get weeklyTransactionCount {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    return transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end))
        .length;
  }

  int get dailyAverage {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(const Duration(days: 7));
    final weekTx = transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end))
        .toList();
    if (weekTx.isEmpty) return 0;
    final activeDays = weekTx
        .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
        .toSet()
        .length;
    return activeDays > 0 ? weeklyTotal ~/ activeDays : 0;
  }

  int get lastWeekTotal {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day)
        .subtract(const Duration(days: 7));
    final end = DateTime(monday.year, monday.month, monday.day);
    return transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(end))
        .fold(0, (sum, t) => sum + t.price);
  }

  double get weeklyBudgetPercentage {
    if (weeklyBudget <= 0) return 0;
    return (weeklyTotal / weeklyBudget) * 100;
  }

  double get monthlyBudgetPercentage {
    if (monthlyBudget <= 0) return 0;
    return (monthlyTotal / monthlyBudget) * 100;
  }

  List<MapEntry<String, int>> get last7DaysTotals {
    final now = DateTime.now();
    final days = <MapEntry<String, int>>[];
    final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final total = transactions
          .where((t) =>
              t.date.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(dayEnd))
          .fold(0, (sum, t) => sum + t.price);
      days.add(MapEntry(dayNames[day.weekday - 1], total));
    }
    return days;
  }

  Map<String, int> get categoryBreakdown {
    final map = <String, int>{};
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final monthTx = transactions.where(
        (t) => t.date.isAfter(start.subtract(const Duration(seconds: 1))));
    for (var t in monthTx) {
      map[t.category] = (map[t.category] ?? 0) + t.price;
    }
    return map;
  }

  String? getBudgetWarning() {
    if (weeklyBudget > 0 && weeklyBudgetPercentage >= 100) {
      return '⚠️ Budget mingguan terlampaui!';
    }
    if (weeklyBudget > 0 && weeklyBudgetPercentage >= 80) {
      return '⚡ Budget mingguan hampir habis (${weeklyBudgetPercentage.toStringAsFixed(0)}%)';
    }
    if (monthlyBudget > 0 && monthlyBudgetPercentage >= 100) {
      return '⚠️ Budget bulanan terlampaui!';
    }
    if (monthlyBudget > 0 && monthlyBudgetPercentage >= 80) {
      return '⚡ Budget bulanan hampir habis (${monthlyBudgetPercentage.toStringAsFixed(0)}%)';
    }
    return null;
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier()
      : super(TransactionState(
          transactions: [],
          weeklyBudget: 0,
          monthlyBudget: 0,
          isLoading: true,
        )) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);

    final transactions = await DatabaseHelper.instance.getAllTransactions();
    final prefs = await SharedPreferences.getInstance();
    final weeklyBudget = prefs.getInt('weeklyBudget') ?? 0;
    final monthlyBudget = prefs.getInt('monthlyBudget') ?? 0;

    state = state.copyWith(
      transactions: transactions,
      weeklyBudget: weeklyBudget,
      monthlyBudget: monthlyBudget,
      isLoading: false,
    );
  }

  Future<void> addTransaction(CoffeeTransaction t) async {
    await DatabaseHelper.instance.insertTransaction(t);
    final newList = List<CoffeeTransaction>.from(state.transactions)
      ..insert(0, t);
    state = state.copyWith(transactions: newList);
  }

  Future<void> updateTransaction(CoffeeTransaction t) async {
    await DatabaseHelper.instance.updateTransaction(t);
    final newList = List<CoffeeTransaction>.from(state.transactions);
    final index = newList.indexWhere((tx) => tx.id == t.id);
    if (index != -1) {
      newList[index] = t;
      state = state.copyWith(transactions: newList);
    }
  }

  Future<void> deleteTransaction(String id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    final newList = List<CoffeeTransaction>.from(state.transactions)
      ..removeWhere((t) => t.id == id);
    state = state.copyWith(transactions: newList);
  }

  Future<void> setWeeklyBudget(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('weeklyBudget', amount);
    state = state.copyWith(weeklyBudget: amount);
  }

  Future<void> setMonthlyBudget(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('monthlyBudget', amount);
    state = state.copyWith(monthlyBudget: amount);
  }

  Future<void> exportToCSV() async {
    final rows = <List<Object?>>[
      [
        'ID',
        'Coffee Name',
        'Price',
        'Date',
        'Category',
        'Location',
        'Note',
        'Latitude',
        'Longitude',
        'Location Source',
        'Coffeeshop ID',
        'Source',
        'Transaction Time',
      ],
      for (final t in state.transactions)
        [
          t.id,
          t.coffeeName,
          t.price,
          t.date.toIso8601String(),
          t.category,
          t.location ?? '',
          t.note ?? '',
          t.locationLat ?? '',
          t.locationLng ?? '',
          t.locationSource?.name ?? '',
          t.coffeeshopId ?? '',
          t.source.name,
          t.transactionTime.toIso8601String(),
        ],
    ];
    final csv =
        rows.map((row) => row.map(_escapeCsvValue).join(',')).join('\n');

    final directory = await getTemporaryDirectory();
    final file = File(
        '${directory.path}/riwayat_kopi_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString('$csv\n');

    final xFile = XFile(file.path);
    // ignore: deprecated_member_use
    await Share.shareXFiles([xFile],
        text: 'Riwayat Pengeluaran Kopi dari BrewBudget');
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier();
});
