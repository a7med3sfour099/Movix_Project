import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/actors/data/actors_api.dart';
import 'package:movixapp/features/actors/data/person_details.dart';

class PersonState {
  final bool loading;
  final String? error;
  final PersonDetails? person;

  const PersonState({this.loading = false, this.error, this.person});
}

class PersonCubit extends Cubit<PersonState> {
  final int id;
  final _api = ActorsApi();

  PersonCubit(this.id) : super(const PersonState(loading: true));

  Future<void> load() async {
    emit(const PersonState(loading: true));
    try {
      final person = await _api.getPerson(id);
      if (isClosed) return;
      emit(PersonState(person: person));
    } catch (e) {
      if (isClosed) return;
      emit(const PersonState(error: 'Something went wrong, try again'));
    }
  }
}
