//
//  AgeData.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import Foundation

struct AgeData: Codable, Identifiable {
    var id = UUID() // 고유 식별자
    var timePoint: Int
    let youth: Int
    let twenties: Int
    let thirties: Int
    let forties: Int
    let thirty_forty: Int
    let fifties: Int
    let specialTicket: Int
    let foreigner: Int

    enum CodingKeys: String, CodingKey {
        case timePoint = "시간대"
        case youth = "청소년"
        case twenties = "20대"
        case thirties = "30대"
        case forties = "40대"
        case thirty_forty = "30/40대"
        case fifties = "50대"
        case specialTicket = "우대권"
        case foreigner = "외국인"
    }
}
