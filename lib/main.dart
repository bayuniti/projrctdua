import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analog Clock & Warm-up Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Clock'),
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
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
  }

  void _getCurrentTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: AnalogClock(),
          ),
          const SizedBox(height: 20),
          // Teks yang menampilkan waktu saat ini
          Text(
            'Current Time: ${_currentTime.hour}:${_currentTime.minute}:${_currentTime.second}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Tombol Next untuk navigasi ke halaman pemanasan olahraga
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WarmUpPage()),
              );
            },
            child: const Text('Go to'),
          ),
        ],
      ),
    );
  }
}

class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: ClockPainter(_dateTime),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final paintCircle = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Draw the clock background
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    // Draw hour, minute, and second hands
    final paintHourHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final paintMinuteHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final paintSecondHand = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final hourHandLength = radius * 0.5;
    final minuteHandLength = radius * 0.7;
    final secondHandLength = radius * 0.9;

    final hourAngle = (dateTime.hour % 12 + dateTime.minute / 60) * 30 * pi / 180;
    final minuteAngle = (dateTime.minute + dateTime.second / 60) * 6 * pi / 180;
    final secondAngle = dateTime.second * 6 * pi / 180;

    // Draw hour hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourHandLength * cos(hourAngle - pi / 2),
        center.dy + hourHandLength * sin(hourAngle - pi / 2),
      ),
      paintHourHand,
    );

    // Draw minute hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteHandLength * cos(minuteAngle - pi / 2),
        center.dy + minuteHandLength * sin(minuteAngle - pi / 2),
      ),
      paintMinuteHand,
    );

    // Draw second hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + secondHandLength * cos(secondAngle - pi / 2),
        center.dy + secondHandLength * sin(secondAngle - pi / 2),
      ),
      paintSecondHand,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Halaman Pemanasan Sebelum Olahraga
class WarmUpPage extends StatelessWidget {
  final List<Map<String, String>> warmUpExercises = [
    {
      'title': 'Jogging',
      'description': 'Lakukan jogging ringan selama 5-10 menit untuk meningkatkan detak jantung.',
      'image': 'assets/jogging.jpg', // Ganti dengan URL gambar yang benar
    },
    {
      'title': 'Pull Up',
      'description': ' latihan kekuatan fisik untuk meningkatkan ataupun mempertahankan massa otot, terutama otot tubuh bagian atas.',
      'image': 'assets/pengertian-pull-up.jpg', // Ganti dengan URL gambar yang benar
    },
    {
      'title': 'Push Up',
      'description': 'lebih fokus pada otot bagian atas tubuh, seperti trisep, dada, dan bahu.',
      'image': 'assets/push-up.webp', // Ganti dengan URL gambar yang benar
    },
    {
      'title': 'Sit Up',
      'description': 'gerakan olahraga yang fokus pada kekuatan perut dengan cara berbaring telentang lalu mengangkat tubuh bagian atas sambil lutut ditekuk.',
      'image': 'assets/sit-up.jpg', // Ganti dengan URL gambar yang benar
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemanasan Sebelum Olahraga"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: warmUpExercises.length,
              itemBuilder: (context, index) {
                final exercise = warmUpExercises[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      exercise['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(exercise['title']!),
                    subtitle: Text(exercise['description']!),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BenefitsPage()),
              );
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

// Halaman Ketiga (Manfaat Pemanasan)
class BenefitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manfaat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.directions_run),
              title: Text("Meningkatkan Aliran Darah"),
              subtitle: Text(
                  "Pemanasan membantu meningkatkan aliran darah ke otot-otot yang akan digunakan, "
                      "sehingga memperbaiki fleksibilitas dan persiapan untuk olahraga."),
            ),
            ListTile(
              leading: Icon(Icons.accessibility),
              title: Text("Meningkatkan Fleksibilitas"),
              subtitle: Text(
                  "Melakukan peregangan saat pemanasan meningkatkan fleksibilitas tubuh, "
                      "membantu mengurangi risiko cedera."),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Mengurangi Cedera"),
              subtitle: Text(
                  "Pemanasan membantu mempersiapkan tubuh untuk aktivitas fisik yang lebih intens, "
                      "sehingga dapat mengurangi risiko cedera."),
            ),
            ListTile(
              leading: Icon(Icons.self_improvement),
              title: Text("Meningkatkan Performa"),
              subtitle: Text(
                  "Pemanasan membantu tubuh siap untuk olahraga sehingga meningkatkan kemampuan atletik."),
            ),
          ],
        ),
      ),
    );
  }
}
