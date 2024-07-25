class Validator{
  static String? validateNumber(String? value){
    if(value == null || value.isEmpty){
      return "Veuillez saisir un nombre valide";
    } 
    
    return null;
  }
}