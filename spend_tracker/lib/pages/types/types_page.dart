import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/pages/types/type_page.dart';

class TypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Types'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'add',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TypePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ItemType>>(
        future: dbProvider.getAllTypes(),
        builder: (_, AsyncSnapshot<List<ItemType>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );
          var types = snapshot.data;
          if (types.length == 0) {
            return Center(
              child: const Text('No Records'),
            );
          }

          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (_, int index) {
              var type = types[index];
              return ListTile(
                leading: Icon(type.iconData),
                title: Text(type.name != null ? type.name : ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TypePage(
                        type: type,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
