//
//  PredictView.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/27/24.
//

import SwiftUI
import Charts

struct PredictView: View {
    @StateObject private var ml_Predict = ML_Predict()
    
    let options: [String] = ["강남", "잠실", "홍대"]
    let urlName: [String] = ["gangnam", "jamsil", "hongdae"]
    @State var selectedOptionIndex: Int = 0
    @State var selectedDate = Date()
    @State var selectedHour : Int = Calendar.current.component(.hour, from: Date())
        
    var body: some View {
        VStack(content: {
            HStack(spacing: 40, content: {
                dropDownBtn(options: options, selectedOptionIndex: $selectedOptionIndex, menuWdith: 150, buttonHeight: 50, maxItemDisplayed: 5)
                DatePicker("", selection: $selectedDate, in: Date()...,  displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .onAppear(perform: {
                        ml_Predict.fetchAllData(name: urlName[selectedOptionIndex], year: 2024, month: 12, day: 27)
                    })
            })
            
            if !ml_Predict.ageData.isEmpty{
                Text("10대: \(ml_Predict.ageData[0].teen)")
//                Text("20대: \(ml_Predict.ageData[0].twenties)")
//                Text("30대: \(ml_Predict.ageData[0].thirties)")
//                Text("40대: \(ml_Predict.ageData[0].forties)")
//                Text("50대 이상: \(ml_Predict.ageData[0].fiftiesOrMore)")
//                Text("우대권: \(ml_Predict.ageData[0].specialTicket)")
                Text("외국인: \(ml_Predict.ageData[0].foreigner)")
            }
            
            
            Text("\(options[selectedOptionIndex])역 이용인원 예상 비율")
            
            Text("시간대별 예상 인원")
            
            Picker("Hour", selection: $selectedHour) {
                        ForEach(5..<25) { hour in
                            let hourText = hour == 5 ? "5시이전"
                                : hour == 24 ? "24시이후"
                                : String(format: "%02d시", hour)
                            
                            let tagValue = hour == 24 ? 0 : hour // hour가 24일 때 0으로 설정
                            Text(hourText).tag(tagValue)
                        }

                    }
            .onAppear(perform: {
                ml_Predict.fetchData(name: urlName[selectedOptionIndex], year: 2024, month: 12, day: 27, time: selectedHour)
            })
            .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width: 100, height: 100)
                    .clipped()
            
            if !ml_Predict.chartData.isEmpty{
                Text(ml_Predict.chartData[3].category)
                Text(String(ml_Predict.chartData[0].value))
            }
        })
    }
    
    func allChartData(){
        
    }
}


struct dropDownBtn:View {
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

#Preview {
    PredictView()
}
