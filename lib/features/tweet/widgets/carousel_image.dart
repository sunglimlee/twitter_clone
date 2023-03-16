import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  final List<String> _imageLinks;
  const CarouselImage({Key? key, required List<String> imageLinks}) : _imageLinks = imageLinks, super(key: key);

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _current = 0; // 맨처음 0 부터

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget._imageLinks.map(
                    (link) {
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    margin: const EdgeInsets.all(10),
                    child: Image.network(link, fit: BoxFit.contain,),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                //height: 400, // 여기를 없애자.. 그럼 알아서 들어간다.
                viewportFraction: 0.8, // 그림 하나를 화면에 보여주는 비율 나머지 0.3 은 다른 그림이 조금씩 차지..
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index; // 나중에 이 값에 대해서 뭔가를 하기 위해서 꼭 필요하구나..
                  });
                }
              ),
            ),
            // 여러가지 작은 아이콘들 배치하는 부분
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget._imageLinks.asMap().entries.map((e) {
                return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(_current == e.key ? 0.9 : 0.4)),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
