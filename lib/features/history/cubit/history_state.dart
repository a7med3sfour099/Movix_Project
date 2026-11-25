import 'package:movixapp/core/network/app_exceptions.dart';
import 'package:movixapp/features/home/data/media_item.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<MediaItem> items;
  HistoryLoaded(this.items);
}

class HistoryError extends HistoryState {
  final AppException exception;
  HistoryError(this.exception);
}
