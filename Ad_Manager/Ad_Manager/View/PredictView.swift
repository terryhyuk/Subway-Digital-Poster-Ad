//
//  PredictView.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import Charts
import SwiftUI

struct PredictView: View {
    @StateObject private var ml_Predict = ML_Predict()
    
    let options: [String] = ["강남", "잠실", "홍대"]
    let urlName: [String] = ["gangnam", "jamsil", "hongdae"]
    @State var selectedOptionIndex: Int = 0
    @State var selectedDate = Date()
    @State var selectedHour: Int = Calendar.current.component(.hour, from: Date())
    
    @State var pieDatas: [PieChartData] = []
    @State var sum: Double = 0
    
    var body: some View {
        ScrollView {
            ZStack(content: {
                VStack(content: {
                    Text("\(options[selectedOptionIndex])역 이용인원 예상 비율")
                        .font(.system(size: 22))
                        .bold()
                    
                    Text("시간대별 예상 인원")
                    
                    // 라인차트 위치
                    if !ml_Predict.ageData.isEmpty {
                        LineChartView(ageData: ml_Predict.ageData)
                            .frame(height: 200)
                            .padding()
                    } else {
                        ProgressView("데이터 로딩 중...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(height: 200)
                            .padding()
                    }
                    
                    ZStack {
                        // 파이차트 위치
                        if !pieDatas.isEmpty {
                            PieChartView(chartData: pieDatas, sum: Int(sum))
                                .frame(height: 250)
                                .padding()
                        } else {
                            ProgressView("데이터 로딩 중...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .frame(height: 300)
                                .padding()
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                
                                Picker("Hour", selection: $selectedHour) {
                                    ForEach(5..<25) { hour in
                                        let hourText = hour == 5 ? "5시이전"
                                        : hour == 24 ? "24시이후"
                                        : String(format: "%02d시", hour)
                                        
                                        let tagValue = hour == 24 ? 0 : hour // hour가 24일 때 0으로 설정
                                        Text(hourText).tag(tagValue)
                                    }
                                }
                                .disabled(
                                    pieDatas.isEmpty
                                )
                                .onChange(of: selectedHour) {
                                    Task {
                                        await chartDatas()
                                        await predictPercent()
                                    }
                                }
                                .pickerStyle(.wheel)
                                .labelsHidden()
                                .frame(width: 100, height: 100)
                                .clipped()
                            }
                            .padding(.trailing, 14)
                            
                            Spacer()
                        }
                    }
                    
                })
                .padding(.top, 70)
                .onAppear(perform: {
                    // LineChart
                    allChartData()
                    
                    // PieChart
                    Task {
                        await chartDatas()
                        await predictPercent()
                    }
                })
                VStack {
                    HStack(spacing: 40, content: {
                        // Station 선택
                        dropDownBtn(options: options, selectedOptionIndex: $selectedOptionIndex, menuWdith: 150, buttonHeight: 50, maxItemDisplayed: 5)
                            .onChange(of: selectedOptionIndex) {
                                allChartData()
                                Task {
                                    await chartDatas()
                                    await predictPercent()
                                }
                            }
                        
                        // 날짜 선택
                        DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: [.date])
                            .onChange(of: selectedDate) {
                                allChartData()
                                Task {
                                    await chartDatas()
                                    await predictPercent()
                                }
                            }
                            .labelsHidden()
                            .datePickerStyle(.compact)
                    })
                    
                    Spacer()
                }
            })
        }
    }
    
    func allChartData() {
        ml_Predict.ageData = []
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        
        ml_Predict.fetchAllData(name: urlName[selectedOptionIndex], year: year, month: month, day: day)
    }
    
    func chartDatas() async {
        pieDatas = []
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        
        await ml_Predict.fetchData(name: urlName[selectedOptionIndex], year: year, month: month, day: day, time: selectedHour)
    }
    
    func predictPercent() async {
        sum = 0
        for pieData in ml_Predict.chartData {
            sum += pieData.value
        }
        
        for pieData in ml_Predict.chartData {
            pieDatas.append(PieChartData(category: pieData.category, value: round((pieData.value / sum) * 1000) / 10))
        }
    }
}

struct dropDownBtn: View {
    let options: [String]
    // 연결될 변수
    @Binding var selectedOptionIndex: Int
    
    var menuWdith: CGFloat // 버튼의 가로 크기
    var buttonHeight: CGFloat // 버튼 높이
    var maxItemDisplayed: Int // 보이는 최대 갯수
    
    @State var showDropdown: Bool = false
    @State private var scrollPosition: Int?
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // selected item
                Button(action: {
                    withAnimation {
                        showDropdown.toggle()
                    }
                }, label: {
                    HStack(spacing: nil) {
                        Text(options[selectedOptionIndex])
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showDropdown ? -180 : 0))
                    }
                })
                .padding(.horizontal, 20)
                .frame(width: menuWdith, height: buttonHeight, alignment: .leading)
                if showDropdown {
                    let scrollViewHeight: CGFloat = options.count > maxItemDisplayed
                        ? (buttonHeight * CGFloat(maxItemDisplayed))
                        : (buttonHeight * CGFloat(options.count))
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(0..<options.count, id: \.self) { index in
                                Button(action: {
                                    withAnimation {
                                        selectedOptionIndex = index
                                        showDropdown.toggle()
                                    }
                                }, label: {
                                    HStack {
                                        Text(options[index])
                                        Spacer()
                                        if index == selectedOptionIndex {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                })
                                .padding(.horizontal, 20)
                                .frame(width: menuWdith, height: buttonHeight, alignment: .leading)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $scrollPosition)
                    .scrollDisabled(options.count <= 3)
                    .frame(height: scrollViewHeight)
                    .onAppear {
                        scrollPosition = selectedOptionIndex
                    }
                }
            }
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
        }
        .frame(width: menuWdith, height: buttonHeight, alignment: .top)
        .zIndex(100)
    }
}

// 파이 차트 뷰
struct PieChartView: View {
    @StateObject private var ml_Predict = ML_Predict()
    var chartData: [PieChartData]
    var sum: Int
    @State private var highlightedCategory: String?
    
    let ageColors: [String: Color] = [
        "20대": Color(0xB4D6FF),
        "30대": Color(0xFFB4B4),
        "30/40대": Color(0xFFB4B4),
        "40대": Color(0xFFFFB4),
        "50대": Color(0xB4FFF1),
        "외국인": Color(0xC0FFB4),
        "우대권": Color(0xD1B4FF),
        "청소년": Color(0x9BA5BD)
    ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(chartData.filter { $0.value != 0 }, id: \.category) { name in
                    SectorMark(
                        angle: .value("age", name.value),
                        innerRadius: .ratio(0.4),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Category", name.category))
                    .annotation(position: .overlay, alignment: .center) {
                        Text(String(format: "%.1f%%", name.value))
                            .font(.caption)
                    }
                    .opacity(highlightedCategory == nil || highlightedCategory == name.category ? 1 : 0.3)
                }
            }
            .chartForegroundStyleScale(domain: ageColors.keys.map { $0 }, range: ageColors.values.map { $0 })
            .chartBackground(alignment: .center, content: { _ in
                Text("총 예측인원\n\(sum)\n")
                    .multilineTextAlignment(.center)
            })
            .frame(height: 300)
//            .chartLegend(position: .bottom, alignment: .center, spacing: 16)
            .chartLegend(position: .bottom, alignment: .center) {
                HStack {
                    ForEach(ageColors.keys.sorted().filter { category in
                        chartData.first { $0.category == category }?.value != 0
                    }, id: \.self) { category in
                        Button(action: {
                            highlightCategory(category)
                        }) {
                            HStack {
                                Circle()
                                    .fill(ageColors[category] ?? .gray)
                                    .frame(width: 10, height: 10)
                                Text(category)
                                    .font(.system(size: 11))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func highlightCategory(_ category: String) {
        highlightedCategory = (highlightedCategory == category) ? nil : category
    }
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 08) & 0xFF) / 255,
            blue: Double((hex >> 00) & 0xFF) / 255,
            opacity: alpha
        )
    }
}

// AgeData 구조체에 나이대별 합계 확인 로직 추가
extension AgeData {
    func isNonZero(for category: String) -> Bool {
        switch category {
        case "청소년": return youth > 0
        case "20대": return twenties > 0
        case "30대": return thirties > 0
        case "40대": return forties > 0
        case "30/40대": return thirty_forty > 0
        case "50대": return fifties > 0
        case "우대권": return specialTicket > 0
        case "외국인": return foreigner > 0
        default: return false
        }
    }
}

// 라인 차트 뷰
struct LineChartView: View {
    @StateObject private var ml_Predict = ML_Predict()
    let ageData: [AgeData]

    var body: some View {
        Chart {
            ForEach(ageData) { data in
                if data.isNonZero(for: "청소년") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Youth", data.youth)
                    )
                    .foregroundStyle(by: .value("Age", "청소년"))
                }

                if data.isNonZero(for: "20대") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Twenties", data.twenties)
                    )
                    .foregroundStyle(by: .value("Age", "20대"))
                }

                if data.isNonZero(for: "30대") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Thirties", data.thirties)
                    )
                    .foregroundStyle(by: .value("Age", "30대"))
                }

                if data.isNonZero(for: "40대") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Forties", data.forties)
                    )
                    .foregroundStyle(by: .value("Age", "40대"))
                }

                if data.isNonZero(for: "30/40대") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("30/40대", data.thirty_forty)
                    )
                    .foregroundStyle(by: .value("Age", "30/40대"))
                }

                if data.isNonZero(for: "50대") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Fifties", data.fifties)
                    )
                    .foregroundStyle(by: .value("Age", "50대"))
                }

                if data.isNonZero(for: "우대권") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Special Ticket", data.specialTicket)
                    )
                    .foregroundStyle(by: .value("Age", "우대권"))
                }

                if data.isNonZero(for: "외국인") {
                    LineMark(
                        x: .value("Time", data.timePoint),
                        y: .value("Foreigner", data.foreigner)
                    )
                    .foregroundStyle(by: .value("Age", "외국인"))
                }
            }
        }
        .chartXScale(domain: 4 ... 25) // X축 최소값을 5로 설정
        .padding()
    }
}

#Preview {
    PredictView()
}
