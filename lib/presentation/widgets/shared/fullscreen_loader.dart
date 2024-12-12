import 'package:flutter/material.dart';

class FullscreenLoader extends StatelessWidget {
  const FullscreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Loading banners...',
      'Caricamento...',
      'Cargamento...',
      'Cargando...',
      'Keep calm and watch movies...',
      'This is taking a long time...'
    ];

    return Stream.periodic(const Duration(milliseconds: 5000), (step) => messages[step]).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(), 
            builder: (context, snapshot) {
              if(!snapshot.hasData) return const Text('Now loading...');

              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}