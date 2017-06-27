//
//  LPBundleSetting.swift
//  LPIM
//
//  Created by lipeng on 2017/6/26.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMAVChat

/// 部分API提供了额外的选项，如删除消息会有是否删除会话的选项,为了测试方便提供配置参数
/// 上层开发只需要按照策划需求选择一种适合自己项目的选项即可，这个设置只是为了方便测试不同的case下API的正确性

struct LPBundleSetting {
    static let shared: LPBundleSetting = { return LPBundleSetting() }()
    
    /// 删除消息时是否同时删除会话项
    func removeSessionWheDeleteMessages() -> Bool {
        return UserDefaults.standard.bool(forKey: "enabled_remove_recent_session")
    }
    
    /// 本地搜索消息顺序 YES表示按时间戳逆序搜索,NO表示按照时间戳顺序搜索
    func localSearchOrderByTimeDesc() -> Bool {
        return UserDefaults.standard.bool(forKey: "local_search_time_order_desc")
    }
    
    /// 删除会话时是不是也同时删除服务器会话 (防止漫游)
    func autoRemoveRemoteSession() -> Bool {
        return UserDefaults.standard.bool(forKey: "auto_remove_remote_session")
    }
    
    /// 阅后即焚消息在看完后是否删除
    func autoRemoveSnapMessage() -> Bool {
        return UserDefaults.standard.bool(forKey: "auto_remove_snap_message")
    }
    
    /// 添加好友是否需要验证
    func needVerifyForFriend() -> Bool {
        return UserDefaults.standard.bool(forKey: "add_friend_need_verify")
    }
    
    /// 是否显示Fps
    func showFps() -> Bool {
        return UserDefaults.standard.bool(forKey: "show_fps_for_app")
    }
    
    /// 贴耳的时候是否需要自动切换成听筒模式
    func disableProximityMonitor() -> Bool {
        return UserDefaults.standard.bool(forKey: "disable_proxmity_monitor")
    }
    
    /// 支持旋转(仅组件部分，其他部分可能会显示不正常，谨慎开启)
    func enableRotate() -> Bool {
        return UserDefaults.standard.bool(forKey: "enable_rotate")
    }
    
    /// 使用amr作为录音
    func usingAmr() -> Bool {
        return UserDefaults.standard.bool(forKey: "using_amr")
    }
    
    /// 需要忽略的群通知类型
    func ignoreTeamNotificationTypes() -> [String] {
        var types: [String] = []
        if let value = UserDefaults.standard.string(forKey: "ignore_team_types") {
            let typeDescription = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if typeDescription.characters.count > 0 {
                types = typeDescription.components(separatedBy: ",")
            }
        }
        return types
    }
    
    // MARK: -
    // MARK: - 网络通话和白板
    
    /// 服务器录制语音
    func serverRecordAudio() -> Bool {
        return UserDefaults.standard.bool(forKey: "server_record_audio")
    }
    
    /// 服务器录制视频
    func serverRecordVideo() -> Bool {
        return UserDefaults.standard.bool(forKey: "server_record_video")
    }
    
    /// 服务器录制白板数据
    func serverRecordWhiteboardData() -> Bool {
        return UserDefaults.standard.bool(forKey: "server_record_whiteboard_data")
    }
    
    /// 视频画面裁剪比例
    func videochatVideoCrop() -> NIMNetCallVideoCrop {
        let cropValue = UserDefaults.standard.integer(forKey: "videochat_video_crop")
        return NIMNetCallVideoCrop(rawValue: cropValue) ?? .crop16x9
    }
    
    /// 自动旋转视频聊天远端画面
    func videochatAutoRotateRemoteVideo() -> Bool {
        return UserDefaults.standard.bool(forKey: "videochat_auto_rotate_remote_video")
    }
    
    /// 对端画面的填充模式
    func videochatRemoteVideoContentMode() -> UIViewContentMode {
        let mode = UserDefaults.standard.integer(forKey: "videochat_remote_video_content_mode")
        return mode == 0 ? .scaleAspectFill : .scaleAspectFit
    }
    
    /// 期望的视频发送清晰度
    func preferredVideoQuality() -> NIMNetCallVideoQuality {
        let quality = UserDefaults.standard.integer(forKey: "videochat_preferred_video_quality")
        return NIMNetCallVideoQuality(rawValue: quality) ?? .qualityDefault;
    }
    
    /// 使用后置摄像头开始视频通话
    func startWithBackCamera() -> Bool {
        return UserDefaults.standard.bool(forKey: "videochat_start_with_back_camera")
    }
    
    /// 期望的视频编码器
    func perferredVideoEncoder() -> NIMNetCallVideoCodec {
        let value = UserDefaults.standard.integer(forKey: "videochat_preferred_video_encoder")
        return NIMNetCallVideoCodec(rawValue: UInt(value)) ?? .default
    }
    
    /// 期望的视频解码器
    func perferredVideoDecoder() -> NIMNetCallVideoCodec {
        let value = UserDefaults.standard.integer(forKey: "videochat_preferred_video_decoder")
        return NIMNetCallVideoCodec(rawValue: UInt(value)) ?? .default
    }
    
    /// 最大发送视频编码码率
    func videoMaxEncodeKbps() -> Int {
        return UserDefaults.standard.integer(forKey: "videochat_video_encode_max_kbps")
    }

    /// 本地录制视频码率
    func localRecordVideoKbps() -> Int {
        return UserDefaults.standard.integer(forKey: "videochat_local_record_video_kbps")
    }
    
    /// 自动结束AudioSession
    func autoDeactivateAudioSession() -> Bool {
        if let setting = UserDefaults.standard.object(forKey: "videochat_auto_disable_audiosession") {
            return (setting as AnyObject).boolValue
        }
        return true
    }
    
    /// 降噪开关
    func audioDenoise() -> Bool {
        if let setting = UserDefaults.standard.object(forKey: "videochat_audio_denoise") {
            return (setting as AnyObject).boolValue
        }
        return true
    }
    
    /// 语音检测开关
    func voiceDetect() -> Bool {
        if let setting = UserDefaults.standard.object(forKey: "videochat_voice_detect") {
            return (setting as AnyObject).boolValue
        }
        return true
    }
    
    /// 期望高清语音
    func preferHDAudio() -> Bool {
        if let setting = UserDefaults.standard.object(forKey: "videochat_prefer_hd_audio") {
            return (setting as AnyObject).boolValue
        }
        return true
    }
    
    /// 进聊天室重试次数
    func chatroomRetryCount() -> Int {
        if let setting = UserDefaults.standard.object(forKey: "videochat_prefer_hd_audio") {
            return (setting as AnyObject).integerValue
        }
        return 3
    }
}
