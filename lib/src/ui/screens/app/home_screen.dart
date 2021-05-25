import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  static final String id = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(
          Get.width / 30,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 40,
              backgroundColor: Colors.white,
              title: Text(
                "Name",
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
              centerTitle: true,
              actions: [
                CircleAvatar(
                  radius: 20,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 80),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "10 Notes",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 500,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 500,
                    color: Colors.red,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
