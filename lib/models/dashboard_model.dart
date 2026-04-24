class DashboardData {
  final Map<String, List<MenuItem>> categories;

  DashboardData({required this.categories});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    Map<String, List<MenuItem>> categories = {};
    json.forEach((key, value) {
      if (value is List) {
        categories[key] = value.map((item) => MenuItem.fromJson(item)).toList();
      }
    });
    return DashboardData(categories: categories);
  }

  /// Digunakan saat API mengembalikan data sebagai flat List.
  /// Item dikelompokkan otomatis berdasarkan field module.category.
  factory DashboardData.fromList(List<dynamic> list) {
    final Map<String, List<MenuItem>> categories = {};
    for (final item in list) {
      final menuItem = MenuItem.fromJson(item as Map<String, dynamic>);
      final category = menuItem.module.category;
      categories.putIfAbsent(category, () => []).add(menuItem);
    }
    return DashboardData(categories: categories);
  }
}

class MenuItem {
  final int id;
  final String menuName;
  final int displayOrder;
  final bool isActive;
  final Module module;
  final Content content;

  MenuItem({
    required this.id,
    required this.menuName,
    required this.displayOrder,
    required this.isActive,
    required this.module,
    required this.content,
  });

  bool get isActiveAsBool => isActive;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // is_active bisa datang sebagai bool atau int (0/1) dari API
    final rawActive = json['is_active'];
    final isActive = rawActive is bool ? rawActive : (rawActive == 1);
    return MenuItem(
      id: json['id'] ?? 0,
      menuName: json['menu_name'] ?? '',
      displayOrder: json['display_order'] ?? 0,
      isActive: isActive,
      module: Module.fromJson(json['module'] as Map<String, dynamic>? ?? {}),
      content: Content.fromJson(json['content'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Module {
  final int id;
  final String moduleName;
  final String moduleDescription;
  final String category;

  Module({
    required this.id,
    required this.moduleName,
    required this.moduleDescription,
    required this.category,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? 0,
      moduleName: json['module_name'] ?? '',
      moduleDescription: json['module_description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class Content {
  final String type;
  final String title;
  final String version;
  final String repo;

  Content({
    required this.type,
    required this.title,
    required this.version,
    required this.repo,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      version: json['version'] ?? '',
      repo: json['repo'] ?? '',
    );
  }
}
