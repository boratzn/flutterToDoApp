import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/helper/translation_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/widgets/task_list_item.dart';

import '../data/local_storage.dart';
import '../models/task_model.dart';
import '../widgets/custom_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTasksFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: (() => _showAddTaskBottomSheet(context)),
          child: const Text(
            'title',
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: (() {
                _showSearchPage();
              }),
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: (() {
                _showAddTaskBottomSheet(context);
              }),
              icon: Icon(Icons.add))
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: ((context, index) {
                var _oAnkiListeElemani = _allTasks[index];
                return Dismissible(
                    dismissThresholds: {DismissDirection.startToEnd: 0.4},
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        children: [
                          const Icon(Icons.delete),
                          const SizedBox(
                            width: 8,
                          ),
                          Text('remove_task').tr()
                        ],
                      ),
                    ),
                    key: Key(_oAnkiListeElemani.id),
                    onDismissed: (direction) {
                      _allTasks.removeAt(index);
                      _localStorage.deleteTask(task: _oAnkiListeElemani);
                      setState(() {});
                    },
                    child: TaskItem(task: _oAnkiListeElemani));
              }))
          : Center(
              child: Text('no_data').tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    hintText: 'add_task'.tr(), border: InputBorder.none),
                onSubmitted: ((value) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(context,
                      showSecondsColumn: false,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      onConfirm: ((time) async {
                    var yeniEklenecekGorev =
                        Task.create(ad: value, createdAt: time);

                    _allTasks.add(yeniEklenecekGorev);
                    await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {});
                  }));
                }),
              ),
            ),
          );
        }));
  }

  void _getAllTasksFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTasksFromDb();
  }
}
