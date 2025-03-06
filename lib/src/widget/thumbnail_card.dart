import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ThumbnailCard extends StatelessWidget {
  const ThumbnailCard(
      {Key? key,
      required this.title,
      this.subtitle,
      required this.image,
      required this.onPressed})
      : super(key: key);

  final String title;
  final String? subtitle;
  final String image;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: AspectRatio(
        aspectRatio: 13 / 7,
        child: Stack(
          children: [
            GestureDetector(
              onTap: onPressed,
              child: Hero(
                tag: title,
                child: PhysicalModel(
                  elevation: 8,
                  color: Colors.black12,
                  shadowColor: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    Image(
                      image: CachedNetworkImageProvider(
                        image,),

                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black12,
                        Colors.black38,
                      ]),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white,
                      fontFamily: 'InkaBDisplay_Bold',
                      fontSize: 15,
                      letterSpacing: 0.5),
                    ),
                    Text(
                      subtitle ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.white,
                        fontSize: 11,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
