//
//  LPKContactSelectConfig.swift
//  LPIM
//
//  Created by lipeng on 2017/6/28.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
//typedef NS_ENUM(NSInteger, NIMContactSelectType) {
//    NIMContactSelectTypeFriend,
//    NIMContactSelectTypeTeamMember,
//    NIMContactSelectTypeTeam,
//};
//
//
//@protocol NIMContactSelectConfig <NSObject>
//
//@required
///**
// *  联系人选择器中的数据源类型
// *  当是群组时，需要设置群组id
// */
//- (NIMContactSelectType)selectType;
//
//
//@optional
//
///**
// *  联系人选择器标题
// */
//- (NSString *)title;
//
///**
// *  最多选择的人数
// */
//- (NSInteger)maxSelectedNum;
//
///**
// *  超过最多选择人数时的提示
// */
//- (NSString *)selectedOverFlowTip;
//
///**
// *  默认已经勾选的人或群组
// */
//- (NSArray *)alreadySelectedMemberId;
//
///**
// *  需要过滤的人或群组id
// */
//- (NSArray *)filterIds;
//
///**
// *  当数据源类型为群组时，需要设置的群id
// *
// *  @return 群id
// */
//- (NSString *)teamId;
//
///**
// *  显示具体选择人数
// */
//- (BOOL)showSelectDetail;
//
//@end
//
///**
// *  内置配置-选择好友
// */
//@interface NIMContactFriendSelectConfig : NSObject<NIMContactSelectConfig>
//
//@property (nonatomic,assign) BOOL needMutiSelected;
//
//@property (nonatomic,assign) NSInteger maxSelectMemberCount;
//
//@property (nonatomic,copy) NSArray *alreadySelectedMemberId;
//
//@property (nonatomic,copy) NSArray *filterIds;
//
//@property (nonatomic,assign) BOOL showSelectDetail;
//
//@end
//
///**
// *  内置配置-选择群成员
// */
//@interface NIMContactTeamMemberSelectConfig : NSObject<NIMContactSelectConfig>
//
//@property (nonatomic,copy) NSString *teamId;
//
//@property (nonatomic,assign) BOOL needMutiSelected;
//
//@property (nonatomic,assign) NSInteger maxSelectMemberCount;
//
//@property (nonatomic,copy) NSArray *alreadySelectedMemberId;
//
//@property (nonatomic,copy) NSArray *filterIds;
//
//@property (nonatomic,assign) BOOL showSelectDetail;
//
//@end
//
//
///**
// *  内置配置-选择群
// */
//@interface NIMContactTeamSelectConfig : NSObject<NIMContactSelectConfig>
//
//@property (nonatomic,assign) BOOL needMutiSelected;
//
//@property (nonatomic,assign) NSInteger maxSelectMemberCount;
//
//@property (nonatomic,copy) NSArray *alreadySelectedMemberId;
//
//@property (nonatomic,copy) NSArray *filterIds;
//
//@property (nonatomic,assign) BOOL showSelectDetail;
//
//@end














//@implementation NIMContactFriendSelectConfig : NSObject
//
//- (NIMContactSelectType)selectType{
//    return NIMContactSelectTypeFriend;
//}
//
//
//- (BOOL)isMutiSelected{
//    return self.needMutiSelected;
//}
//
//- (NSString *)title{
//    return @"选择联系人";
//}
//
//
//- (NSInteger)maxSelectedNum{
//    if (self.needMutiSelected) {
//        return self.maxSelectMemberCount? self.maxSelectMemberCount : NSIntegerMax;
//    }else{
//        return 1;
//    }
//}
//
//- (NSString *)selectedOverFlowTip{
//    return @"选择超限";
//}
//
//
//@end
//
//@implementation NIMContactTeamMemberSelectConfig : NSObject
//
//- (NIMContactSelectType)selectType{
//    return NIMContactSelectTypeTeamMember;
//}
//
//
//- (NSInteger)maxSelectedNum{
//    if (self.needMutiSelected) {
//        return self.maxSelectMemberCount? self.maxSelectMemberCount : NSIntegerMax;
//    }else{
//        return 1;
//    }
//}
//
//- (NSString *)title{
//    return @"选择联系人";
//}
//
//
//- (NSString *)selectedOverFlowTip{
//    return @"选择超限";
//}
//
//@end
//
//@implementation NIMContactTeamSelectConfig : NSObject
//
//- (NIMContactSelectType)selectType{
//    return NIMContactSelectTypeTeam;
//}
//
//
//
//- (NSString *)title{
//    return @"选择群组";
//}
//
//- (NSInteger)maxSelectedNum{
//    if (self.needMutiSelected) {
//        return self.maxSelectMemberCount? self.maxSelectMemberCount : NSIntegerMax;
//    }else{
//        return 1;
//    }
//}
//
//- (NSString *)selectedOverFlowTip{
//    return @"选择超限";
//}
//
//
//@end
