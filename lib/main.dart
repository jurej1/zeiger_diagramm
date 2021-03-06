import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeiger_diagramm/models/complex.dart';
import 'package:zeiger_diagramm/models/models.dart';
import 'package:zeiger_diagramm/widgets/pointer_painter.dart';

import 'blocs/cubit/playing_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PlayingCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      duration: const Duration(seconds: 8),
      upperBound: pi * 2,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Size constraints = Size(
      min(size.width, size.height),
      min(size.width, size.height),
    );

    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      endDrawer: const Drawer(),
      body: FittedBox(
        child: Column(
          children: [
            SizedBox(
              height: min(size.width, size.height),
              width: min(size.width, size.height),
              child: BlocListener<PlayingCubit, PlayingState>(
                listener: (context, state) {
                  if (state == PlayingState.playing) {
                    _animationController.repeat();
                  } else if (state == PlayingState.stop) {
                    _animationController.stop();
                  }
                },
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: constraints,
                        painter: PointerPainter(
                          animationValue: _animationController.value,
                          spannungen: [
                            ComplexPaintingObject(
                              Complex.valueAngleDegree(188.275, 75.872),
                              lineColor: Colors.blue.shade400,
                              name: 'U1',
                            ),
                            ComplexPaintingObject(
                              Complex.valueAngleDegree(294.066, -33.527),
                              lineColor: Colors.blue.shade500,
                              name: 'U2',
                            ),
                            ComplexPaintingObject(
                              Complex.valueAngleDegree(223.293, -133.527),
                              lineColor: Colors.blue.shade600,
                              name: 'U3',
                            ),
                            ComplexPaintingObject(
                              Complex.valueAngleDegree(66.0357, -45.898),
                              lineColor: Colors.orange,
                              name: 'U0',
                            ),
                            ComplexPaintingObject(
                              Complex.valueAngleDegree(66.0357, -45.898 + 180),
                              lineColor: Colors.orange,
                              name: '-U0',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              children: [
                BlocBuilder<PlayingCubit, PlayingState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      child: Text(state == PlayingState.playing ? 'Stop' : 'Play'),
                      onPressed: () {
                        BlocProvider.of<PlayingCubit>(context).buttonPressed();
                      },
                    );
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _animationController.reset();
                    BlocProvider.of<PlayingCubit>(context).reset();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
