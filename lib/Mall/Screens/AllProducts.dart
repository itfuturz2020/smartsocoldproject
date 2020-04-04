import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Mall/Components/ProductComponent.dart';
import 'package:smart_society_new/common/constant.dart' as cnst;

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabList = List();
  int selectedTab = 0;

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      tabList.add(Tab(text: 'Tab ${i + 1}'));
    }
    _tabController = new TabController(vsync: this, length: tabList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.grey[700],
            unselectedLabelStyle:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            labelColor: cnst.appPrimaryMaterialColor,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            onTap: (index) {
              setState(() {
                selectedTab = index;
              });
            },
            tabs: tabList,
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: <Widget>[
            for (int i = 0; i < 10; i++) ...[
              Container(
                color: Colors.grey[200],
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductComponent();
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                ),
              )
            ]
          ]),
        ),
      ],
    );
  }
}
