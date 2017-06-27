//
//  LPJanKenPonAttachment.swift
//  LPIM
//
//  Created by lipeng on 2017/6/27.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

//typedef NS_ENUM(NSInteger, CustomJanKenPonValue) {
//    CustomJanKenPonValueKen     = 1,//石头
//    CustomJanKenPonValueJan     = 2,//剪子
//    CustomJanKenPonValuePon     = 3,//布
//};
//
//@interface NTESJanKenPonAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>
//
//@property (nonatomic,assign)    CustomJanKenPonValue value;
//
//@property (nonatomic,strong)    UIImage *showCoverImage;
//
//@end


class LPJanKenPonAttachment: NSObject {

}

//- (NSString *)encodeAttachment
//{
//    NSDictionary *dict = @{CMType : @(CustomMessageTypeJanKenPon),
//                           CMData : @{CMValue:@(self.value)}};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
//                                                   options:0
//                                                     error:nil];
//    NSString *content = nil;
//    if (data) {
//        content = [[NSString alloc] initWithData:data
//                                        encoding:NSUTF8StringEncoding];
//    }
//    return content;
//}
//
//
//- (NSString *)cellContent:(NIMMessage *)message{
//    return @"NTESSessionJankenponContentView";
//}
//
//- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
//
//    return self.showCoverImage.size;
//}
//
//- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
//{
//    if (message.session.sessionType == NIMSessionTypeChatroom)
//    {
//        CGFloat bubbleMarginTopForImage  = 15.f;
//        CGFloat bubbleMarginLeftForImage = 12.f;
//        return  UIEdgeInsetsMake(bubbleMarginTopForImage,bubbleMarginLeftForImage,0,0);
//    }
//    else
//    {
//        CGFloat bubbleMarginForImage    = 3.f;
//        CGFloat bubbleArrowWidthForImage = 5.f;
//        if (message.isOutgoingMsg) {
//            return  UIEdgeInsetsMake(bubbleMarginForImage,bubbleMarginForImage,bubbleMarginForImage,bubbleMarginForImage + bubbleArrowWidthForImage);
//        }else{
//            return  UIEdgeInsetsMake(bubbleMarginForImage,bubbleMarginForImage + bubbleArrowWidthForImage, bubbleMarginForImage,bubbleMarginForImage);
//        }
//    }
//}
//
//- (UIImage *)showCoverImage
//{
//    if (_showCoverImage == nil)
//    {
//        UIImage *image;
//        switch (self.value) {
//            case CustomJanKenPonValueJan:
//                image    = [UIImage imageNamed:@"custom_msg_jan"];
//                break;
//            case CustomJanKenPonValueKen:
//                image    = [UIImage imageNamed:@"custom_msg_ken"];
//                break;
//            case CustomJanKenPonValuePon:
//                image    = [UIImage imageNamed:@"custom_msg_pon"];
//                break;
//            default:
//                break;
//        }
//        _showCoverImage = image;
//    }
//    return _showCoverImage;
//}
