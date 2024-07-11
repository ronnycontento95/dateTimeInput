import 'package:date_format_app/format_date.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Format Field',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Formater field'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateFormatField(
                addCalendar: false,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  // border: InputBorder.none,
                  // label: Text("Date"),
                ),
                onComplete: (date) {
                  print('prueba >>> ingreso ${date}');
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}


class DateFormatField extends StatefulWidget {
  const DateFormatField({
    super.key,
    required this.onComplete,
    this.addCalendar = true,
    this.decoration,
    this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.focusNode,
  });
  final InputDecoration? decoration;
  final Function(DateTime?) onComplete;
  final bool addCalendar;
  final DateTime? initialDate;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<DateFormatField> createState() => _DateFormatFieldState();
}

class _DateFormatFieldState extends State<DateFormatField> {
  late final TextEditingController _dobFormater;

  @override
  void initState() {
    _dobFormater = widget.controller ?? TextEditingController();
    super.initState();
  }

  InputDecoration? decoration() {
    if (!widget.addCalendar) return widget.decoration;

    if (widget.decoration == null) {
      return InputDecoration(
        suffixIcon: IconButton(
          onPressed: pickDate,
          icon: const Icon(Icons.calendar_month),
        ),
      );
    }

    return widget.decoration!.copyWith(
      suffixIcon: IconButton(
        onPressed: pickDate,
        icon: const Icon(Icons.calendar_month),
      ),
    );
  }

  void formatInput(String value) {
    /// formater for the text input field
    DateTime? completeDate;
    completeDate = Formater.type4(value, _dobFormater);
    setState(() {
      widget.onComplete(completeDate);
    });
  }

  Future<void> pickDate() async {
    /// pick the date directly from the screen
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate ?? DateTime(1000),
      lastDate: widget.lastDate ?? DateTime(3000),
    );
    if (picked != null) {
      String inputText;
      inputText =
          '${picked.year}-${padDayMonth(picked.month)}-${padDayMonth(picked.day)}';
      setState(() {
        _dobFormater.text = inputText;
      });
      widget.onComplete(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dobFormater,
      onTap: () {
        _dobFormater.selection = TextSelection.fromPosition(
          TextPosition(offset: _dobFormater.text.length),
        );
      },
      focusNode: widget.focusNode,
      decoration: decoration(),
      keyboardType: TextInputType.datetime,
      onChanged: formatInput,
    );
  }

  String padDayMonth(int value) => value.toString().padLeft(2, '0');
}
