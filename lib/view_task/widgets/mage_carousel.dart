import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';
import 'package:go_router/go_router.dart';

class CarouselDemo extends StatelessWidget {
  final CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  final Task task;

  CarouselDemo({super.key, required this.task});

  final MyUserRepository _myUserRepository = getIt();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          CarouselSlider(
            items: task.images.map((image) {
              return Image.network("http://localhost:3333${image.url}");
            }).toList(),
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
              initialPage: 2,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoButton.filled(
            onPressed: () {
              context.go('/authed/home/task/images', extra: task);
            },
            child: Text('View all'),
          ),
          const SizedBox(height: 8),
          CupertinoButton.filled(
            onPressed: () {
              _myUserRepository.startTask(task.id);
            },
            child: Text('Start process'),
          )
        ],
      );
}
