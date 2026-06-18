import 'package:openfoodfacts/openfoodfacts.dart';

extension NutrientExtension on Nutrient {
  String get displayName {
    switch (this) {
      case Nutrient.energyKJ:
      case Nutrient.energyKCal:
        return "Energy";
      case Nutrient.proteins:
        return "Protein";
      case Nutrient.fat:
        return "Fat";
      case Nutrient.carbohydrates:
        return "Carbs";
      case Nutrient.sugars:
        return "Sugars";
      case Nutrient.salt:
        return "Salt";
      default:
        return name.replaceFirst(name[0], name[0].toUpperCase());
    }
  }
}
