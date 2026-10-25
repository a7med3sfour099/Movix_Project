import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable{
  const ChangePasswordState();

  @override
  List<Object?> get props => [];

  }

class ChangePasswordInitial extends ChangePasswordState{}

class ChangePasswordLoading extends ChangePasswordState{}

class ChangePasswordSuccess extends ChangePasswordState{}

class ChangePasswordFailure extends ChangePasswordState{
  final String message;
  const ChangePasswordFailure(this.message);

  @override
  List<Object?> get props => [message];


}
class ChangePasswordTyping extends ChangePasswordState {
  final int version;

  const ChangePasswordTyping(this.version);

  @override
  List<Object?> get props => [version];
}
