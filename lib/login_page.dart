import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedGender;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // بدء الأنيميشن بعد تأخير بسيط
    Future.delayed(Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // زر العودة
                  _buildBackButton(),
                  SizedBox(height: 20),

                  // الصورة والشعار
                  _buildHeader(),
                  SizedBox(height: 10),

                  // البطاقة الرئيسية
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildLoginCard(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.person_add_alt_1, size: 40, color: Colors.white),
        ),
        SizedBox(height: 20),
        Text(
          'إنشاء حساب جديد',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'انضم إلينا وابدأ رحلتك',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.blue.withOpacity(0.2),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[50]!],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // اسم المستخدم
            _buildTextField(
              controller: _usernameController,
              label: 'اسم المستخدم',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم المستخدم';
                }
                if (value.length < 3) {
                  return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // البريد الإلكتروني
            _buildTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال البريد الإلكتروني';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'يرجى إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // كلمة المرور
            _buildPasswordField(),
            SizedBox(height: 16),

            // العمر
            _buildTextField(
              controller: _ageController,
              label: 'العمر',
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال العمر';
                }
                int? age = int.tryParse(value);
                if (age == null || age < 1 || age > 120) {
                  return 'يرجى إدخال عمر صحيح (1-120)';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // رقم الهاتف
            _buildTextField(
              controller: _phoneController,
              label: 'رقم الهاتف',
              icon: Icons.phone_iphone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال رقم الهاتف';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'يرجى إدخال رقم هاتف صحيح';
                }
                if (value.length < 8) {
                  return 'رقم الهاتف يجب أن يكون 8 أرقام على الأقل';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // نوع الجنس
            _buildGenderField(),
            SizedBox(height: 24),

            // زر التسجيل
            _buildRegisterButton(),
            SizedBox(height: 20),

            // رابط تسجيل الدخول
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, top: 4),
            child: Text(
              'نوع الجنس',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Row(
            children: [
              Expanded(child: _buildGenderOption('ذكر', Icons.male, 'male')),
              Expanded(
                child: _buildGenderOption('أنثى', Icons.female, 'female'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String text, IconData icon, String value) {
    bool isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: _isLoading
              ? null
              : LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'إنشاء الحساب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('لديك حساب بالفعل؟', style: TextStyle(color: Colors.grey[600])),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            // الانتقال لصفحة تسجيل الدخول
          },
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى اختيار نوع الجنس'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // محاكاة عملية التسجيل
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('تم إنشاء الحساب بنجاح!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // طباعة البيانات (يمكن استبدالها بالمنطق الفعلي)
      print('=== بيانات التسجيل ===');
      print('اسم المستخدم: ${_usernameController.text}');
      print('البريد الإلكتروني: ${_emailController.text}');
      print('العمر: ${_ageController.text}');
      print('رقم الهاتف: ${_phoneController.text}');
      print('نوع الجنس: $_selectedGender');
    }
  }
}
