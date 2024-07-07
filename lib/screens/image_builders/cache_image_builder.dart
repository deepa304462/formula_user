
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CachedImageBuilderWidget extends StatelessWidget {
  final String imageUrl;

  const CachedImageBuilderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, progress) {
        double progressValue = progress.progress ?? 0;
        int downloaded = (progress.downloaded / 1024).round(); // KB
        int total = ((progress.totalSize ?? 0) / 1024).round(); // KB
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
      errorWidget: (context, url, error) => const Column(
        children: [
          Icon(Icons.error)
        ],
      ),
    );
  }
}
