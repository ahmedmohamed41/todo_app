import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/counter/cubit/cubit_task.dart';
import 'package:todo_app/modules/counter/cubit/states_task.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (context, state) {
          if (state is CounterMinusState) {
          //  print('Minus state:${state.counter}');
          }

          if (state is CounterPlusState) {
          //  print('Plus state:${state.counter}');
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('counter'),
              ),
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          CounterCubit.get(context).minus();
                        },
                        child: const Text(
                          'MINUS',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        '${CounterCubit.get(context).counter}',
                        style: const TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          CounterCubit.get(context).plus();
                        },
                        child: const Text(
                          'PLUS',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
