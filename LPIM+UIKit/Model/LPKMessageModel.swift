//
//  LPKMessageModel.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

class LPKMessageModel: NSObject {
    var message: NIMMessage? // 消息数据
    
    //
    ///**
    // *  时间戳
    // *
    // *  @discussion 这个时间戳为缓存的界面显示的时间戳，消息发出的时候记录下的本地时间，
    // *              由于 NIMMessage 在服务器确认收到后会将自身发送时间 timestamp 字段修正为服务器时间，所以缓存当前发送的本地时间避免刷新时由于发送时间修
    // *              改导致的消息界面位置跳跃。
    // *              messageTime 和 message.timestamp 会有一定的误差。
    // */
    //@property (nonatomic,readonly) NSTimeInterval messageTime;
    ///**
    // *  消息对应的session配置
    // */
    //@property (nonatomic,strong) id<NIMSessionConfig>  sessionConfig;
    //
    //@property (nonatomic, readonly) CGSize     contentSize;
    //
    //@property (nonatomic, readonly) UIEdgeInsets  contentViewInsets;
    //
    //@property (nonatomic, readonly) UIEdgeInsets  bubbleViewInsets;
    //
    //@property (nonatomic, readonly) CGFloat avatarMargin;
    //
    //@property (nonatomic, readonly) CGFloat nickNameMargin;
    //
    //@property (nonatomic, readonly) BOOL shouldShowAvatar;
    //
    //@property (nonatomic, readonly) BOOL shouldShowNickName;
    //
    //@property (nonatomic, readonly) BOOL shouldShowLeft;
    //
    //@property (nonatomic) BOOL shouldShowReadLabel;
    //
    ///**
    // *  计算内容大小
    // *
    // *  @param width 内容宽度
    // */
    //- (void)calculateContent:(CGFloat)width force:(BOOL)force;
    //
    ///**
    // *  NIMMessage封装成NIMMessageModel的方法
    // *
    // *  @param  message 消息体
    // *
    // *  @return NIMMessageModel实例
    // */
    //- (instancetype)initWithMessage:(NIMMessage*)message;
    //
    ///**
    // *  清楚缓存的排版数据
    // */
    //- (void)cleanCache;
}





















//@interface NIMMessageModel()
//
//@end
//
//@implementation NIMMessageModel
//
//@synthesize contentSize        = _contentSize;
//@synthesize contentViewInsets  = _contentViewInsets;
//@synthesize bubbleViewInsets   = _bubbleViewInsets;
//@synthesize shouldShowAvatar   = _shouldShowAvatar;
//@synthesize shouldShowNickName = _shouldShowNickName;
//@synthesize shouldShowLeft     = _shouldShowLeft;
//@synthesize avatarMargin       = _avatarMargin;
//@synthesize nickNameMargin     = _nickNameMargin;
//
//- (instancetype)initWithMessage:(NIMMessage*)message
//{
//    if (self = [self init])
//    {
//        _message = message;
//        _messageTime = message.timestamp;
//    }
//    return self;
//}
//
//- (void)cleanCache
//{
//    _contentSize = CGSizeZero;
//    _contentViewInsets = UIEdgeInsetsZero;
//    _bubbleViewInsets = UIEdgeInsetsZero;
//}
//
//- (NSString*)description{
//    return self.message.text;
//}
//
//- (BOOL)isEqual:(id)object
//{
//    if (![object isKindOfClass:[NIMMessageModel class]])
//    {
//        return NO;
//    }
//    else
//    {
//        NIMMessageModel *model = object;
//        return [self.message isEqual:model.message];
//    }
//}
//
//- (void)calculateContent:(CGFloat)width force:(BOOL)force{
//    if (CGSizeEqualToSize(_contentSize, CGSizeZero) || force)
//    {
//        [self updateLayoutConfig];
//        id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
//        _contentSize = [layoutConfig contentSize:self cellWidth:width];
//    }
//}
//
//
//- (UIEdgeInsets)contentViewInsets{
//    if (UIEdgeInsetsEqualToEdgeInsets(_contentViewInsets, UIEdgeInsetsZero))
//    {
//        id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
//        _contentViewInsets = [layoutConfig contentViewInsets:self];
//    }
//    return _contentViewInsets;
//}
//
//- (UIEdgeInsets)bubbleViewInsets{
//    if (UIEdgeInsetsEqualToEdgeInsets(_bubbleViewInsets, UIEdgeInsetsZero))
//    {
//        id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
//        _bubbleViewInsets = [layoutConfig cellInsets:self];
//    }
//    return _bubbleViewInsets;
//}
//
//- (void)updateLayoutConfig
//{
//    id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
//
//    _shouldShowAvatar       = [layoutConfig shouldShowAvatar:self];
//    _shouldShowNickName     = [layoutConfig shouldShowNickName:self];
//    _shouldShowLeft         = [layoutConfig shouldShowLeft:self];
//    _avatarMargin           = [layoutConfig avatarMargin:self];
//    _nickNameMargin         = [layoutConfig nickNameMargin:self];
//}
//
//
//- (BOOL)shouldShowReadLabel
//{
//    return _shouldShowReadLabel && self.message.isRemoteRead;
//}
//
//@end
