import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/logic/todo_cubit.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {


          AppCubit cubit = AppCubit.get(context);


          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: cubit.tasks.length == 0
                ? const Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Icon(cubit.fabIcon),
              onPressed: () {
                {
                  if (cubit.isBottomSheetShow)
                  {
                    if (formKey.currentState!.validate()) {
                      cubit.insertDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                    } else {
                      scaffoldKey.currentState!.showBottomSheet(
                              (context) => Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.grey[100]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: titleController,
                                              onFieldSubmitted: (value) {
                                                print(value);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Title must not be empty';
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                labelText: 'Task Title',
                                                prefixIcon:
                                                    const Icon(Icons.title),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                ).then(
                                                  (value) {
                                                    timeController.text = value!
                                                        .format(context)
                                                        .toString();
                                                    print(
                                                      value.format(context),
                                                    );
                                                  },
                                                );
                                              },
                                              controller: timeController,
                                              onFieldSubmitted: (value) {
                                                print(value);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'time must not be empty';
                                                }
                                                return null;
                                              },
// enabled: false,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                labelText: 'Task Time',
                                                prefixIcon: const Icon(
                                                    Icons.watch_later_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              onTap: () async {
                                                final currentDate =
                                                    DateTime.now();
                                                final selectedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: currentDate,
                                                  firstDate: currentDate,
                                                  lastDate: currentDate.add(
                                                    const Duration(days: 365),
                                                  ),
                                                );
                                                if (selectedDate != null) {
                                                  final formattedDate =
                                                      DateFormat.yMMMd()
                                                          .format(selectedDate);
                                                }
                                              },
                                              controller: dateController,
                                              onFieldSubmitted: (value) {
                                                print(value);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Date must not be empty';
                                                }
                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                labelText: 'Task Date',
                                                prefixIcon: const Icon(
                                                    Icons.date_range),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              elevation: 50.0)
                          .closed.then((value) {
                        cubit.changeBottomSheetState(
                            isShow: false, icon: Icons.edit);
                      });
                      cubit.changeBottomSheetState(
                          isShow: true, icon: Icons.add);
                    }
                  }
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.task_sharp),
                  label: 'Tasks',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle),
                  label: 'Done',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
