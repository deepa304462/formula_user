
import 'package:flutter/material.dart';

import '../../models/content_item_model.dart';

class NetworkImageBuilderWidget extends StatelessWidget {
  final String imageUrl;

  const NetworkImageBuilderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        double? progressValue = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 0)
            : null;
        int downloaded = (loadingProgress.cumulativeBytesLoaded / 1024).round(); // KB
        int total = (loadingProgress.expectedTotalBytes! / 1024).round(); // KB

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loading_icon.gif',height: 150,width: 150,),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/4,
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: progressValue,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('$downloaded KB / $total KB'),
                  const Text('Downloading...'),
                ],
              ),
            ],
          ),
        );
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error),
            SizedBox(height: 10),
            Text('Failed to load image'),
          ],
        );
      },
    );
  }
}
