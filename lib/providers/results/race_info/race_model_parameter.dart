import 'package:equatable/equatable.dart';


// TODO(info): так делать для family future providers
// For families to work correctly, it is critical for the parameter passed to a
// provider to have a consistent hashCode and ==.

class RaceModelParameter extends Equatable {
  final List<String> yearRound;

  @override
  List<Object?> get props => [yearRound];

  const RaceModelParameter({required this.yearRound});
}
