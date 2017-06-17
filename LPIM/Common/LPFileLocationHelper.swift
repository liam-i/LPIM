//
//  LPFileLocationHelper.swift
//  LPIM
//
//  Created by lipeng on 2017/6/17.
//  Copyright © 2017年 lipeng. All rights reserved.
//

public let kImageExt = "jpg"

private let kRDVideo = "video"
private let kRDImage = "image"

import Foundation
//#import <sys/stat.h>

struct LPFileLocationHelper {
    static var appDocumentPath: String? = {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let appKey = LPConfig.shared.appKey
        let appDocumentPath = "\(path)/\(appKey)/"
        
        if !FileManager.default.fileExists(atPath: appDocumentPath) {
            do {
                try FileManager.default.createDirectory(atPath: appDocumentPath, withIntermediateDirectories: false, attributes: nil)
                
                assert(FileManager.default.fileExists(atPath: appDocumentPath))
                
                var fileURL = URL(fileURLWithPath: appDocumentPath)
                
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try fileURL.setResourceValues(resourceValues)
            } catch {
                log.error(error)
                return nil
            }
        }
        
        return appDocumentPath
    }()
    
    //+ (NSString *)getAppTempPath;
    //+ (NSString *)userDirectory;
    //+ (NSString *)genFilenameWithExt:(NSString *)ext;
    //+ (NSString *)filepathForVideo:(NSString *)filename;
    //+ (NSString *)filepathForImage:(NSString *)filename;
}


//+ (NSString *)getAppTempPath
//{
//    return NSTemporaryDirectory();
//}
//
//+ (NSString *)userDirectory
//{
//    NSString *documentPath = [NTESFileLocationHelper getAppDocumentPath];
//    NSString *userID = [NIMSDK sharedSDK].loginManager.currentAccount;
//    if ([userID length] == 0)
//    {
//        DDLogError(@"Error: Get User Directory While UserID Is Empty");
//    }
//    NSString* userDirectory= [NSString stringWithFormat:@"%@%@/",documentPath,userID];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory
//                                  withIntermediateDirectories:NO
//                                                   attributes:nil
//                                                        error:nil];
//
//    }
//    return userDirectory;
//}
//
//+ (NSString *)resourceDir: (NSString *)resouceName
//{
//    NSString *dir = [[NTESFileLocationHelper userDirectory] stringByAppendingPathComponent:resouceName];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dir])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:dir
//                                  withIntermediateDirectories:NO
//                                                   attributes:nil
//                                                        error:nil];
//    }
//    return dir;
//}
//
//
//+ (NSString *)filepathForVideo:(NSString *)filename
//{
//    return [NTESFileLocationHelper filepathForDir:RDVideo
//                                     filename:filename];
//}
//
//+ (NSString *)filepathForImage:(NSString *)filename
//{
//    return [NTESFileLocationHelper filepathForDir:RDImage
//                                     filename:filename];
//}
//
//+ (NSString *)genFilenameWithExt:(NSString *)ext
//{
//    CFUUIDRef uuid = CFUUIDCreate(nil);
//    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
//    CFRelease(uuid);
//    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
//    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
//    return [ext length] ? [NSString stringWithFormat:@"%@.%@",name,ext]:name;
//}
//
//
//#pragma mark - 辅助方法
//+ (NSString *)filepathForDir:(NSString *)dirname
//                    filename:(NSString *)filename
//{
//    return [[NTESFileLocationHelper resourceDir:dirname] stringByAppendingPathComponent:filename];
//}
//
//@end

