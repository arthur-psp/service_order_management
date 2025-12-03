import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:service_order_management/module/image_picker/data/service/image_picker_service.dart';
import 'package:service_order_management/core/injectable.dart';
import 'package:service_order_management/module/service_order/infra/local_db.dart';
import 'package:service_order_management/module/service_order/view/perform_service_order_View.dart';
import 'package:service_order_management/module/service_order/view/service_order_view.dart';
import 'package:service_order_management/core/injectable.dart';

final GetIt getIt = GetIt.instance;

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
   print('🔧 MAIN: Iniciando registro de dependências...');

  getIt.registerSingleton<Localdb>(Localdb());
   print('✅ Localdb registrado');
    getIt.registerSingleton<ImagePickerServiceImpl>(ImagePickerServiceImpl());
     print('✅ ImagePickerServiceImpl registrado');

  try {
    final testService = getIt<ImagePickerServiceImpl>();
    print('🎉 ImagePickerServiceImpl obtido com sucesso!');
  } catch (e) {
    print('❌ ERRO ao obter ImagePickerServiceImpl: $e');
  }
  

  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(185, 192, 191, 191)),
      ),
      home: const MyHomePage(title: 'Gerenciador de ordens de serviço'),
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

  void _serviceOrderPage() async {
    final String = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServiceOrderView())
    );
  }

  void _performServiceOrderPage() async {
    await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) => PerformServiceOrderView() 
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _performServiceOrderPage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.all(12),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                
                child: const Icon(Icons.assignment_add, size: 40,),
              ),
            ),

            InkWell(
              onTap: _serviceOrderPage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.all(12),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.build_rounded, size: 40,),
              ),
            )
          ],
        )
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _serviceOrderPage,
      //   tooltip: 'Increment',
      //   backgroundColor: const Color(0xFF1E88E5),
      //   hoverColor: const Color.fromARGB(255, 21, 139, 241),
      //   child: const Icon(Icons.add, color: Colors.white),
        
      // ),
    );
  }
}
