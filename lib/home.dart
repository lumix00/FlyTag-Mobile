import 'package:flutter/material.dart';
import 'dart:convert'; // Para parsear o JSON

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Exemplo de JSON, você pode substituir por uma chamada de rede ou outra fonte
  final String jsonString = '''
  [
    {"baggage": {"code": "A001", "status": "Checked In", "date": "2024-09-01", "location": "New York"}},
    {"baggage": {"code": "A002", "status": "In Transit", "date": "2024-09-02", "location": "Los Angeles"}},
    {"baggage": {"code": "A003", "status": "Delivered", "date": "2024-09-03", "location": "Chicago"}},
    {"baggage": {"code": "A004", "status": "Delayed", "date": "2024-09-04", "location": "Houston"}},
    {"baggage": {"code": "A005", "status": "Checked In", "date": "2024-09-05", "location": "Phoenix"}},
    {"baggage": {"code": "A006", "status": "In Transit", "date": "2024-09-06", "location": "Philadelphia"}},
    {"baggage": {"code": "A007", "status": "Delivered", "date": "2024-09-07", "location": "San Antonio"}},
    {"baggage": {"code": "A008", "status": "Delayed", "date": "2024-09-08", "location": "San Diego"}},
    {"baggage": {"code": "A009", "status": "Checked In", "date": "2024-09-09", "location": "Dallas"}}
  ]
  ''';

  late List<dynamic> jsonData;
  List<dynamic> filteredData = [];
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'Active';

  @override
  void initState() {
    super.initState();
    jsonData = json.decode(jsonString);
    filteredData = jsonData;
    _searchController.addListener(_filterData);
  }

void _filterData() {
  final query = _searchController.text.toLowerCase();
  setState(() {
    filteredData = jsonData.where((item) {
      final baggage = item['baggage'];
      final code = baggage['code'].toLowerCase();
      final status = baggage['status'].toLowerCase();
      final location = baggage['location'].toLowerCase();
      final matchesQuery = code.contains(query) || status.contains(query) || location.contains(query);

      bool matchesStatus;
      if (_searchController.text.isEmpty) {
        // Se não houver texto de pesquisa, aplicar filtro de status
        if (_filterStatus == 'All') {
          matchesStatus = true;
        } else if (_filterStatus == 'Active') {
          matchesStatus = ['in transit', 'delayed', 'checked in'].contains(status);
        } else {
          matchesStatus = status == _filterStatus.toLowerCase();
        }
      } else {
        // Se houver texto de pesquisa, mostrar todas as malas que correspondem à pesquisa
        matchesStatus = true;
      }

      return matchesQuery && matchesStatus;
    }).toList();
  });
}

void _setFilterStatus(String status) {
  setState(() {
    _filterStatus = status;
    // Refiltrar dados após alterar o status
    _filterData();
  });
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                  label: 'Active',
                  isSelected: _filterStatus == 'Active' && _searchController.text.isEmpty,
                  onPressed: () => _setFilterStatus('Active'),
                ),
                FilterButton(
                  label: 'Delivered',
                  isSelected: _filterStatus == 'Delivered' && _searchController.text.isEmpty,
                  onPressed: () => _setFilterStatus('Delivered'),
                ),
                FilterButton(
                  label: 'All',
                  isSelected: _filterStatus == 'All' || _searchController.text.isNotEmpty,
                  onPressed: () => _setFilterStatus('All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredData.isEmpty
                ? Center(child: Text('No items found', style: Theme.of(context).textTheme.titleLarge))
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final baggage = filteredData[index]['baggage'];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(baggage: baggage),
                              ),
                            );
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text('Code: ${baggage['code']}'),
                            subtitle: Text('Status: ${baggage['status']}\nDate: ${baggage['date']}\nLocation: ${baggage['location']}'),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.report_problem),
              onPressed: () {
                // Ação para o botão "Relatar Problemas"
              },
            ),
            const SizedBox(width: 20), // Espaçamento entre os ícones e o FAB
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                // Ação para o botão circular "+"
              },
            ),
            const SizedBox(width: 20), // Espaçamento entre os ícones e o FAB
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Ação para o botão "Configurações"
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        minimumSize: const Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> baggage;

  const DetailsPage({Key? key, required this.baggage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baggage Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${baggage['code']}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Status: ${baggage['status']}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Date: ${baggage['date']}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Location: ${baggage['location']}', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
