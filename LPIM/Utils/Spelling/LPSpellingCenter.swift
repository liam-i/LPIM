//
//  LPSpellingCenter.swift
//  LPIM
//
//  Created by lipeng on 2017/6/27.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation

private let SPELLING_UNIT_FULLSPELLING  = "f"
private let SPELLING_UNIT_SHORTSPELLING = "s"
private let SPELLING_CACHE              = "sc"

class LPSpellingUnit: NSObject, NSCoding {
    var fullSpelling: String?
    var shortSpelling: String?
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        fullSpelling = aDecoder.decodeObject(forKey: SPELLING_UNIT_FULLSPELLING) as? String
        shortSpelling = aDecoder.decodeObject(forKey: SPELLING_UNIT_SHORTSPELLING) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        if let fullSpelling = fullSpelling {
            aCoder.encode(fullSpelling, forKey: SPELLING_UNIT_FULLSPELLING)
        }
        if let shortSpelling = shortSpelling {
            aCoder.encode(shortSpelling, forKey: SPELLING_UNIT_SHORTSPELLING)
        }
    }
}


class LPSpellingCenter {
    private var spellingCache: NSMutableDictionary? //全拼，简称cache
    private var filePath: String = ""
    private lazy var queue: DispatchQueue = DispatchQueue(label: "com.lpim.lock.savespelling")
    
    static let shared: LPSpellingCenter = { return LPSpellingCenter() }()
    
    init() {
        if let canche = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            filePath = "\(canche)/\(SPELLING_CACHE)"
        }
        
        spellingCache = nil
        if FileManager.default.fileExists(atPath: filePath) {
            
            if let obj = NSKeyedUnarchiver.unarchiveObject(withFile: filePath), let dict = obj as? NSDictionary {
                spellingCache = NSMutableDictionary(dictionary: dict)
            }
        }
        
        if spellingCache == nil {
            spellingCache = NSMutableDictionary()
        }
    }
    
    /// 写入缓存
    func saveSpellingCache() {
        let kMaxEntriesCount = 5000
        queue.sync {
            guard let spellingCache = spellingCache else { return }
            
            let count = spellingCache.count
            if count >= kMaxEntriesCount {
                log.debug("Clear Spelling Cache \(count) Entries")
                spellingCache.removeAllObjects()
            }
            
            let data = NSKeyedArchiver.archivedData(withRootObject: spellingCache)
            try? data.write(to: URL(fileURLWithPath: filePath), options: Data.WritingOptions.atomic)
        }
    }
    
    /// 全拼，简拼 (全是小写)
    func spelling(for source: String) -> LPSpellingUnit? {
        if source.characters.count == 0 {
            return nil
        }
        
        var spellingUnit: LPSpellingUnit? = nil
        queue.sync {
            var unit = spellingCache?[source] as? LPSpellingUnit
            if unit == nil {
                let u = calcSpelling(of: source)
                if let full = u.fullSpelling, let short = u.shortSpelling, full.characters.count > 0, short.characters.count > 0 {
                    spellingCache?[source] = u
                }
                unit = u
            }
            spellingUnit = unit
        }
        return spellingUnit
    }
    
    /// 首字母
    func firstLetter(_ input: String) -> String? {
        let unit = spelling(for: input)
        if let unit = unit, let spelling = unit.fullSpelling, spelling.characters.count > 0 {
            return spelling.substring(to: spelling.characters.index(spelling.startIndex, offsetBy: 1))
        }
        return nil
    }
    
    private func calcSpelling(of source: String) -> LPSpellingUnit {
        var fullSpelling: String = ""
        var shortSpelling: String = ""
        for i in 0..<source.characters.count {
            let startIndex = source.characters.index(source.startIndex, offsetBy: i)
            let endIndex = source.characters.index(startIndex, offsetBy: 1)
            let word = source.substring(with: Range(startIndex..<endIndex))
            
            if let pinyin = LPPinyinConverter.shared.toPinyin(word), pinyin.characters.count > 0 {
                fullSpelling += pinyin
                shortSpelling += pinyin.substring(to: pinyin.characters.index(pinyin.startIndex, offsetBy: 1))
            }
        }
        
        let unit = LPSpellingUnit()
        unit.fullSpelling = fullSpelling.lowercased()
        unit.shortSpelling = shortSpelling.lowercased()
        return unit
    }
}
