import 'package:http/http.dart' as http;

Future<List<MenuItem>> fetchMenuItems() async {
  final response = await http.get('http://192.168.1.3/API/file.php');

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => MenuItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load menu items');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems().then((items) {
      setState(() {
        menuItems = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "What would you like to eat?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(menuItems[index].name),
                          Text(menuItems[index].description),
                          Text('\$${menuItems[index].price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
