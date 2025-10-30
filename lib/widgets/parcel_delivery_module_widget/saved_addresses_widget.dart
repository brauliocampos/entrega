import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/address.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/addresses_page_provider.dart';

class SavedAddressesWidget extends ConsumerStatefulWidget {
  const SavedAddressesWidget({super.key});

  @override
  ConsumerState<SavedAddressesWidget> createState() =>
      _SavedAddressesWidgetState();
}

class _SavedAddressesWidgetState extends ConsumerState<SavedAddressesWidget> {
  @override
  void initState() {
    super.initState();
  }

  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    var addresses = ref.watch(getDeliveryAddressesProvider).value;
    logger.d(addresses);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Addresses',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width >= 1100 ? 15 : 15),
        ).tr(),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         context.pop();
        //       },
        //       icon: Icon(Icons.close))
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(10),
            addresses != null
                ? addresses.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.delivery_dining_outlined,
                          color: appColor,
                          size: MediaQuery.of(context).size.width >= 1100
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 1.5,
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          AddressModel addressModel = addresses[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context, addressModel);
                                  },
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  leading: Text(
                                    'Address',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ).tr(),
                                  title: Text(
                                    addressModel.address,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
