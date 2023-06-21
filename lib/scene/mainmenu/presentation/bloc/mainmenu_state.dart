part of 'mainmenu_bloc.dart';

@immutable
abstract class MainmenuState extends Equatable {
  const MainmenuState();
}

class MainmenuInitial implements MainmenuState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CustomerDeleted implements MainmenuState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CustomerPatched implements MainmenuState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}