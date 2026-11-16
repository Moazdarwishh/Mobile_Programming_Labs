class Destination {
  final String name;
  final String capital;
  final String region;
  final int population;
  final String flagUrl;

  Destination({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    String? capital = json['capital'];
    if (capital == null || capital.isEmpty) {
      capital = 'N/A';
    }

    final String code = json['alpha2Code'];

    return Destination(
      name: json['name'],
      capital: capital,
      region: json['region'],
      population: json['population'],
      flagUrl: 'https://flagcdn.com/w80/${code.toLowerCase()}.png',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'capital': capital,
      'region': region,
      'population': population,
      'flagUrl': flagUrl,
    };
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      name: map['name'],
      capital: map['capital'],
      region: map['region'],
      population: map['population'],
      flagUrl: map['flagUrl'],
    );
  }
}
