//
//  ML_Predict.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import Foundation
import Combine

class ML_Predict: ObservableObject {
    @Published var ageData: [AgeData] = []
    private var cancellables = Set<AnyCancellable>()
    
    @Published var chartData: [PieChartData] = []
    
    func fetchAllData(name:String, year:Int, month:Int, day:Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/ml/\(name)_all_time?year=\(year)&month=\(month)&day=\(day)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [AgeData].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] data in
                self?.ageData = data
            })
            .store(in: &cancellables)
    }
    
    func fetchData(name:String, year:Int, month:Int, day:Int, time:Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/ml/\(name)?year=\(year)&month=\(month)&day=\(day)&time=\(time)") else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [[String: Double]].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] data in
                    self?.processData(data)
                })
                .store(in: &cancellables)
        }
        
    private func processData(_ data: [[String: Double]]) {
        guard let firstEntry = data.first else { return }
        self.chartData = firstEntry.map { PieChartData(category: $0.key, value: $0.value) }
    }
}
