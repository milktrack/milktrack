import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  // Global customer list
  final List<Map<String, String>> _customerList = [];

  void _addCustomer(Map<String, String> customer) {
    setState(() {
      _customerList.add(customer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeScreen(),
      const ReportScreen(),
      CustomerScreen(customerList: _customerList, onAddCustomer: _addCustomer),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer App"),
        backgroundColor: const Color(0xFF1F41BB),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1F41BB),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Customer"),
        ],
      ),
    );
  }
}

/// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "🏠 Home Screen",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Report Screen
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "📊 Report Screen",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Customer Screen
class CustomerScreen extends StatelessWidget {
  final List<Map<String, String>> customerList;
  final Function(Map<String, String>) onAddCustomer;

  const CustomerScreen({
    required this.customerList,
    required this.onAddCustomer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customerList.isEmpty
          ? const Center(
        child: Text(
          "👤 No Customers Added",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: customerList.length,
        itemBuilder: (context, index) {
          final customer = customerList[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer['name'] ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Mobile: ${customer['mobile']}"),
                  Text("Rate: ${customer['rate']}"),
                  Text("Address: ${customer['address']}"),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
          );
          if (result != null) {
            onAddCustomer(result);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF1F41BB),
      ),
    );
  }
}

/// Add Customer Form (No icons, white text on blue button)
class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF1F4FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1F41BB)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Customer"),
        backgroundColor: const Color(0xFF1F41BB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mobileController,
                decoration: _inputDecoration("Mobile No"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? "Please enter mobile no" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rateController,
                decoration: _inputDecoration("Rate"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Please enter rate" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration("Address"),
                validator: (value) =>
                value!.isEmpty ? "Please enter address" : null,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'name': _nameController.text,
                      'mobile': _mobileController.text,
                      'rate': _rateController.text,
                      'address': _addressController.text,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F41BB), // Blue
                  foregroundColor: Colors.white, // White text
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
