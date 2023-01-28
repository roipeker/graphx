import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class PadSettings extends StatelessWidget {
  const PadSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(color: Colors.white12, width: 0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      width: double.infinity,
      child: Row(
        children: [
          TextButton(
            // color: Colors.black54,
            onPressed: () {
              mps.emit('clear');
            },
            child: const Text('CLEAR'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: const [
                    Text(
                      'pick a color',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(width: 24),
                    Text(
                      'MOUSE WHEEL TO CHANGE MAX SIZE (SHIFT FOR THE MIN SIZE)',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white54,
                        fontWeight: FontWeight.normal,
                        letterSpacing: -0.2,
                      ),
                    ),
                    // MPSBuilder<double>(
                    //   mps: mps,
                    //   topics: ['alpha'],
                    //   builder: (_, data, __) => SizedBox(
                    //     height: 18,
                    //     width: 150,
                    //     child: Slider(
                    //         value: data?.data ?? 1.0,
                    //         min: 0.01,
                    //         max: 1.00,
                    //         onChanged: (val) {
                    //           mps.emit1('alpha', val);
                    //         }),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (_, idx) {
                        final color = Colors.primaries[idx];
                        return GestureDetector(
                          onPanDown: (e) {
                            mps.emit1('color', color);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 1),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white70,
                                width: 3,
                              ),
                              color: color,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, idx) => const SizedBox(width: 1),
                      itemCount: Colors.primaries.length),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
