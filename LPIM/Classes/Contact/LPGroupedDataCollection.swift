//
//  LPGroupedDataCollection.swift
//  LPIM
//
//  Created by lipeng on 2017/6/27.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

private class LPPair {
    var first: String
    var second: NSMutableArray
    
    init(first: String, second: [LPGroupMemberProtocol]) {
        self.first = first
        self.second = NSMutableArray(array: second)
    }
}

class LPGroupedDataCollection {
    private lazy var specialGroupTitles = NSMutableOrderedSet()
    private lazy var specialGroups = NSMutableOrderedSet()
    private lazy var groupTitles: NSMutableOrderedSet = NSMutableOrderedSet()
    private lazy var groups = NSMutableOrderedSet()
    
    var groupTitleComparator: Comparator
    var groupMemberComparator: Comparator
    var sortedGroupTitles: [String] {
        return groupTitles.array as? [String] ?? []
    }
    
    init() {
        groupTitleComparator =  { (title1, title2) -> ComparisonResult in
            if let title1 = title1 as? String, let title2 = title2 as? String {
                if title1 == "#" {
                    return .orderedDescending
                }
                if title2 == "#" {
                    return .orderedDescending
                }
                return title1.compare(title2)
            }
            return .orderedAscending
        }
        
        groupMemberComparator = { (key1, key2) -> ComparisonResult in
            if let key1 = key1 as? String, let key2 = key2 as? String {
                return key1.compare(key2)
            }
            return .orderedAscending
        }
    }
    
    func setupMembers(_ members: [LPGroupMemberProtocol]) {
        var tmp: [String: [LPGroupMemberProtocol]] = [:]
        let me = NIMSDK.shared().loginManager.currentAccount()
        for member in members {
            if member.memberId == me {
                continue
            }
            let groupTitle = member.groupTitle
            var groupedMembers = tmp[groupTitle]
            if groupedMembers == nil {
                groupedMembers = []
            }
            groupedMembers?.append(member)
            tmp[groupTitle] = groupedMembers
        }
        
        groupTitles.removeAllObjects()
        groups.removeAllObjects()
        
        for item in tmp where item.key.characters.count > 0 {
            let character = item.key[item.key.startIndex]
            if character >= "A" && character <= "Z" {
                groupTitles.add(item.key)
            } else {
                groupTitles.add("#")
            }
            groups.add(LPPair(first: item.key, second: item.value))
        }
        sort()
    }
    
    func addGroupMember(_ member: LPGroupMemberProtocol) {
        let groupTitle = member.groupTitle
        let groupIndex = groupTitles.index(of: groupTitle)
        
        var tmpPair: LPPair
        if groupIndex >= 0 && groupIndex < groups.count {
            if let pair = groups.object(at: groupIndex) as? LPPair {
                tmpPair = pair
            } else {
                tmpPair = LPPair(first: groupTitle, second: [])
            }
        } else {
            tmpPair = LPPair(first: groupTitle, second: [])
        }
        tmpPair.second.add(member)
        groupTitles.add(groupTitle)
        groups.add(tmpPair)
        sort()
    }
    
    func removeGroupMember(_ member: LPGroupMemberProtocol) {
        let groupTitle = member.groupTitle
        let groupIndex = groupTitles.index(of: groupTitle)
        if groupIndex >= 0 && groupIndex < groups.count {
            if let pair = groups.object(at: groupIndex) as? LPPair {
                pair.second.remove(member)
                
                if pair.second.count == 0 {
                    groups.remove(pair)
                }
                sort()
            }
        }
    }
    
    func addGroupAbove(withTitle title: String, members: [LPGroupMemberProtocol]) {
        let pair = LPPair(first: title, second: members)
        specialGroupTitles.add(title)
        specialGroups.add(pair)
    }
    
    func title(ofGroup index: Int) -> String? {
        var index = index
        if index >= 0 && index < specialGroupTitles.count {
            return specialGroupTitles.object(at: index) as? String
        }
        index -= specialGroupTitles.count
        if index >= 0 && index < groupTitles.count {
            return groupTitles.object(at: index) as? String
        }
        return nil
    }
    
    func members(ofGroup index: Int) -> [LPGroupMemberProtocol]? {
        var index = index
        if index >= 0 && index < specialGroups.count {
            if let pair = specialGroups.object(at: index) as? LPPair {
                return pair.second as? [LPGroupMemberProtocol]
            }
        }
        index -= specialGroups.count
        if index >= 0 && index < groups.count {
            if let pair = groups.object(at: index) as? LPPair {
                return pair.second as? [LPGroupMemberProtocol]
            }
        }
        return nil
    }

    func member(ofIndex indexPath: IndexPath) -> LPGroupMemberProtocol? {
        var members: NSArray?
        var groupIndex = indexPath.section
        if groupIndex >= 0 && groupIndex < specialGroups.count {
            if let pair = specialGroups.object(at: groupIndex) as? LPPair {
                members = pair.second
            }
        }
        groupIndex -= specialGroups.count
        if groupIndex >= 0 && groupIndex < groups.count {
            if let pair = groups.object(at: groupIndex) as? LPPair {
                members = pair.second
            }
        }
        let memberIndex = indexPath.row
        if let members = members {
            if memberIndex >= 0 && memberIndex < members.count {
                return members.object(at: memberIndex) as? LPGroupMemberProtocol
            }
        }
        return nil
    }
    
    func member(ofId uid: String) -> LPGroupMemberProtocol? {
        for pair in groups {
            if let pair = pair as? LPPair {
                for member in pair.second {
                    if let member = member as? LPGroupMemberProtocol, member.memberId == uid {
                        return member
                    }
                }
            }
        }
        return nil
    }
    
    func groupCount() -> Int {
        return specialGroupTitles.count + groupTitles.count
    }
    
    func memberCount(ofGroup index: Int) -> Int {
        var index = index
        var members: NSArray?
        if index >= 0 && index < specialGroups.count {
            if let pair = specialGroups.object(at: index) as? LPPair {
                members = pair.second
            }
        }
        index -= specialGroups.count
        if index >= 0 && index < groups.count {
            if let pair = groups.object(at: index) as? LPPair {
                members = pair.second
            }
        }
        return members?.count ?? 0
    }
    
    private func sort() {
        sortGroupTitle()
        sortGroupMember()
    }
    
    private func sortGroupTitle() {
        groupTitles.sortedArray(comparator: groupTitleComparator)
        groups.sortedArray(comparator: { (pair1, pair2) -> ComparisonResult in
            if let pair1 = pair1 as? LPPair, let pair2 = pair2 as? LPPair {
                return groupTitleComparator(pair1.first, pair2.first)
            }
            return .orderedAscending
        })
    }
    
    private func sortGroupMember() {
        groups.enumerateObjects({ (obj, idx, stop) in
            if let pair = obj as? LPPair {
                let groupedMembers = pair.second
                groupedMembers.sortedArray(comparator: { (member1, member2) -> ComparisonResult in
                    if let member1 = member1 as? LPGroupMemberProtocol, let member2 = member2 as? LPGroupMemberProtocol {
                        return groupMemberComparator(member1.sortKey, member2.sortKey)
                    }
                    return .orderedAscending
                })
            }
        })
    }
}
