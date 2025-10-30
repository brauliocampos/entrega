class AddressModel {
  final String address;
  final String houseNumber;
  final String streetNumber;
  final String floorNumber;
  final String id;
  final String? uid;
  final double lat;
  final double long;

  AddressModel(
      {required this.address,
      required this.houseNumber,
      required this.id,
      required this.streetNumber,
      required this.floorNumber,
      this.uid,
      required this.lat,
      required this.long});

  AddressModel.fromMap(Map<String, dynamic> data, this.uid)
      : address = data['Addresses'],
        houseNumber = data['houseNumber'],
        streetNumber = data['streetNumber'],
        floorNumber = data['floorNumber'],
        lat = data['lat'],
        long = data['long'],
        id = data['id'];

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
      'Addresses': address,
      'houseNumber': houseNumber,
      'streetNumber': streetNumber,
      'floorNumber': floorNumber,
      'id': id
    };
  }
}
