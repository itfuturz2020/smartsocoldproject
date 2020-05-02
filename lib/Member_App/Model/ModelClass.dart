class Menu {
  final String Icon;
  final String IconName;

  Menu({this.Icon, this.IconName});

  static List<Menu> allMenuItems() {
    var listofmenus = new List<Menu>();

    listofmenus.add(new Menu(Icon: "DailyHelp.png", IconName: "DailyHelp"));
    listofmenus.add(new Menu(Icon: "information.png", IconName: "Notice"));
    listofmenus.add(new Menu(Icon: "complaint.png", IconName: "Complaints"));
    listofmenus.add(new Menu(Icon: "directory.png", IconName: "Directory"));

    listofmenus.add(new Menu(Icon: "mySociety.png", IconName: "MySociety"));
    listofmenus.add(new Menu(Icon: "emergency.png", IconName: "Emergency"));
    listofmenus.add(new Menu(Icon: "polling.png", IconName: "Polling"));
    listofmenus.add(new Menu(Icon: "gallery.png", IconName: "Gallery"));

    listofmenus.add(new Menu(Icon: "bill.png", IconName: "Bills"));
    listofmenus.add(new Menu(Icon: "Utilities.png", IconName: "Amenities"));
    listofmenus.add(new Menu(Icon: "event_society.png", IconName: "Events"));

    return listofmenus;
  }
}
