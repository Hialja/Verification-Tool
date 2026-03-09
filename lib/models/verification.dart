import 'package:hive/hive.dart';

part 'verification.g.dart';

@HiveType(typeId: 0)
class Verification extends HiveObject{

  @HiveField(0)
  String employeeName;

  @HiveField(1)
  String companyName;

  @HiveField(2)
  String companyAddress;

  @HiveField(3)
  String respName;

  @HiveField(4)
  String contactNumber;

  @HiveField(5)
  String notes;

  @HiveField(6)
  DateTime visitDate;

  @HiveField(7)
  List<String> photos;

  @HiveField(8)
  String id;


  Verification({
    required this.id,
    required this.employeeName,
    required this.companyName,
    required this.companyAddress,
    required this.respName,
    required this.contactNumber,
    required this.notes,
    required this.visitDate,
    this.photos = const []
  });
}