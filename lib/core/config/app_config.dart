class CurrencyOption {
  final String code;
  final String symbol;
  final bool isDefault;

  const CurrencyOption({required this.code, required this.symbol, required this.isDefault});

  factory CurrencyOption.fromJson(Map<String, dynamic> json) => CurrencyOption(
        code: json['code'] as String,
        symbol: json['symbol'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );
}

class AppConfig {
  final List<String> languages;
  final String defaultLanguage;
  final List<CurrencyOption> currencies;
  final String defaultCurrency;

  const AppConfig({
    required this.languages,
    required this.defaultLanguage,
    required this.currencies,
    required this.defaultCurrency,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
        languages: List<String>.from(json['languages'] as List),
        defaultLanguage: json['defaultLanguage'] as String,
        currencies: (json['currencies'] as List).map((e) => CurrencyOption.fromJson(e)).toList(),
        defaultCurrency: json['defaultCurrency'] as String,
      );
}
