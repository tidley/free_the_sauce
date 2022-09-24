import 'package:geolocator/geolocator.dart';

class Gps {
  late String lat = "0";
  late String long = "0";
  hasGps() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      print("GPS service is enabled");
    } else {
      print("GPS service is disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
      } else {
        print('GPS Location service is granted');
        // await updatePosition();
      }
    } else {
      print("GPS Location permission granted.");
    }
  }

  updatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String long = position.longitude.toString();
    String lat = position.latitude.toString();
    print("long");
    print(long);
    this.long = long;
    print("lat");
    print(lat);
    this.lat = lat;
  }
}
