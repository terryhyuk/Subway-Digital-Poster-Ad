//
//  AgeData.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import Foundation

struct AgeData: Codable {
    let teen: Int
    let twenties: Int
    let thirties: Int
    let forties: Int
    let fiftiesOrMore: Int
    let specialTicket: Int
    let foreigner: Int
    
    enum CodingKeys: String, CodingKey {
        case teen = "10대"
        case twenties = "20대"
        case thirties = "30대"
        case forties = "40대"
        case fiftiesOrMore = "50대 이상"
        case specialTicket = "우대권"
        case foreigner = "외국인"
    }
}
