import 'package:equatable/equatable.dart';

// TODO(info): так делать для family future providers
// For families to work correctly, it is critical for the parameter passed to a
// provider to have a consistent hashCode and ==.


// TODO(info): позволяет добавлять equatable если мы extend'им что-то другое
// class RaceYearRoundParameter with EquatableMixin {

class RaceYearRoundParameter extends Equatable {
  final List<String> yearRound;

// TODO(info): поля, которые находится в скобках, проверяется на равенство
  @override
  List<Object?> get props => [yearRound];

// TODO(info): автоматически помогает отдавать стринговое представление объекта, а не просто instance
  @override
  bool get stringify => true;

  const RaceYearRoundParameter({required this.yearRound});
}
