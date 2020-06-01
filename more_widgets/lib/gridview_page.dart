import 'package:flutter/material.dart';

class GridViewPage extends StatelessWidget {
  const GridViewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView'),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(200, (index) {
            return Container(
              color: index % 2 == 0 ? Colors.green : Colors.red,
              child: Center(
                child: Text('$index'),
              ),
            );
          })
          // children: [1, 2, 3, 4, 5, 6, 7, 8, 9]
          //     .map((num) => Container(
          //           color: num % 2 == 0 ? Colors.green : Colors.red,
          //           child: Center(
          //             child: Text(num.toString()),
          //           ),
          //         ))
          //     .toList(),
          ),
    );
  }
}
