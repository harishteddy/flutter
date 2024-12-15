import 'package:flutter/material.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';
import 'package:smartech_appinbox/smartech_appinbox.dart';


class AppInboxScreen extends StatefulWidget {
  const AppInboxScreen({Key? key}) : super(key: key);

  @override
  _AppInboxScreenState createState() => _AppInboxScreenState();
}

class _AppInboxScreenState extends State<AppInboxScreen> {
  List<MessageCategory> categoryList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndMessages();
  }

  void fetchCategoriesAndMessages() async {
    try {
      // Fetching categories
      List<MessageCategory>? fetchedCategories =
      await SmartechAppinbox().getAppInboxCategoryList();
      setState(() {
        categoryList = fetchedCategories!;
      });

      // Fetching messages by selected categories
      List<SMTAppInboxMessages>? fetchedMessages =
      await SmartechAppinbox().getAppInboxMessagesByApiCall(
        messageLimit: 10,
        smtInboxDataType: "all",
        categoryList: categoryList
            .where((category) => category.selected)
            .map((e) => e.name)
            .toList(),
      );
      setState(() {
        var messageList = fetchedMessages;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching App Inbox data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Inbox"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Categories Section
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final category = categoryList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      category.selected = !category.selected;
                    });
                    fetchCategoriesAndMessages();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: category.selected
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: category.selected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),


        ],
      ),
    );
  }
}

