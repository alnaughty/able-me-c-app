import 'package:able_me/models/profile/user_address.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';

extension CHECK on CurrentAddress {
  bool isSame(UserAddress address) {
    return addressLine == address.addressLine &&
        city == address.city &&
        locality == address.locality &&
        address.countryCode == countryCode;
  }
}
