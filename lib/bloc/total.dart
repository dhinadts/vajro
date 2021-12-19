import 'dart:async';

import 'bloc.dart';

class CalculateTotalBloc implements Bloc {
  late double _total = 0;
  double get total => _total;

  // 1
  final _totalController = StreamController<double>();

  // 2
  Stream<double> get totalStream => _totalController.stream;

  // 3
  void calCulateTotal(double total) {
    _total = _total + total;
    _totalController.sink.add(total);
  }

  // 4
  @override
  void dispose() {
    _totalController.close();
  }
}
