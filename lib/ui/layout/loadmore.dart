import 'package:flutter/material.dart';

class MyLoadMoreWidget extends StatefulWidget {
  @override
  _MyLoadMoreWidgetState createState() => _MyLoadMoreWidgetState();
}

class _MyLoadMoreWidgetState extends State<MyLoadMoreWidget> {
  List<String> items = []; // List to hold your data
  bool isLoading = false; // Flag to track loading state
  int page = 1; // Initial page number

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the method to fetch initial data
  }

  // Method to fetch data
  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading flag to true
    });

    // Simulate an API call or any asynchronous operation to fetch data
    await Future.delayed(Duration(seconds: 2));

    // Add fetched data to the list
    for (int i = 0; i < 10; i++) {
      items.add('Item ${items.length + 1}');
    }

    setState(() {
      isLoading = false; // Set loading flag to false
      page++; // Increment the page number
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Load More Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                } else {
                  // Show loading indicator when reaching the end of the list
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
