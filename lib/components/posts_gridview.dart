import 'package:flutter/material.dart';
import 'package:social_app/data/image_data.dart';

class PostsGridView extends StatelessWidget {
  const PostsGridView({
    super.key,
    required this.imageDataList,
  });

  final List<ImageData> imageDataList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      //primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: imageDataList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7), // ----- width/height
      itemBuilder: (context, index){
        return Card(
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft,child: Text(imageDataList[index].uploaderHandle??'name')),
              Container( // or ClipRRect
                width: 130,
                height: 130,
                color: Colors.grey.shade300,
                child: Image.network(imageDataList[index].picUrl??"", fit: BoxFit.contain), // BoxFit.contain: keeps aspect ratio
              ),
              Align(alignment: Alignment.centerLeft,child: Text(imageDataList[index].dateTime??'time')),
              const SizedBox(height: 8),
              Text(imageDataList[index].description??'description'),
            ],
          ),
        );
      },
    );
  }
}