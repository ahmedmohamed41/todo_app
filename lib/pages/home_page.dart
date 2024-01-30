import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/constaints.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';


class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: kAppbarColor,
              title: Text(
                // listTitle[currentIndex],
                cubit.listTitle[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataLoadingState,
              builder: (context) =>
                  cubit.listScreen[AppCubit.get(context).currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                AppCubit.get(context).getIndex(index);
              },
              items: [
                customBottomNavigationBarItem(icon: Icons.list, label: 'Tasks'),
                customBottomNavigationBarItem(
                    icon: Icons.task_alt_sharp, label: 'Done'),
                customBottomNavigationBarItem(
                    icon: Icons.archive, label: 'Archived'),
                // const BottomNavigationBarItem(
                //   icon: Icon(
                //     Icons.task_alt_sharp,
                //   ),
                //   label: 'Done',
                // ),
                // const BottomNavigationBarItem(
                //   icon: Icon(Icons.archive),
                //   label: 'Archived',
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem customBottomNavigationBarItem(
      {@required IconData? icon, @required String? label}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
      ),
      label: label,
    );
  }
}
