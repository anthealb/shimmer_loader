import 'package:flutter/material.dart';
import 'package:shimmer_loader/shimmer_loader.dart';

import 'joke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shimmer Loader Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future joke = Jokes.loadJoke();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shimmer Loader')),
      body: FutureBuilder(
        future: joke,
        builder: (context, snapshot) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('A joke for you', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                if (!snapshot.hasError)
                  ShimmerLoader(
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                    // In this case, I'm creating my own placeholder, by drawing a "template" of the content
                    // that the user is most likely to see. Of course, this is ideal for content that has a
                    // fixed, pre-defined shape.
                    placeholder: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (snapshot.data != null)
                          ? [
                              Container(
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                height: 20,
                                width: MediaQuery.of(context).size.width - 32,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                height: 20,
                                width: MediaQuery.of(context).size.width - 32,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                height: 20,
                                width: MediaQuery.of(context).size.width - 32,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                                height: 20,
                                width: MediaQuery.of(context).size.width - 32,
                              ),
                            ]
                          : [],
                    ),
                    // The child is the actual content, and in this case I put it in a SizedBox to make sure it has
                    // the same size as the placeholder
                    child: SizedBox(
                      height: 124,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: (snapshot.data != null)
                            ? [
                                Text(snapshot.data!.setup, textAlign: TextAlign.center),
                                Text(snapshot.data!.punchline, textAlign: TextAlign.center),
                              ]
                            : [],
                      ),
                    ),
                  ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          joke = Jokes.loadJoke();
          setState(() {});
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
