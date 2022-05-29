import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tableforyou/models/geometry.dart' as geometry;
import 'package:tableforyou/models/location.dart' as location;
import 'package:tableforyou/models/place.dart';
import 'package:tableforyou/models/place_item.dart';
import 'package:tableforyou/models/place_search.dart';
import 'package:tableforyou/services/geolocator_service.dart';
import 'package:tableforyou/services/marker_service.dart';
import 'package:tableforyou/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();


  //Variables
  Position? currentLocation;
  late List<PlaceSearch> searchResults;
  late StreamController<Place> selectedLocation = StreamController<Place>();
  late StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  late Place selectedLocationStatic;
  late String placeType;
  late List<Placeitem> placeResults;
  List<Marker> markers = [];
  late List<Placeitem> restaurantsInfo;

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: geometry.Geometry(
        location: location.Location(
            lat: currentLocation!.latitude, lng: currentLocation!.longitude),
      ),
      vicinity: '',
    );
    placeType = 'restaurant';

    var places = await placesService.getPlaces(
        selectedLocationStatic.geometry.location.lat,
        selectedLocationStatic.geometry.location.lng,
        placeType);
    markers = [];
    placeResults = places;
    restaurantsInfo = places;
    if (places.isNotEmpty) {
      for (var v = 0; v < places.length; v++) {
        Place temp = Place(
      name: null,
      geometry: geometry.Geometry(
        location: location.Location(
            lat: places[v].geometry.location.lat, lng: places[v].geometry.location.lng),
      ),
      vicinity: '',
    );

        var newMarker = markerService.createMarkerFromPlace(temp, false);
        markers.add(newMarker);
      }
    }

    var locationMarker =
        markerService.createMarkerFromPlace(selectedLocationStatic, true);
    markers.add(locationMarker);

    var _bounds = markerService.bounds(Set<Marker>.of(markers));
    bounds.add(_bounds!);
    notifyListeners();
  }
}
