//
//  LPPinyinConverter.swift
//  LPIM
//
//  Created by lipeng on 2017/6/27.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

struct LPPinyinConverter {
    static let shared: LPPinyinConverter = { return LPPinyinConverter() }()
    
    func toPinyin(_ source: String) -> String? {
        if source.characters.count == 0 {
            return nil
        }
        
//        let kCFStringTransformStripCombiningMarks: CFString! //删除重音符号
//        let kCFStringTransformToLatin: CFString! //中文的拉丁字母
//        let kCFStringTransformFullwidthHalfwidth: CFString!//全角半宽
//        let kCFStringTransformLatinKatakana: CFString!//片假名拉丁字母
//        let kCFStringTransformLatinHiragana: CFString!//平假名拉丁字母
//        let kCFStringTransformHiraganaKatakana: CFString!//平假名片假名
//        let kCFStringTransformMandarinLatin: CFString!//普通话拉丁字母
//        let kCFStringTransformLatinHangul: CFString!//韩文的拉丁字母
//        let kCFStringTransformLatinArabic: CFString!//阿拉伯语拉丁字母
//        let kCFStringTransformLatinHebrew: CFString!//希伯来语拉丁字母
//        let kCFStringTransformLatinThai: CFString!//泰国拉丁字母
//        let kCFStringTransformLatinCyrillic: CFString!//西里尔拉丁字母
//        let kCFStringTransformLatinGreek: CFString!//希腊拉丁字母
//        let kCFStringTransformToXMLHex: CFString!//转换为XML十六进制字符
//        let kCFStringTransformToUnicodeName: CFString!//转换为Unicode的名称
//        @availability(iOS, introduced=2.0)
//        let kCFStringTransformStripDiacritics: CFString!//转换成不带音标的符号
        
        let piyin = NSMutableString(string: source)
        CFStringTransform(piyin, nil, kCFStringTransformToLatin, false)
        let py = piyin.folding(options: NSString.CompareOptions.diacriticInsensitive, locale: Locale.current)
        return py.replacingOccurrences(of: "'", with: "")
    }
    
}
