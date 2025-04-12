//
//  PieChartData.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import Foundation

struct PieChartData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}
