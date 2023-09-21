import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';





class PaywallWidget extends StatefulWidget {


  final String title;
  final String description;
  final List<Package>? packages;
  final ValueChanged<Package> onCLickedPackage;

  const PaywallWidget({Key? key, required this.title, required this.description, required this.packages, required this.onCLickedPackage}) : super(key: key);

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Text(widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),

            Text(widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),

            buildPackages(),

          ],
        ),
      ),
    );
  }

  Widget buildPackages(){
    return ListView.builder(
      shrinkWrap: true,
        primary: false,
        itemCount: widget.packages?.length,
        itemBuilder: (context, index)
        {

          final package = widget.packages?[index];

            return buildPackage(context, package!, index);
    });
  }

  Widget buildPackage(BuildContext context, Package package, int index){

    final product = package.storeProduct;

    print("product ${product.identifier}  ${product.price}");

    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.black12,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          index == 0 ? "Monthly" : index == 1 ? "Yearly" : "Yearly",
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(index == 0 ? "Monthly Package" : index == 1 ? "Yearly Package" : "Yearly Package",),
        trailing: Text(
          product.priceString,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        onTap: () => widget.onCLickedPackage(package),
      ),
    );

  }
}
