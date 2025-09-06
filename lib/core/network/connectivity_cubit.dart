import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { online, offline, unknown }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit() : super(ConnectivityStatus.unknown);

  Future<void> monitor() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    _emitFromResult(result);
    connectivity.onConnectivityChanged.listen((result) {
      _emitFromResult(result);
    });
  }

  void _emitFromResult(List<ConnectivityResult> results) {
    final hasNet = results.any((r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi || r == ConnectivityResult.ethernet);
    emit(hasNet ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }
}
