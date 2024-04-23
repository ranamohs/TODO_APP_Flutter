
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/shared/logic/todo_cubit.dart';

class BuildTaskItem extends StatelessWidget {


   BuildTaskItem({super.key ,required this.model , this.context});

  Map model;
  var context;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(radius: 50.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('${model?['time']}' , style: TextStyle(fontSize: 19),),
            ),),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model?['title']}'
                  , style:
                TextStyle(
                    fontSize: 22 ,
                    fontWeight: FontWeight.bold),),
                Text(
                  '${model?['date']}'
                  , style:
                TextStyle(
                    color: Colors.grey),)
              ],),
          ),
          SizedBox(width: 20,),
          IconButton(onPressed: (){
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          }, icon: Icon(Icons.check_box, color: Colors.green,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.archive , color: Colors.blue,)),
        ],
      ),
    );
  }
}
