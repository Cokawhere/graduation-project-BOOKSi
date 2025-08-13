import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  final RxString selectedGovernment = ''.obs;
  final RxString selectedCity = ''.obs;
  final List<String> governments = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Fayoum',
    'Gharbia',
    'Ismailia',
    'Monufia',
    'Minya',
    'Qalyubia',
    'New Valley',
    'Suez',
    'Aswan',
    'Assiut',
    'Beni Suef',
    'Port Said',
    'Damietta',
    'Sharkia',
    'South Sinai',
    'Kafr El Sheikh',
    'Matrouh',
    'Luxor',
    'Qena',
    'North Sinai',
    'Sohag',
  ];
  final Map<String, List<String>> cities = {
    'Cairo': [
      'Heliopolis',
      'Nasr City',
      'Maadi',
      'New Cairo',
      'Shubra',
      'Helwan',
      'Downtown',
      'El Marg',
      'Ain Shams',
      'El Mokattam',
    ],
    'Giza': [
      'Dokki',
      'Mohandessin',
      '6th of October City',
      'Haram',
      'Sheikh Zayed',
      'Imbaba',
      'Warraq',
      'Bulaq Dakrour',
      'Faisal',
    ],
    'Alexandria': [
      'Smouha',
      'Sidi Gaber',
      'Miami',
      'Stanley',
      'Roushdy',
      'Mandara',
      'Gleem',
      'Borg El Arab',
      'Agamy',
    ],
    'Dakahlia': [
      'Mansoura',
      'Mit Ghamr',
      'Talkha',
      'Dikirnis',
      'Sherbin',
      'Aga',
      'Gamasa',
      'Nabaroh',
    ],
    'Red Sea': ['Hurghada', 'Safaga', 'Quseir', 'Marsa Alam'],
    'Beheira': ['Damanhour', 'Kafr El Dawwar', 'Edko', 'Abu Hummus', 'Rashid'],
    'Fayoum': ['Fayoum City', 'Ibshway', 'Sinnuris', 'Tamia', 'Youssef El Seddik'],
    'Gharbia': [
      'Tanta',
      'El Mahalla El Kubra',
      'Kafr El Zayat',
      'Zefta',
      'Samannoud',
    ],
    'Ismailia': [
      'Ismailia City',
      'Fayed',
      'Qantara Sharq',
      'Qantara Gharb',
      'Tal El Kebir',
    ],
    'Monufia': [
      'Shibin El Kom',
      'Menouf',
      'Ashmoun',
      'Sadat City',
      'Birket El Sab',
    ],
    'Minya': ['Minya City', 'Maghagha', 'Beni Mazar', 'Malawi', 'Samalut'],
    'Qalyubia': [
      'Banha',
      'Qalyub',
      'Shubra El Kheima',
      'Khanka',
      'Shebin El Qanater',
      'Tukh',
    ],
    'New Valley': ['Kharga', 'Dakhla', 'Farafra', 'Baris'],
    'Suez': ['Suez City', 'Ataqah', 'Ain Sokhna'],
    'Aswan': ['Aswan City', 'Edfu', 'Kom Ombo', 'Daraw', 'Abu Simbel'],
    'Assiut': ['Assiut City', 'Abnub', 'Manfalut', 'Dairut', 'El Quseyya'],
    'Beni Suef': ['Beni Suef City', 'Nasser', 'Beba', 'Ehnasia', 'El Wasta'],
    'Port Said': ['Port Said City', 'Port Fouad'],
    'Damietta': ['Damietta City', 'Faraskur', 'Kafr Saad', 'Ras El Bar'],
    'Sharkia': [
      'Zagazig',
      'Belbeis',
      'Abu Hammad',
      'Minya El Qamh',
      'Kafr Saqr',
    ],
    'South Sinai': ['Sharm El Sheikh', 'Dahab', 'Nuweiba', 'Taba', 'Ras Sudr'],
    'Kafr El Sheikh': [
      'Kafr El Sheikh City',
      'Desouk',
      'Baltim',
      'Sidi Salem',
      'Fouh',
    ],
    'Matrouh': ['Marsa Matruh', 'Sidi Barrani', 'El Alamein', 'Siwa'],
    'Luxor': ['Luxor City', 'Esna', 'Armant', 'El Tod'],
    'Qena': ['Qena City', 'Nag Hammadi', 'Qus', 'Dishna'],
    'North Sinai': ['Arish', 'Sheikh Zuweid', 'Rafah', 'Bir al-Abed'],
    'Sohag': ['Sohag City', 'Akhmim', 'Girga', 'Tama', 'El Balyana'],
  };

  List<String> get Cities =>
      selectedGovernment.value.isEmpty ? [] : cities[selectedGovernment.value]!;

  void updateGovernment(String value) {
    selectedGovernment.value = value;
    selectedCity.value = ''; // Reset city when government changes
  }

  Map<String, dynamic> getShippingInfo() {
    return {
      'name': nameController.text,
      'phone': phoneController.text,
      'government': selectedGovernment.value,
      'city': selectedCity.value,
      'address': addressController.text,
      'note': noteController.text.isEmpty ? null : noteController.text,
    };
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.onClose();
  }
}