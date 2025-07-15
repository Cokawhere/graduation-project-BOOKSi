import 'package:booksi/common/styles/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/widgets/custom-book-cart.dart';
import '../../cart/views/cartview.dart';

class ShopController extends GetxController {
  var selectedIndex = 0.obs;
  void changeTab(int index) => selectedIndex.value = index;
}

class ShopView extends StatelessWidget {
  final ShopController controller = Get.put(ShopController());

  final List<Widget> pages = [
    ShopContent(),
    Cartview(),
    PlaceholderWidget("Notifications"),
    PlaceholderWidget("Blog"),
  ];

  ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: false,
        drawer: _buildDrawer(context),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                iconTheme: const IconThemeData(
                  size: 30,
                  color: AppColors.brown,
                ),
                titleSpacing: 0,
                title: const Text(
                  "BOOKSi°",
                  style: TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: AppColors.brown,
          unselectedItemColor: AppColors.teaMilk,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: "",
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.teaMilk),
            accountName: Text("Mohamed Ahmed"),
            accountEmail: Text("example@email.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.teaMilk),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.translate),
            title: Text('Change Language'),
            onTap: () {},
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Book Categories",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Novels'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.self_improvement),
            title: Text('Self Development'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.nights_stay),
            title: Text('Literature'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.science),
            title: Text('Science'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.auto_stories),
            title: Text('Religion'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text('Business'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.orange),
            title: Text('Log Out', style: TextStyle(color: AppColors.orange)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ShopContent extends StatelessWidget {
  const ShopContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 24),
        _buildSection("Best Selling"),
        const SizedBox(height: 24),
        _buildSection("Trending in Books"),
        const SizedBox(height: 24),
        _buildSection("New Arrivals"),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search books...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(icon: Icon(Icons.tune), onPressed: () {}),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: Text("See All")),
          ],
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => BookCard(
              index: index,
              imageBase64: 'assets/images/MorganHousel.png',
              title: 'The Psychology of Money',
              author: 'Morgan Housel',
              price: '19.99',
              onAdd: () {
                print("Add to cart");
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label, style: TextStyle(fontSize: 22)));
  }
}
