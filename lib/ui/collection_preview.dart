import 'package:flutter/material.dart';
import 'package:frontend/ui/themed/themed_card.dart';

class CollectionPreview extends StatelessWidget {
  const CollectionPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Text('Collection $index'),
            ),
          );
        },
      ),
    );
  }
}
