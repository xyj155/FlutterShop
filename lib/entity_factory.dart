import 'package:sauce_app/gson/business_shop_list_entity.dart';
import 'package:sauce_app/gson/commodity_list_item_entity.dart';
import 'package:sauce_app/gson/commodity_tasty_entity.dart';
import 'package:sauce_app/gson/home_title_avatar_entity.dart';
import 'package:sauce_app/gson/home_user_topic_entity.dart';
import 'package:sauce_app/gson/part_time_job_list_entity.dart';
import 'package:sauce_app/gson/shop_kind_list_entity.dart';
import 'package:sauce_app/gson/square_banner_entity.dart';
import 'package:sauce_app/gson/square_purse_title_entity.dart';
import 'package:sauce_app/gson/university_entity.dart';
import 'package:sauce_app/gson/user_contact_list_entity.dart';
import 'package:sauce_app/gson/user_entity.dart';
import 'package:sauce_app/gson/user_item_entity.dart';
import 'package:sauce_app/gson/user_post_item_detail_entity.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "BusinessShopListEntity") {
      return BusinessShopListEntity.fromJson(json) as T;
    } else if (T.toString() == "CommodityListItemEntity") {
      return CommodityListItemEntity.fromJson(json) as T;
    } else if (T.toString() == "CommodityTastyEntity") {
      return CommodityTastyEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeTitleAvatarEntity") {
      return HomeTitleAvatarEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeUserTopicEntity") {
      return HomeUserTopicEntity.fromJson(json) as T;
    } else if (T.toString() == "PartTimeJobListEntity") {
      return PartTimeJobListEntity.fromJson(json) as T;
    } else if (T.toString() == "ShopKindListEntity") {
      return ShopKindListEntity.fromJson(json) as T;
    } else if (T.toString() == "SquareBannerEntity") {
      return SquareBannerEntity.fromJson(json) as T;
    } else if (T.toString() == "SquarePurseTitleEntity") {
      return SquarePurseTitleEntity.fromJson(json) as T;
    } else if (T.toString() == "UniversityEntity") {
      return UniversityEntity.fromJson(json) as T;
    } else if (T.toString() == "UserContactListEntity") {
      return UserContactListEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else if (T.toString() == "UserItemEntity") {
      return UserItemEntity.fromJson(json) as T;
    } else if (T.toString() == "UserPostItemDetailEntity") {
      return UserPostItemDetailEntity.fromJson(json) as T;
    } else if (T.toString() == "UserPostItemEntity") {
      return UserPostItemEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}