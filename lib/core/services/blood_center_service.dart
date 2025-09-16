import 'package:donor_dashboard/data/models/blood_center_model.dart';
import 'package:donor_dashboard/data/mock_data.dart';

class BloodCenterService {
  static final BloodCenterService _instance = BloodCenterService._internal();
  factory BloodCenterService() => _instance;
  BloodCenterService._internal();

  List<BloodCenterModel> _bloodCenters = [];
  List<BloodCenterModel> _userBloodCenters = [];

  List<BloodCenterModel> get bloodCenters => _bloodCenters;
  List<BloodCenterModel> get userBloodCenters => _userBloodCenters;

  Future<void> init() async {
    
    _bloodCenters = mockBloodCenters;
    
    _userBloodCenters = [];
  }

  Future<bool> addBloodCenter(BloodCenterModel center) async {
    try {
      _userBloodCenters.add(center);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeBloodCenter(String centerId) async {
    try {
      _userBloodCenters.removeWhere((center) => center.id == centerId);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<BloodCenterModel> getAllCenters() {
    return [..._bloodCenters, ..._userBloodCenters];
  }

  List<BloodCenterModel> getUserCenters() {
    return _userBloodCenters;
  }
}
