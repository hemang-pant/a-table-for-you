import 'package:tableforyou/blocs/application_bloc.dart';
import 'package:tableforyou/screens/sidebar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pay/pay.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home-screen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapController = Completer();


  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.restaurantsInfo = [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '1',
        status: PaymentItemStatus.final_price,
      )
    ];
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.01, 0.2, 1],
            colors: [
              Color.fromRGBO(255, 45, 45, 1),
              Color.fromRGBO(255, 105, 105, 1),
              Colors.white
            ],
          ),
        ),
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 300.0,
                  child: (applicationBloc.currentLocation == null)
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                applicationBloc.currentLocation!.latitude,
                                applicationBloc.currentLocation!.longitude),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                          },
                          markers: Set<Marker>.of(applicationBloc.markers),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Find Nearest Restaurants',
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: (applicationBloc.restaurantsInfo.isEmpty)
                    ? SizedBox(
                      height: 20,
                      child: const CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: applicationBloc.restaurantsInfo.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return ListTile(
                            title: Text(
                                applicationBloc.restaurantsInfo[index].name),
                            subtitle: Text(applicationBloc
                                .restaurantsInfo[index].formattedAddress),
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                            ),
                            onTap: () => showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0))),
                                clipBehavior: Clip.none,
                                context: context,
                                builder: (context) => buildsheet(paymentItems)),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    Navigator.of(context).pop();
    debugPrint(paymentResult.toString());
  }

  Widget buildsheet(List<PaymentItem> paymentItems) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GooglePayButton(
            paymentConfigurationAsset: 'gpay.json',
            paymentItems: paymentItems,
            style: GooglePayButtonStyle.white,
            width: 200,
            height: 50,
            type: GooglePayButtonType.checkout,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: onGooglePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
}
