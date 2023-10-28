import 'package:meta/meta.dart';
import 'dart:convert';

class PlacesResponse {

  String type;
  List<String> query;
  List<Feature> features;
  String attribution;

  PlacesResponse({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  factory PlacesResponse.fromRawJson(String str) => PlacesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => PlacesResponse(
    type: json["type"],
    query: List<String>.from(json["query"].map((x) => x)),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    attribution: json["attribution"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "query": List<dynamic>.from(query.map((x) => x)),
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "attribution": attribution,
  };
}

class Feature {

  String id;
  String type;
  List<String> placeType;
  Properties properties;
  String textEs;
  Language? languageEs;
  String placeNameEs;
  String text;
  Language? language;
  String placeName;
  List<double> center;
  Geometry geometry;
  List<Context> context;
  String? matchingText;
  String? matchingPlaceName;

  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.properties,
    required this.textEs,
    required this.languageEs,
    required this.placeNameEs,
    required this.text,
    required this.language,
    required this.placeName,
    required this.center,
    required this.geometry,
    required this.context,
    required this.matchingText,
    required this.matchingPlaceName,
  });

  factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    type: json["type"],
    placeType: List<String>.from(json["place_type"].map((x) => x)),
    properties: Properties.fromJson(json["properties"]),
    textEs: json["text_es"],
    languageEs: languageValues.map[json["language_es"]],
    placeNameEs: json["place_name_es"],
    text: json["text"],
    language: languageValues.map[json["language"]],
    placeName: json["place_name"],
    center: List<double>.from(json["center"].map((x) => x?.toDouble())),
    geometry: Geometry.fromJson(json["geometry"]),
    context: List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
    matchingText: json["matching_text"],
    matchingPlaceName: json["matching_place_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "place_type": List<dynamic>.from(placeType.map((x) => x)),
    "properties": properties.toJson(),
    "text_es": textEs,
    "language_es": languageValues.reverse[languageEs],
    "place_name_es": placeNameEs,
    "text": text,
    "language": languageValues.reverse[language],
    "place_name": placeName,
    "center": List<dynamic>.from(center.map((x) => x)),
    "geometry": geometry.toJson(),
    "context": List<dynamic>.from(context.map((x) => x.toJson())),
    "matching_text": matchingText,
    "matching_place_name": matchingPlaceName,
  };
}

class Context {
  String id;
  String mapboxId;
  String textEs;
  String text;
  String? wikidata;
  Language? languageEs;
  Language? language;
  ShortCode? shortCode;

  Context({
    required this.id,
    required this.mapboxId,
    required this.textEs,
    required this.text,
    required this.wikidata,
    required this.languageEs,
    required this.language,
    required this.shortCode,
  });

  factory Context.fromRawJson(String str) => Context.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Context.fromJson(Map<String, dynamic> json) => Context(
    id: json["id"],
    mapboxId: json["mapbox_id"],
    textEs: json["text_es"],
    text: json["text"],
    wikidata: json["wikidata"],
    languageEs: languageValues.map[json["language_es"]],
    language: languageValues.map[json["language"]],
    shortCode: shortCodeValues.map[json["short_code"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mapbox_id": mapboxId,
    "text_es": textEs,
    "text": text,
    "wikidata": wikidata,
    "language_es": languageValues.reverse[languageEs],
    "language": languageValues.reverse[language],
    "short_code": shortCodeValues.reverse[shortCode],
  };
}

enum Language { ES }

final languageValues = EnumValues({"es": Language.ES});

enum ShortCode { US, US_NJ, US_NY }

final shortCodeValues = EnumValues({"us": ShortCode.US, "US-NJ": ShortCode.US_NJ, "US-NY": ShortCode.US_NY});

class Geometry {

  List<double> coordinates;
  String type;

  Geometry({
    required this.coordinates,
    required this.type,
  });

  factory Geometry.fromRawJson(String str) => Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    "type": type,
  };
}

class Properties {
  String? foursquare;
  String? address;
  String? wikidata;
  bool? landmark;
  String? category;
  String? maki;

  Properties({
    required this.foursquare,
    required this.address,
    required this.wikidata,
    required this.landmark,
    required this.category,
    required this.maki,
  });

  factory Properties.fromRawJson(String str) =>
      Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    foursquare: json["foursquare"],
    address: json["address"],
    wikidata: json["wikidata"],
    landmark: json["landmark"],
    category: json["category"],
    maki: json["maki"],
  );

  Map<String, dynamic> toJson() => {
    "foursquare": foursquare,
    "address": address,
    "wikidata": wikidata,
    "landmark": landmark,
    "category": category,
    "maki": maki,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
