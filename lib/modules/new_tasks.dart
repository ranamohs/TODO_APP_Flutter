import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/logic/todo_cubit.dart';
import 'package:todo_app/shared/widgets/build_task_item.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({super.key});



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var tasks = AppCubit.get(context).tasks;

        return ListView.separated(
            itemBuilder: (context, index) =>
                BuildTaskItem(model: tasks[index],context:context,),
            separatorBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
            itemCount: tasks.length);
      },
    );
  }
}