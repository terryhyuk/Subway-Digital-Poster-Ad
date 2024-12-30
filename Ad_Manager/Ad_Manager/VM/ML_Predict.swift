//
//  ML_Predict.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import Combine
import Foundation

class ML_Predict: ObservableObject {
    @Published var ageData: [AgeData] = []
    private var cancellables = Set<AnyCancellable>()
    
    @Published var chartData: [PieChartData] = []
    
    func fetchAllData(name: String, year: Int, month: Int, day: Int) {
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
//                print("Received data: \(data)")
                self?.ageData = data
            })
            .store(in: &cancellables)
    }
    
//    func fetchData(name:String, year:Int, month:Int, day:Int, time:Int) {
//        guard let url = URL(string: "http://127.0.0.1:8000/ml/\(name)?year=\(year)&month=\(month)&day=\(day)&time=\(time)") else { return }
//
//            URLSession.shared.dataTaskPublisher(for: url)
//                .map { $0.data }
//                .decode(type: [[String: Double]].self, decoder: JSONDecoder())
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print("Error fetching data: \(error.localizedDescription)")
//                    }
//                }, receiveValue: { [weak self] data in
//                    self?.processData(data)
//                })
//                .store(in: &cancellables)
//    }
    
    func fetchData(name: String, year: Int, month: Int, day: Int, time: Int) async {
        guard let url = URL(string: "http://127.0.0.1:8000/ml/\(name)?year=\(year)&month=\(month)&day=\(day)&time=\(time)") else {
            print("Invalid URL")
            return
        }
        
        do {
            // URLSession의 data(for:)를 사용해 데이터 요청
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            // JSON 데이터를 디코딩
            let decodedData = try JSONDecoder().decode([[String: Double]].self, from: data)
            
            // 데이터를 처리하는 함수 호출
            await MainActor.run {
                processData(decodedData)
            }
        } catch {
            // 에러 처리
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
        
    private func processData(_ data: [[String: Double]]) {
        guard let firstEntry = data.first else { return }
        // 키를 기준으로 정렬
        let sortedEntries = firstEntry.sorted { $0.key < $1.key }
        chartData = sortedEntries.map { PieChartData(category: $0.key, value: $0.value) }
    }
}
