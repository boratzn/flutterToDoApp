import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/widgets/task_list_item.dart';

import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, allTasks);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where(
          (gorev) => gorev.ad.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: ((context, index) {
              var oAnkiTask = filteredList.elementAt(index);
              return Dismissible(
                  dismissThresholds: {DismissDirection.startToEnd: 0.4},
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      children: const [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Görev Silindi')
                      ],
                    ),
                  ),
                  key: Key(oAnkiTask.id),
                  onDismissed: (direction) async {
                    allTasks.removeAt(index);
                    await locator<LocalStorage>().deleteTask(task: oAnkiTask);
                  },
                  child: TaskItem(task: oAnkiTask));
            }))
        : const Center(child: Text('Eşeleşen görev yok.'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
