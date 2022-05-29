class Placeitem {
  Placeitem({
    required this.formattedAddress,
    required this.geometry,
    required this.name,
    required this.placeId,
  });
  late final String formattedAddress;
  late final Geometry geometry;
  late final String name;
  late final String placeId;
  
  Placeitem.fromJson(Map<String, dynamic> json){
    formattedAddress = json['formatted_address'];
    geometry = Geometry.fromJson(json['geometry']);
    name = json['name'];
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formatted_address'] = formattedAddress;
    data['geometry'] = geometry.toJson();
    data['name'] = name;
    data['place_id'] = placeId;
    return data;
  }
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });
  late final Location location;
  late final Viewport viewport;
  
  Geometry.fromJson(Map<String, dynamic> json){
    location = Location.fromJson(json['location']);
    viewport = Viewport.fromJson(json['viewport']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['location'] = location.toJson();
    data['viewport'] = viewport.toJson();
    return data;
  }
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;
  
  Location.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });
  late final Northeast northeast;
  late final Southwest southwest;
  
  Viewport.fromJson(Map<String, dynamic> json){
    northeast = Northeast.fromJson(json['northeast']);
    southwest = Southwest.fromJson(json['southwest']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['northeast'] = northeast.toJson();
    data['southwest'] = southwest.toJson();
    return data;
  }
}

class Northeast {
  Northeast({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;
  
  Northeast.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Southwest {
  Southwest({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;
  
  Southwest.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class OpeningHours {
  OpeningHours({
    required this.openNow,
  });
  late final bool openNow;
  
  OpeningHours.fromJson(Map<String, dynamic> json){
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['open_now'] = openNow;
    return data;
  }
}

class Photos {
  Photos({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });
  late final int height;
  late final List<String> htmlAttributions;
  late final String photoReference;
  late final int width;
  
  Photos.fromJson(Map<String, dynamic> json){
    height = json['height'];
    htmlAttributions = List.castFrom<dynamic, String>(json['html_attributions']);
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['height'] = height;
    data['html_attributions'] = htmlAttributions;
    data['photo_reference'] = photoReference;
    data['width'] = width;
    return data;
  }
}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });
  late final String compoundCode;
  late final String globalCode;
  
  PlusCode.fromJson(Map<String, dynamic> json){
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['compound_code'] = compoundCode;
    data['global_code'] = globalCode;
    return data;
  }
}