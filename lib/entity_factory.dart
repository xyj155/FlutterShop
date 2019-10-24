import 'package:sauce_app/gson/business_banner_entity.dart';
import 'package:sauce_app/gson/business_class_tags_entity.dart';
import 'package:sauce_app/gson/business_shop_list_entity.dart';
import 'package:sauce_app/gson/commodity_list_item_entity.dart';
import 'package:sauce_app/gson/commodity_tasty_entity.dart';
import 'package:sauce_app/gson/game_invite_list_entity.dart';
import 'package:sauce_app/gson/home_title_avatar_entity.dart';
import 'package:sauce_app/gson/home_user_topic_entity.dart';
import 'package:sauce_app/gson/part_time_job_list_entity.dart';
import 'package:sauce_app/gson/post_comment_list_entity.dart';
import 'package:sauce_app/gson/school_activity_entity.dart';
import 'package:sauce_app/gson/shop_kind_list_entity.dart';
import 'package:sauce_app/gson/single_part_time_job_detail_entity.dart';
import 'package:sauce_app/gson/square_banner_entity.dart';
import 'package:sauce_app/gson/square_purse_title_entity.dart';
import 'package:sauce_app/gson/university_entity.dart';
import 'package:sauce_app/gson/user_comment_reply_entity.dart';
import 'package:sauce_app/gson/user_contact_list_entity.dart';
import 'package:sauce_app/gson/user_entity.dart';
import 'package:sauce_app/gson/user_item_entity.dart';
import 'package:sauce_app/gson/user_like_and_thumb_entity.dart';
import 'package:sauce_app/gson/user_post_item_detail_entity.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';
import 'package:sauce_app/gson/user_receive_address_entity.dart';
import 'package:sauce_app/gson/user_shop_car_entity.dart';
import 'package:sauce_app/gson/user_thumb_and_replay_entity.dart';
import 'package:sauce_app/gson/user_view_detail_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "BusinessBannerEntity") {
      return BusinessBannerEntity.fromJson(json) as T;
    } else if (T.toString() == "BusinessClassTagsEntity") {
      return BusinessClassTagsEntity.fromJson(json) as T;
    } else if (T.toString() == "BusinessShopListEntity") {
      return BusinessShopListEntity.fromJson(json) as T;
    } else if (T.toString() == "CommodityListItemEntity") {
      return CommodityListItemEntity.fromJson(json) as T;
    } else if (T.toString() == "CommodityTastyEntity") {
      return CommodityTastyEntity.fromJson(json) as T;
    } else if (T.toString() == "GameInviteListEntity") {
      return GameInviteListEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeTitleAvatarEntity") {
      return HomeTitleAvatarEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeUserTopicEntity") {
      return HomeUserTopicEntity.fromJson(json) as T;
    } else if (T.toString() == "PartTimeJobListEntity") {
      return PartTimeJobListEntity.fromJson(json) as T;
    } else if (T.toString() == "PostCommentListEntity") {
      return PostCommentListEntity.fromJson(json) as T;
    } else if (T.toString() == "SchoolActivityEntity") {
      return SchoolActivityEntity.fromJson(json) as T;
    } else if (T.toString() == "ShopKindListEntity") {
      return ShopKindListEntity.fromJson(json) as T;
    } else if (T.toString() == "SinglePartTimeJobDetailEntity") {
      return SinglePartTimeJobDetailEntity.fromJson(json) as T;
    } else if (T.toString() == "SquareBannerEntity") {
      return SquareBannerEntity.fromJson(json) as T;
    } else if (T.toString() == "SquarePurseTitleEntity") {
      return SquarePurseTitleEntity.fromJson(json) as T;
    } else if (T.toString() == "UniversityEntity") {
      return UniversityEntity.fromJson(json) as T;
    } else if (T.toString() == "UserCommentReplyEntity") {
      return UserCommentReplyEntity.fromJson(json) as T;
    } else if (T.toString() == "UserContactListEntity") {
      return UserContactListEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else if (T.toString() == "UserItemEntity") {
      return UserItemEntity.fromJson(json) as T;
    } else if (T.toString() == "UserLikeAndThumbEntity") {
      return UserLikeAndThumbEntity.fromJson(json) as T;
    } else if (T.toString() == "UserPostItemDetailEntity") {
      return UserPostItemDetailEntity.fromJson(json) as T;
    } else if (T.toString() == "UserPostItemEntity") {
      return UserPostItemEntity.fromJson(json) as T;
    } else if (T.toString() == "UserReceiveAddressEntity") {
      return UserReceiveAddressEntity.fromJson(json) as T;
    } else if (T.toString() == "UserShopCarEntity") {
      return UserShopCarEntity.fromJson(json) as T;
    } else if (T.toString() == "UserThumbAndReplayEntity") {
      return UserThumbAndReplayEntity.fromJson(json) as T;
    } else if (T.toString() == "UserViewDetailEntity") {
      return UserViewDetailEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}