//
//  RowView.swift
//  Bowling
//
//  Created by user on 2024/1/24.
//

import Foundation

struct RowView: View {
    let turnsScore: [ScoreType]
    let roundScore: Int?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(turnsScore.indices, id: \.self) { i in
                let score = turnsScore[safe: i] != .blank ? turnsScore[i].describsion : ""
                ScoreView(text: score)
                    .padding()
            }

            let roundScoreText = roundScore != nil ? "\(roundScore!)" : ""
            ScoreView(text: roundScoreText, width: 200)
                .padding()
        }
    }
}

struct ScoreView: View {
    let text: String
    let width: CGFloat

    init(text: String, width: CGFloat = 100) {
        self.text = text
        self.width = width
    }

    var body: some View {
        Text(text)
            .frame(width: width, height: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
