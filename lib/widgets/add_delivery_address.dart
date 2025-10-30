import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/web_menu.dart';
import 'package:user_web/model/address.dart';
import 'package:user_web/constant.dart';

class AddDeliveryAddress extends StatefulWidget {
  const AddDeliveryAddress({super.key});

  @override
  State<AddDeliveryAddress> createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<AddDeliveryAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   elevation: 0,
        //   title: const Text(
        //     'Add A New Delivery Address',
        //     style: TextStyle(fontSize: 15),
        //   ).tr(),
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: [
          MediaQuery.of(context).size.width >= 1100
              ? const Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                            shape: BeveledRectangleBorder(),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: WebMenu(path: '/delivery-addresses')),
                      ),
                      Gap(20),
                      Expanded(
                          flex: 6,
                          child: Card(
                            shape: BeveledRectangleBorder(),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: SingleChildScrollView(
                              child: AddWidget(),
                            ),
                          ))
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AddWidget(),
                ),
          const Gap(20),
          const FooterWidget()
        ],
      ),
    ));
  }
}

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  final _formKey = GlobalKey<FormState>();
  String address = '';
  String houseNumber = '';
  String closestBusStop = '';
  String streetNumber = '';
  DocumentReference? userDetails;
  String id = '';
  double lat = 0;
  double long = 0;

  Future<void> _getUserDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    setState(() {
      id = user!.uid;
    });
  }

  bool useMap = false;
  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  addNewDeliveryAddress(AddressModel addressModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('DeliveryAddress')
        .add(addressModel.toMap())
        .then((value) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      // FirebaseFirestore.instance.collection('users').doc(id).update({
      //   'DeliveryAddress': addressModel.address,
      //   'HouseNumber': addressModel.houseNumber,
      //   'ClosestBustStop': addressModel.closestbusStop,
      //   'DeliveryAddressID': addressModel.id
      // });
      Fluttertoast.showToast(
          msg: "Address has been added".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Column(
        children: [
          // const SizedBox(height: 48),
          const Gap(10),
          //  if (MediaQuery.of(context).size.width >= 1100)
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.bottomLeft
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 20 : 0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const Gap(20),
                  Text(
                    'Add a new delivery address',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width >= 1100
                            ? 15
                            : 15),
                  ).tr(),
                ],
              ),
            ),
          ),
          if (MediaQuery.of(context).size.width >= 1100)
            const Divider(
              color: Color.fromARGB(255, 237, 235, 235),
              thickness: 1,
            ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.location_city,
                      size: 40,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 2, color: Colors.grey.shade400),
                        ),
                      ),
                      child: ListTile(
                        onTap: () async {
                          var result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const OpenStreet();
                          }));
                          // _navigateAndDisplaySelection(context);
                          setState(() {
                            address = result['address'];
                            lat = result['lat'];
                            long = result['long'];
                          });
                        },
                        title: Text(address == '' ? 'Address'.tr() : address,
                                style: TextStyle(color: Colors.grey[600]))
                            .tr(),
                      ),
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.home,
                      size: 40,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field'.tr();
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'House Number'.tr(), focusColor: Colors.grey),
                    onChanged: (value) {
                      setState(() {
                        houseNumber = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.home,
                      size: 40,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field'.tr();
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Floor Number'.tr(), focusColor: Colors.grey),
                    onChanged: (value) {
                      setState(() {
                        closestBusStop = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.home,
                      size: 40,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 6,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field'.tr();
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Street Number'.tr(),
                        focusColor: Colors.grey),
                    onChanged: (value) {
                      setState(() {
                        streetNumber = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                // height: 50,
                width: MediaQuery.of(context).size.width / 1.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const BeveledRectangleBorder(),
                        backgroundColor: appColor),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && address != '') {
                        addNewDeliveryAddress(AddressModel(
                            lat: lat,
                            long: long,
                            streetNumber: streetNumber,
                            address: address,
                            houseNumber: houseNumber,
                            floorNumber: closestBusStop,
                            id: address + houseNumber + closestBusStop));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Select Your Address".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            fontSize: 14.0);
                      }
                    },
                    child: const Text('Save',
                            style: TextStyle(fontSize: 20, color: Colors.white))
                        .tr())),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}

class OpenStreet extends StatefulWidget {
  const OpenStreet({super.key});

  @override
  State<OpenStreet> createState() => _OpenStreetState();
}

class _OpenStreetState extends State<OpenStreet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: OpenStreetMapSearchAndPick(

          // center: LatLong(23, 89),
          buttonColor: appColor,
          buttonTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            Navigator.pop(context, {
              'address': pickedData.addressName,
              'lat': pickedData.latLong.latitude,
              'long': pickedData.latLong.longitude
            });
          }),
    );
  }
}
