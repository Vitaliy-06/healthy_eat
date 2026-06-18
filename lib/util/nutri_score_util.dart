abstract class NutriScoreUtil {
  static String getNutriScoreByString(String nutriScore) {
    switch (nutriScore.toLowerCase()) {
      case "a":
        return "assets/images/Nutri-score-A.png";
      case "b":
        return "assets/images/Nutri-score-B.png";
      case "c":
        return "assets/images/Nutri-score-C.png";
      case "d":
        return "assets/images/Nutri-score-D.png";
      case "e":
        return "assets/images/Nutri-score-E.png";
      default:
        return "assets/images/Nutri-score-Unknown.png";
    }
  }

}