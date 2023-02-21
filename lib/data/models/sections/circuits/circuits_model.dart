import 'package:flutter/foundation.dart';

@immutable
class CircuitsModel {
  const CircuitsModel({
    required this.circuitTable,
  });

  final CircuitTable circuitTable;

  factory CircuitsModel.fromJson(Map<String, dynamic> json) => CircuitsModel(
      circuitTable:
          CircuitTable.fromJson(json['CircuitTable'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {'CircuitTable': circuitTable.toJson()};

  CircuitsModel clone() => CircuitsModel(circuitTable: circuitTable.clone());

  CircuitsModel copyWith({CircuitTable? circuitTable}) => CircuitsModel(
        circuitTable: circuitTable ?? this.circuitTable,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircuitsModel && circuitTable == other.circuitTable;

  @override
  int get hashCode => circuitTable.hashCode;
}

@immutable
class CircuitTable {
  const CircuitTable({
    required this.circuits,
  });

  final List<CircuitModel> circuits;

  factory CircuitTable.fromJson(Map<String, dynamic> json) => CircuitTable(
      circuits: (json['Circuits'] as List? ?? [])
          .map((e) => CircuitModel.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() =>
      {'Circuits': circuits.map((e) => e.toJson()).toList()};

  CircuitTable clone() =>
      CircuitTable(circuits: circuits.map((e) => e.clone()).toList());

  CircuitTable copyWith({List<CircuitModel>? circuits}) => CircuitTable(
        circuits: circuits ?? this.circuits,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircuitTable && circuits == other.circuits;

  @override
  int get hashCode => circuits.hashCode;
}

@immutable
class CircuitModel {
  const CircuitModel({
    required this.circuitId,
    required this.url,
    required this.circuitName,
    required this.location,
  });

  final String circuitId;
  final String url;
  final String circuitName;
  final Location location;

  factory CircuitModel.fromJson(Map<String, dynamic> json) => CircuitModel(
      circuitId: json['circuitId'].toString(),
      url: json['url'].toString(),
      circuitName: json['circuitName'].toString(),
      location: Location.fromJson(json['Location'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {
        'circuitId': circuitId,
        'url': url,
        'circuitName': circuitName,
        'Location': location.toJson()
      };

  CircuitModel clone() => CircuitModel(
      circuitId: circuitId,
      url: url,
      circuitName: circuitName,
      location: location.clone());

  CircuitModel copyWith(
          {String? circuitId,
          String? url,
          String? circuitName,
          Location? location}) =>
      CircuitModel(
        circuitId: circuitId ?? this.circuitId,
        url: url ?? this.url,
        circuitName: circuitName ?? this.circuitName,
        location: location ?? this.location,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircuitModel &&
          circuitId == other.circuitId &&
          url == other.url &&
          circuitName == other.circuitName &&
          location == other.location;

  @override
  int get hashCode =>
      circuitId.hashCode ^
      url.hashCode ^
      circuitName.hashCode ^
      location.hashCode;
}

@immutable
class Location {
  const Location({
    required this.lat,
    required this.long,
    required this.locality,
    required this.country,
  });

  final String lat;
  final String long;
  final String locality;
  final String country;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
      lat: json['lat'].toString(),
      long: json['long'].toString(),
      locality: json['locality'].toString(),
      country: json['country'].toString());

  Map<String, dynamic> toJson() =>
      {'lat': lat, 'long': long, 'locality': locality, 'country': country};

  Location clone() =>
      Location(lat: lat, long: long, locality: locality, country: country);

  Location copyWith(
          {String? lat, String? long, String? locality, String? country}) =>
      Location(
        lat: lat ?? this.lat,
        long: long ?? this.long,
        locality: locality ?? this.locality,
        country: country ?? this.country,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          lat == other.lat &&
          long == other.long &&
          locality == other.locality &&
          country == other.country;

  @override
  int get hashCode =>
      lat.hashCode ^ long.hashCode ^ locality.hashCode ^ country.hashCode;
}
