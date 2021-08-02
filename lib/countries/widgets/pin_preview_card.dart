part of countries.widgets;

class PinPreviewCard extends StatelessWidget {
  PinPreviewCard({this.onTap});

  final Function() onTap;
  final CountriesMapController controller = CountriesMapController();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(16));

    return SizedBox(
      height: 215,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        elevation: 6,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: InkWell(
            splashColor: Colors.black,
            borderRadius: borderRadius,
            onTap: onTap?.call,
            child: AbsorbPointer(
              child: Opacity(
                opacity: .87,
                child: CountriesMap(
                  controller: controller,
                  /*initialCameraPosition: CameraPosition(
                  target: country.latLng,
                  zoom: 1,
                ),*/
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  disableUserLocation: true,
                  onMapCreated: () async {
                    //await controller.setUnlockedCountries([country.code]);
                    //Future.delayed(const Duration(milliseconds: 200), () async {
                    //  await controller.moveCameraToCountry(country);
                    //});
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
