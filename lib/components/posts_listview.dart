import 'package:flutter/material.dart';
import 'package:social_app/data/image_data.dart';

class PostsListView extends StatelessWidget {
  const PostsListView({
    super.key,
    required this.imageDataList,
  });
  final List<ImageData> imageDataList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //primary: false,
      shrinkWrap: true,
      itemCount: imageDataList.length, // order ?
      itemBuilder: (context,index){
        return Card(
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft,child: Text(imageDataList[index].uploaderHandle??'name')),
              Container( // or ClipRRect
                width: 200,
                height: 200,
                color: Colors.grey.shade300,
                child: Image.network(imageDataList[index].picUrl??"", fit: BoxFit.contain), // BoxFit.contain: keeps aspect ratio
              ),
              Align(alignment: Alignment.centerLeft,child: Text("time: ${imageDataList[index].dateTime??'time'}")),
              const SizedBox(height: 8),
              const Align(alignment: Alignment.centerLeft,child: Text("description: ")),
              Text(imageDataList[index].description??'description'),
            ],
          ),
        );
      },
    );
  }
}