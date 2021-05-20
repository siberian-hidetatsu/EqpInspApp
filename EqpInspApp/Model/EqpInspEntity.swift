//
//  Entity.swift
//  EqpInspApp
//
//  Created by Hidetatsu Miyamoto on 2021/04/09.
//

import Foundation

struct EqpInsp: Codable {
    struct EqpInspSubExpItem:Codable {
        var ExpSeqNum:String
        var ItemLabel:String
        var BefValue:String
        var AftValue:String
    }
    
    struct EqpInspSubItem: Codable {
        var SeqNum:String
        var SubItemName:String
        var SubItemImg:String
        var JudgementCriteria:String
        var InspectionPoint:String
        var BefTitle:String
        var AftTitle:String
        var BefResult:String
        var AftResult:String
        var EqpInspSubExpItems:[EqpInspSubExpItem]
    }
    
    struct EqpInspItem: Codable {
        //var EqpType:String  /* 旧フォーマット */
        var ItemCode:String
        var ItemName:String
        var EqpInspSubItems:[EqpInspSubItem]
    }
    
    struct EquipInspec: Codable {
        var EqpType:String
        var InspectionName:String
        var Result:String
        var EqpInspItems:[EqpInspItem]
    }
    
    struct EqpTypeId: Codable {
        var EqpType:String
        var EqpId:String
    }
}
