//
//  ContentView.swift
//  Bowling
//
//  Created by user on 2023/12/26.
//

import SwiftUI

struct ContentView: View {
    
    private let items = (0...10).map { $0 }
    
    @State private var selectedNumber = 0
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Picker("Select a number", selection: $selectedNumber) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                   }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Button {
                viewModel.pinfall.send(selectedNumber)
            } label: {
                Text("確定")
            }
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [
                        GridItem()
                    ]) {
                        ForEach(items, id: \.self) { index in
                            if index == 0 {
                                // 第一大格
                                Text("Item \(index)")
                                    .frame(width: 200, height: 200)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            } else if index < 10 {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        let turnsScoreArray = viewModel.turnsScoreArray
                                        let turnsScore = turnsScoreArray[index - 1]
                                        let turn = turnsScore[safe: 0] != .blank ? turnsScore[0].describsion : ""
                                        Text("\(turn)")
                                            .frame(width: 100, height: 100)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        
                                        let turn1 = turnsScore[safe: 1] != .blank ? turnsScore[1].describsion : ""
                                        Text("\(turn1)")
                                            .frame(width: 100, height: 100)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    let roundScore = viewModel.roundScoreArray[safe: index - 1] != nil ?  "\(viewModel.roundScoreArray[index - 1])" : ""
                                    Text("\(roundScore)")
                                        .frame(width: 200, height: 100)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            } else {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        let turnsScoreArray = viewModel.turnsScoreArray
                                        let turnsScore = turnsScoreArray[index - 1]
                                        let turn = turnsScore[safe: 0] != .blank ? turnsScore[0].describsion : ""
                                        Text("\(turn)")
                                            .frame(width: 100, height: 100)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        
                                        let turn1 = turnsScore[safe: 1] != .blank ? turnsScore[1].describsion : ""
                                        Text("\(turn1)")
                                            .frame(width: 100, height: 100)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        
                                        let turn2 = turnsScore[safe: 2] != .blank ? turnsScore[2].describsion : ""
                                        Text("\(turn2)")
                                            .frame(width: 100, height: 100)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    let roundScore = viewModel.roundScoreArray[safe: index - 1] != nil ?  "\(viewModel.roundScoreArray[index - 1])" : ""
                                    Text("\(roundScore)")
                                        .frame(width: 300, height: 100)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding()
                .onChange(of: viewModel.roundScoreArray) { newVelue in
                    withAnimation {
                        scrollViewProxy.scrollTo(newVelue.count, anchor: .leading)
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.gameEnd) {
            Alert(title: Text("Game over"), dismissButton: .default(Text("確定")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
