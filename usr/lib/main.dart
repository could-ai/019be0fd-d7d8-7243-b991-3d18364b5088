import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Values Input',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ValuesInputScreen(),
      },
    );
  }
}

class ValuesInputScreen extends StatefulWidget {
  const ValuesInputScreen({super.key});

  @override
  State<ValuesInputScreen> createState() => _ValuesInputScreenState();
}

class _ValuesInputScreenState extends State<ValuesInputScreen> {
  // Controllers for C values (c1 to c6)
  final List<TextEditingController> _cControllers = List.generate(6, (index) => TextEditingController());
  
  // Controllers for D values (D1 to D6)
  final List<TextEditingController> _dControllers = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    for (var controller in _cControllers) {
      controller.dispose();
    }
    for (var controller in _dControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _getValues() {
    // Collect values into a map for processing or display
    Map<String, String> values = {};
    
    // Get c1-c6
    for (int i = 0; i < 6; i++) {
      values['c${i + 1}'] = _cControllers[i].text;
    }
    
    // Get D1-D6
    for (int i = 0; i < 6; i++) {
      values['D${i + 1}'] = _dControllers[i].text;
    }

    // Display the retrieved values in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Captured Values'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Here are the values you entered:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...values.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text('${e.key}: ${e.value.isEmpty ? "(empty)" : e.value}'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Parameters'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter C Values (c1-c6)', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            _buildInputGrid(_cControllers, 'c'),
            
            const SizedBox(height: 24),
            
            const Text(
              'Enter D Values (D1-D6)', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            _buildInputGrid(_dControllers, 'D'),
            
            const SizedBox(height: 32),
            
            FilledButton.icon(
              onPressed: _getValues,
              icon: const Icon(Icons.check),
              label: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Get Values', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputGrid(List<TextEditingController> controllers, String prefix) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        childAspectRatio: 1.8, // Width to height ratio
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return TextField(
          controller: controllers[index],
          decoration: InputDecoration(
            labelText: '$prefix${index + 1}',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          keyboardType: TextInputType.number, // Assumes numeric input
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
