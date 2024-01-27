import 'package:flowerstore/presentation/screen/analytic/analytic_screen.dart';

import '../../../domain/entity/invoice.dart';

extension AnalyticScreenViewModel on AnalyticScreenState {
  double calculateYearlyTotal(List<Invoice> invoices) {
    int currentYear = DateTime.now().year;
    double yearlyTotal = 0.0;

    for (var invoice in invoices) {
      if (invoice.date.year == currentYear) {
        yearlyTotal += invoice.discountedTotal;
      }
    }
    return yearlyTotal;
  }

  double calculateTotalWithinRange(List<Invoice> invoices, int startYear,
      int startMonth, int endYear, int endMonth) {
    double total = 0.0;

    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
          (invoice.date.year == startYear &&
              invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        total += invoice.total;
      }
    }
    return total;
  }

  double calculateDiscountedTotalWithinRange(List<Invoice> invoices, int startYear,
      int startMonth, int endYear, int endMonth) {
    double total = 0.0;

    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
          (invoice.date.year == startYear &&
              invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        total += invoice.discountedTotal;
      }
    }
    return total;
  }

  double calculateDiscountWithinRange(List<Invoice> invoices, int startYear,
      int startMonth, int endYear, int endMonth) {
    double total = 0.0;

    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
          (invoice.date.year == startYear &&
              invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        total += invoice.discount;
      }
    }
    return total;
  }

  Map<DateTime, double> aggregateTotalsByMonth(List<Invoice> invoices) {
    Map<DateTime, double> monthlyTotals = {};
    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
          (invoice.date.year == startYear &&
              invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        DateTime monthKey = DateTime(invoice.date.year, invoice.date.month);
        double total = invoice.total;

        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals[monthKey] = monthlyTotals[monthKey]! + total;
        } else {
          monthlyTotals[monthKey] = total;
        }
      }
    }
    return monthlyTotals;
  }

  Map<DateTime, double> aggregateDiscountedTotalsByMonth(List<Invoice> invoices) {
    Map<DateTime, double> monthlyTotals = {};
    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
          (invoice.date.year == startYear &&
              invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        DateTime monthKey = DateTime(invoice.date.year, invoice.date.month);
        double total = invoice.discountedTotal;

        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals[monthKey] = monthlyTotals[monthKey]! + total;
        } else {
          monthlyTotals[monthKey] = total;
        }
      }
    }
    return monthlyTotals;
  }

  Map<DateTime, double> aggregateDiscountsByMonth(List<Invoice> invoices) {
    Map<DateTime, double> monthlyTotals = {};
    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
          (invoice.date.year == startYear &&
              invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        DateTime monthKey = DateTime(invoice.date.year, invoice.date.month);
        double total = invoice.discount;

        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals[monthKey] = monthlyTotals[monthKey]! + total;
        } else {
          monthlyTotals[monthKey] = total;
        }
      }
    }
    return monthlyTotals;
  }
}