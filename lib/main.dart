import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const JumhouriaApp());
}

class AppState {
  static double balance = 1500.0;
  static String userName = "أحمد محمد المهدي";
  static String accountNumber = "010023456789";
  static String iban = "LY8801000000010023456789";
  static String phone = "0912345678";
  static String email = "ahmed.ly@example.com";
  static String passport = "P0198425";

  static List<Map<String, String>> beneficiaries = [
    {"name": "محمود علي", "account": "010099887766", "bank": "مصرف الجمهورية"},
    {"name": "فاطمة إبراهيم", "account": "020044556677", "bank": "مصرف التجاري الوطني"},
  ];

  static List<Map<String, dynamic>> transactions = [
    {"date": "01 أكتوبر", "title": "مشتريات - سوبرماركت الفصول", "amount": -50.0},
    {"date": "30 سبتمبر", "title": "إيداع راتب شهري", "amount": 1200.0},
    {"date": "28 سبتمبر", "title": "شحن كرت ليبيانا", "amount": -10.0},
  ];
}

void speak(BuildContext context, String text, {bool isAlert = false}) {
  SemanticsService.announce(text, TextDirection.rtl);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isAlert ? Colors.red[800] : const Color(0xFF0055A5),
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          Icon(isAlert ? Icons.warning_amber_rounded : Icons.volume_up, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ],
      ),
    ),
  );
}

class JumhouriaApp extends StatelessWidget {
  const JumhouriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مصرف الجمهورية بلس للمكفوفين',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'LY'),
      theme: ThemeData(
        primaryColor: const Color(0xFF0055A5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0055A5)),
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cards': (context) => const CardsScreen(),
        '/transfer': (context) => const TransferScreen(),
        '/history': (context) => const HistoryScreen(),
        '/beneficiaries': (context) => const BeneficiariesScreen(),
        '/merchant-pay': (context) => const MerchantPayScreen(),
        '/recharge': (context) => const RechargeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/tutorial': (context) => const InteractiveTutorialScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pin = "";

  void _onKeyTap(String key) {
    if (pin.length < 4) {
      setState(() => pin += key);
      speak(context, "تم إدخال الرقم $key");
    }
  }

  void _deleteKey() {
    if (pin.isNotEmpty) {
      setState(() => pin = pin.substring(0, pin.length - 1));
      speak(context, "تم مسح آخر رقم");
    }
  }

  void _submitLogin() {
    if (pin.length == 4) {
      speak(context, "مرحباً بك مجدداً يا ${AppState.userName}، جاري نقلك للرئيسية");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      speak(context, "الرجاء إدخال رقم سري مكوّن من 4 خانات", isAlert: true);
    }
  }

  void _loginWithBiometric() {
    speak(context, "تم التعرف على البصمة الحيوية بنجاح. أهلاً بك يا ${AppState.userName}");
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مصرف الجمهورية - تسجيل الدخول"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text("أهلاً بك، أدخل رقمك السري للمتابعة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < pin.length ? const Color(0xFF0055A5) : Colors.grey[300],
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map(
                      (n) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _onKeyTap(n),
                        child: Text(n, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[50]),
                      onPressed: _deleteKey,
                      child: const Icon(Icons.backspace, color: Colors.red, size: 28),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _onKeyTap('0'),
                      child: const Text('0', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                      onPressed: _submitLogin,
                      child: const Icon(Icons.check, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055A5),
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.fingerprint, color: Colors.white, size: 30),
                label: const Text("الدخول بالبصمة / Face ID", style: TextStyle(color: Colors.white, fontSize: 17)),
                onPressed: _loginWithBiometric,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < -300) {
          speak(context, "الرصيد المتاح حالياً بحسابك هو ${AppState.balance.toStringAsFixed(2)} دينار ليبي");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("أهلاً ${AppState.userName.split(' ')[0]}"),
          backgroundColor: const Color(0xFF0055A5),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.school, size: 28),
              tooltip: "وضع التدريب الصوتي",
              onPressed: () => Navigator.pushNamed(context, '/tutorial'),
            ),
            IconButton(
              icon: const Icon(Icons.settings, size: 28),
              tooltip: "الإعدادات",
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  speak(context, "رصيد حسابك المتاح هو ${AppState.balance.toStringAsFixed(2)} دينار ليبي");
                },
                child: Card(
                  color: const Color(0xFFE8F0FE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("الرصيد المتاح (اسحب لأعلى لسماعه)", style: TextStyle(fontSize: 14, color: Colors.black54)),
                            Text("حساب جاري رئيسي", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(
                          "${AppState.balance.toStringAsFixed(2)} د.ل",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0055A5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.25,
                  children: [
                    _tile(context, "البيانات الشخصية", Icons.person_pin, () => Navigator.pushNamed(context, '/profile')),
                    _tile(context, "كروت الدفع وعروضها", Icons.credit_card, () => Navigator.pushNamed(context, '/cards')),
                    _tile(context, "تحويل أموال", Icons.send_rounded, () async {
                      await Navigator.pushNamed(context, '/transfer');
                      setState(() {});
                    }),
                    _tile(context, "دفع بالمتاجر (QR)", Icons.qr_code_scanner, () async {
                      await Navigator.pushNamed(context, '/merchant-pay');
                      setState(() {});
                    }),
                    _tile(context, "إضافة مستفيد جديد", Icons.person_add_alt_1, () => Navigator.pushNamed(context, '/beneficiaries')),
                    _tile(context, "شحن كروت الدفع", Icons.phone_android, () async {
                      await Navigator.pushNamed(context, '/recharge');
                      setState(() {});
                    }),
                    _tile(context, "سجل الحساب وكشفه", Icons.receipt_long, () => Navigator.pushNamed(context, '/history')),
                    _tile(context, "خدمة العملاء والدعم", Icons.support_agent, () {
                      speak(context, "جاري الاتصال بمركز خدمة زبائن مصرف الجمهورية: 1540");
                    }),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.headset_mic, color: Colors.white),
                label: const Text("🆘 طلب مساعدة فورية من موظف البنك", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                onPressed: () {
                  speak(context, "تم إرسال نداء فوري لموظف خدمة المكفوفين، سيتصل بك خلال دقائق");
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          speak(context, "فتح $title");
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF0055A5)),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = [
      {"label": "الاسم الكامل", "val": AppState.userName, "icon": Icons.person},
      {"label": "رقم الحساب المصرفي", "val": AppState.accountNumber, "icon": Icons.account_balance},
      {"label": "رقم الآيبان (IBAN)", "val": AppState.iban, "icon": Icons.pin},
      {"label": "رقم الهاتف المحمول", "val": AppState.phone, "icon": Icons.phone},
      {"label": "البريد الإلكتروني", "val": AppState.email, "icon": Icons.email},
      {"label": "رقم جواز السفر", "val": AppState.passport, "icon": Icons.badge},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("البيانات الشخصية"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fields.length,
        itemBuilder: (context, i) {
          final f = fields[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(f['icon'] as IconData, color: const Color(0xFF0055A5)),
              title: Text(f['label'] as String, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              subtitle: Text(f['val'] as String, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
              onTap: () {
                speak(context, "${f['label']}: ${f['val']}");
              },
            ),
          );
        },
      ),
    );
  }
}

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("كروت الدفع والعروض"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF0D47A1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("بطاقة تداول / فيزا المحلية", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Text("**** **** **** 8821", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("صالحة حتى: 12/28", style: TextStyle(color: Colors.white70)),
                      Text("الرصيد: ${AppState.balance.toStringAsFixed(2)} د.ل", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055A5)),
            icon: const Icon(Icons.download, color: Colors.white),
            label: const Text("طلب كشف حساب البطاقة الميسر صوتياً", style: TextStyle(color: Colors.white)),
            onPressed: () {
              speak(context, "تم تجهيز كشف الحساب الصوتي لشهر سبتمبر. إجمالي المصروفات 180 دينار");
            },
          ),
        ],
      ),
    );
  }
}

class MerchantPayScreen extends StatefulWidget {
  const MerchantPayScreen({super.key});

  @override
  State<MerchantPayScreen> createState() => _MerchantPayScreenState();
}

class _MerchantPayScreenState extends State<MerchantPayScreen> {
  final _merchantCode = TextEditingController();
  final _amount = TextEditingController();

  void _pay() {
    final amt = double.tryParse(_amount.text.trim()) ?? 0.0;
    if (_merchantCode.text.isEmpty || amt <= 0) {
      speak(context, "خطأ: أدخل رمز التاجر والمبلغ بشكل صحيح", isAlert: true);
      return;
    }
    if (amt > AppState.balance) {
      speak(context, "عفواً، الرصيد غير كافٍ للدفع", isAlert: true);
      return;
    }

    AppState.balance -= amt;
    AppState.transactions.insert(0, {
      "date": "اليوم",
      "title": "دفع لمتجر (${_merchantCode.text})",
      "amount": -amt,
    });

    speak(context, "تم دفع مبلغ $amt دينار للمتجر بنجاح. المتبقي: ${AppState.balance.toStringAsFixed(2)} دينار");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الدفع في المتاجر والأسواق"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text("مسح كود المتجر تلقائياً (صوتي)", style: TextStyle(color: Colors.white)),
              onPressed: () {
                _merchantCode.text = "10984";
                speak(context, "تم التعرف على متجر المدينة للمواد الغذائية رمز 10984");
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _merchantCode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "رمز التاجر / المتجر", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "قيمة الفاتورة بالدينار", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 52),
              ),
              onPressed: _pay,
              child: const Text("✅ تأكيد الشراء ودفع المبلغ", style: TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

class RechargeScreen extends StatelessWidget {
  const RechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final telecom = [
      {"name": "شركة ليبيانا للهاتف المحمول", "prices": [5, 10, 20, 50]},
      {"name": "شركة المدار الجديد", "prices": [5, 10, 20, 50]},
      {"name": "ليبيا للاتصالات والتقنية (فورنت / DSL)", "prices": [20, 40, 100]},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("شحن الرصيد والإنترنت"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: telecom.length,
        itemBuilder: (context, i) {
          final t = telecom[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: (t['prices'] as List<int>).map((price) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055A5)),
                        onPressed: () {
                          if (AppState.balance >= price) {
                            AppState.balance -= price;
                            AppState.transactions.insert(0, {
                              "date": "اليوم",
                              "title": "شحن ${t['name']} بقيمة $price د.ل",
                              "amount": -price.toDouble(),
                            });
                            speak(context, "تم شراء كرت شحن ${t['name']} بقيمة $price دينار بنجاح");
                            Navigator.pop(context);
                          } else {
                            speak(context, "الرصيد غير كافٍ لشراء هذا الكرت", isAlert: true);
                          }
                        },
                        child: Text("$price د.ل", style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BeneficiariesScreen extends StatefulWidget {
  const BeneficiariesScreen({super.key});

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
  final _nameController = TextEditingController();
  final _accountController = TextEditingController();
  String _bank = "مصرف الجمهورية";

  void _add() {
    if (_nameController.text.isNotEmpty && _accountController.text.isNotEmpty) {
      setState(() {
        AppState.beneficiaries.add({
          "name": _nameController.text,
          "account": _accountController.text,
          "bank": _bank,
        });
      });
      speak(context, "تم حفظ المستفيد ${_nameController.text} بنجاح");
      _nameController.clear();
      _accountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المستفيدون والعمليات"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("إضافة حساب مصرفي لعميل جديد:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "اسم المستفيد", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _accountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "رقم الحساب", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _bank,
              decoration: const InputDecoration(labelText: "المصرف", border: OutlineInputBorder()),
              items: ["مصرف الجمهورية", "مصرف التجاري الوطني", "مصرف الصحارى", "مصرف الوحدة"]
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _bank = v!),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055A5)),
              onPressed: _add,
              child: const Text("حفظ المستفيد في القائمة", style: TextStyle(color: Colors.white)),
            ),
            const Divider(height: 35),
            const Text("المستفيدون المحفوظون:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...AppState.beneficiaries.map((b) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFF0055A5)),
                    title: Text(b['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${b['bank']} - ${b['account']}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => speak(context, "مستفيد: ${b['name']}، حسابه: ${b['account']}"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class InteractiveTutorialScreen extends StatefulWidget {
  const InteractiveTutorialScreen({super.key});

  @override
  State<InteractiveTutorialScreen> createState() => _InteractiveTutorialScreenState();
}

class _InteractiveTutorialScreenState extends State<InteractiveTutorialScreen> {
  int step = 0;
  final List<String> steps = [
    "مرحباً بك في وضع التدريب الصوتي التفاعلي لمصرفي بلس. اضغط على زر التالي للمتابعة.",
    "الخطوة الأولى: لسماع رصيدك الحالي في أي وقت ومن أي شاشة، اسحب بإصبعين نحو الأعلى.",
    "الخطوة الثانية: كل زر أو حقل نصي في التطبيق له وصف صوتي تلقائي دون الحاجة لرؤية الألوان أو الأشكال.",
    "الخطوة الثالثة: عند إدخال الرقم السري، ستنطق اللوحة الرقم الملموس فوراً لتأكيد الدقة.",
    "تهانينا! أنت الآن مستعد لاستخدام كافة ميزات التطبيق بكل استقلالية.",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      speak(context, steps[0]);
    });
  }

  void _next() {
    if (step < steps.length - 1) {
      setState(() => step++);
      speak(context, steps[step]);
    } else {
      speak(context, "اكتمل التدريب. تم الرجوع للرئيسية");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("وضع التدريب التفاعلي"),
        backgroundColor: const Color(0xFF0055A5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.record_voice_over, size: 80, color: Color(0xFF0055A5)),
            const SizedBox(height: 25),
            Text(
              "الخطوة ${step + 1} من ${steps.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 15),
            Text(
              steps[step],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0055A5),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _next,
              child: Text(step == steps.length - 1 ? "إنهاء التدريب" : "الخطوة التالية ⬅️",
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _acc = TextEditingController();
  final _amt = TextEditingController();

  void _transfer() {
    final v = double.tryParse(_amt.text) ?? 0.0;
    if (_acc.text.isNotEmpty && v > 0 && v <= AppState.balance) {
      AppState.balance -= v;
      AppState.transactions.insert(0, {"date": "اليوم", "title": "تحويل إلى (${_acc.text})", "amount": -v});
      speak(context, "تم تحويل $v دينار بنجاح إلى ${_acc.text}");
      Navigator.pop(context);
    } else {
      speak(context, "بيانات غير صحيحة أو رصيد غير كافٍ", isAlert: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحويل الأموال"), backgroundColor: const Color(0xFF0055A5), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _acc, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "رقم حساب المستفيد", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "المبلغ بالدينار", border: OutlineInputBorder())),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], minimumSize: const Size(double.infinity, 50)),
              onPressed: _transfer,
              child: const Text("تأكيد التحويل المالي", style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سجل المعاملات"), backgroundColor: const Color(0xFF0055A5), foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: AppState.transactions.length,
        itemBuilder: (context, i) {
          final t = AppState.transactions[i];
          final double amt = t['amount'];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: ListTile(
              leading: Icon(amt > 0 ? Icons.arrow_downward : Icons.arrow_upward, color: amt > 0 ? Colors.green : Colors.red),
              title: Text(t['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(t['date']),
              trailing: Text("${amt > 0 ? '+' : ''}$amt د.ل", style: TextStyle(fontWeight: FontWeight.bold, color: amt > 0 ? Colors.green : Colors.red)),
              onTap: () => speak(context, "${t['title']} بقيمة $amt دينار"),
            ),
          );
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات العامة والوصول"), backgroundColor: const Color(0xFF0055A5), foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.school, color: Color(0xFF0055A5)),
            title: const Text("إعادة تشغيل وضع التدريب"),
            onTap: () => Navigator.pushNamed(context, '/tutorial'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF0055A5)),
            title: const Text("تغيير رقم هاتف التنبيهات الصوتية"),
            subtitle: Text(AppState.phone),
            onTap: () => speak(context, "رقم الهاتف الحالي هو: ${AppState.phone}"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}
