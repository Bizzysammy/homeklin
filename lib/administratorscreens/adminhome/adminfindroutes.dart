import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'adminbottom.dart';
import 'package:homeklin/vandriverscreens/vanprovider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class Adminfindroutes extends StatefulWidget {
  const Adminfindroutes ({Key? key}) : super(key: key);
  static const String id = 'bin_collection';

  @override
  State<Adminfindroutes> createState() => AdminfindroutesState();
}

class AdminfindroutesState extends State<Adminfindroutes> {

  Marker currentLocationMarker = const Marker(
    markerId: MarkerId('currentLocation'),
    position: LatLng(0.0, 0.0), // Replace with your initial position
    infoWindow: InfoWindow(title: 'Current Location'),
    icon: BitmapDescriptor.defaultMarker,
  );

  Marker destinationMarker = Marker(
    markerId: const MarkerId('destination'),
    position: const LatLng(0.0, 0.0), // Replace with the selected destination position
    infoWindow: const InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );

  void _searchPlace(String query) async {
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  double responsiveHeight(double height) {
    return MediaQuery.of(context).size.height * (height / 896.0);
  }

  double responsiveWidth(double width) {
    return MediaQuery.of(context).size.width * (width / 414.0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text(
          'Search for the location',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF213C54),
                Color(0xFF0059A5),
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AdminCustomBottomNavigator(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF213C54),
                    Color(0xFF0059A5),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: responsiveHeight(540),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: responsiveHeight(20)),
                  Padding(
                    padding: EdgeInsets.all(responsiveWidth(10)),
                    child: Container(
                      width: double.infinity,
                      height: responsiveHeight(50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(responsiveWidth(5)),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: responsiveWidth(10)),
                          const Icon(Icons.search),
                          SizedBox(width: responsiveWidth(10)),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search for a place',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                _searchPlace(value); // Function to handle navigation to Google Maps
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: responsiveHeight(20)),

                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "searching for the customer's location",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 320,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Consumer<LocationProvider>(
                        builder: (consumerContext, model, child) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: model.locationPosition,
                                    zoom: 15,
                                  ),
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  onMapCreated: (
                                      GoogleMapController controller) {},
                                  markers: {
                                    currentLocationMarker, // Add the current location marker
                                    destinationMarker,    // Add the destination marker
                                  },
                                ),
                              ),
                            ],
                          );

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
