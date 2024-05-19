import 'package:Talks/modals/imagesModal.dart';
import 'package:Talks/repo/image_respository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkImagePicker extends StatelessWidget {
  final Function(String) ImageSelected;
  NetworkImagePicker({super.key, required this.ImageSelected});
  final ImageRepository _imageRepo = ImageRepository();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<imageModal>>(
        future: _imageRepo.getNetworkImages(),
        builder:
            (BuildContext context, AsyncSnapshot<List<imageModal>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    maxCrossAxisExtent:
                        MediaQuery.of(context).size.width * 0.5),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        ImageSelected(snapshot.data![index].urlSmallSize);
                      },
                      child: Image.network(snapshot.data![index].urlSmallSize));
                });
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('Getting this error ${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
