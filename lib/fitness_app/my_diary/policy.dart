class Policy {
  final int id;
  final String title;
  final String intro;
  final String imageUrl;
  final String policyField;
  final String dDay;

  Policy({
    required this.id,
    required this.title,
    required this.intro,
    required this.imageUrl,
    required this.policyField,
    required this.dDay,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'],
      title: json['title'],
      intro: json['intro'],
      imageUrl: json['image_url'],
      policyField: json['policy_field'],
      dDay: json['d_day'],
    );
  }
}