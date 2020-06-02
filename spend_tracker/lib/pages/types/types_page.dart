import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/models.dart';
import 'package:spend_tracker/pages/types/type_page.dart';

class TypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Types'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => TypePage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<List<ItemType>>(
          stream: bloc.itemTypes,
          builder: (_, AsyncSnapshot<List<ItemType>> snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text(snapshot.error.toString()),
              );

            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            var types = snapshot.data;

            if (types.length == 0)
              return Center(
                child: const Text('No Records'),
              );

            return ListView.builder(
                itemCount: types.length,
                itemBuilder: (_, int index) {
                  var type = types[index];

                  return ListTile(
                    leading: Hero(
                      tag: type.urlId,
                      child: Icon(type.iconData),
                    ),
                    title: Text(type.name),
                    onTap: () {
                      Navigator.push(
                        _,
                        MaterialPageRoute(
                            builder: (_) => TypePage(
                                  type: type,
                                )),
                      );
                    },
                  );
                });
          },
        ));
  }
}
