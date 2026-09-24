import 'package:flutter/material.dart';

import 'app.dart';
import 'data/local_spending_data.dart';

export 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadDefaultSpendingData();
  runApp(const MyApp());
}
