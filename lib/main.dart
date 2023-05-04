import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ChatGPT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  String _text = "";
  String _msg = "";
  bool _isLoading = false;

  @override
  void initState() {
    _textEditingController.addListener(() {
      setState(() {
        _text = _textEditingController.text;
      });
    });

    super.initState();
  }

  Future<void> _openAi(String text) async {
    setState(() {
      _isLoading = true;
    });
    // Create the configuration
    const conf = OpenAIConfiguration(
      apiKey: '#OpenAI API key', // OpenAI API key
    );

    // Create a new client
    final client = OpenAIClient(configuration: conf);

    var result = await client.completions
        .create(
            model: 'text-davinci-003',
            prompt: text,
            temperature: 0,
            maxTokens: 100,
            topP: 1,
            frequencyPenalty: 0.0,
            presencePenalty: 0.0)
        .data;

    setState(() {
      _isLoading = false;
      _msg = result.choices[0].text;
      _textEditingController.clear();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CupertinoTextField(
              controller: _textEditingController,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _isLoading ? const CircularProgressIndicator() : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_msg),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _isLoading ? null : _openAi(_text),
        tooltip: 'Search',
        child: const Icon(Icons.send),
      ),
    );
  }
}
