//
//  ViewModel.swift
//  Bowling
//
//  Created by user on 2023/12/26.
//

import Foundation
import Combine

enum ScoreType {
    case int(pinfall: Int)
    case strike
    case spare(pinfall: Int = 0)
    case zero
    case blank
    
    var describsion: String {
        switch self {
        case .int(let pinfall):
            return "\(pinfall)"
        case .strike:
            return "X"
        case .spare:
            return "/"
        case .zero:
            return "-"
        case .blank:
            return ""
        }
    }
    
    var score: Int {
        switch self {
        case .int(let pinfall):
            return pinfall
        case .strike:
            return 10
        case .spare:
            return 10
        case .zero:
            return 0
        case .blank:
            return -1
        }
    }
}

extension ScoreType: Equatable {
    static func == (lhs: ScoreType, rhs: ScoreType) -> Bool {
        switch (lhs, rhs) {
        case let (.int(pinfall1), .int(pinfall2)):
            return pinfall1 == pinfall2
        case (.strike, .strike), (.spare, .spare), (.zero, .zero), (.blank, .blank):
            return true
        default:
            return false
        }
    }
}

class ViewModel: ObservableObject {
    // input
    let pinfall = PassthroughSubject<Int, Never>() // PublishSubject
    
    // output
    @Published var turnsScoreArray: [[ScoreType]] = []
    @Published var roundScoreArray: [Int] = []
    @Published var gameEnd = false
    
    let round = CurrentValueSubject<Int, Never>(0) // BehaviorRelay
    let turn = CurrentValueSubject<Int, Never>(0)
    let turnCurrentScore = CurrentValueSubject<Int, Never>(0)
    /// 第10局才會用到
    let lastType = CurrentValueSubject<ScoreType, Never>(.blank)
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setTurnScores()
        binding()
    }
    
    public func setTurnScores(round: Int = 10) {
        var array = Array(repeating: [ScoreType.blank, ScoreType.blank], count: round - 1)
        array.append([ScoreType.blank, ScoreType.blank, ScoreType.blank])
        self.turnsScoreArray = array
    }
    
    private func binding() {
        pinfall
            .sink { [weak self] pinfall in
                guard let self = self else { return }
                self.addCurrent(score: pinfall)
                let type = self.convertToType(score: pinfall)
                self.addScoreToTurn(type: type)
                let isEnd = self.checkRoundEnd()
                self.countStrikeOrSpare()
                self.countRoundScore(isEnd: isEnd)
                let gameEnd = self.checkGameEnd(isEnd: isEnd)
                if gameEnd {
                    self.gameEnd = true
                } else {
                    isEnd ? self.nextRound() : self.nextTurn()
                }
            }
            .store(in: &cancellables)
    }
    
    /// 加上目前分數
    func addCurrent(score: Int) {
        let turnScore = self.turnCurrentScore.value
        self.turnCurrentScore.send(turnScore + score)
    }
    
    /// 轉換成分數 type
    func convertToType(score: Int) -> ScoreType {
        let turn = self.turn.value
        let turnScore = self.turnCurrentScore.value
        let round = self.round.value
        let lastType = self.lastType.value
        if score == 0 {
            self.lastType.send(.blank)
            return .zero
        } else if turn == 0 {
            score == 10 ? self.lastType.send(.strike) : self.lastType.send(.blank)
            return score == 10 ? .strike : .int(pinfall: score)
        } else if round == 9, turn == 1, lastType == .strike {
            score == 10 ? self.lastType.send(.strike) : self.lastType.send(.blank)
            return score == 10 ? .strike : .int(pinfall: score)
        } else if round == 9, turn == 2, lastType == .strike || lastType == .spare() {
            return score == 10 ? .strike : .int(pinfall: score)
        } else {
            turnScore == 10 ? self.lastType.send(.spare()) : self.lastType.send(.blank)
            return turnScore == 10 ? .spare(pinfall: score) : .int(pinfall: score)
        }
    }
    
    /// 加入到 turnsScoreArray
    func addScoreToTurn(type: ScoreType) {
        var turnsScoreArray = self.turnsScoreArray
        turnsScoreArray[self.round.value][self.turn.value] = type
        self.turnsScoreArray = turnsScoreArray
    }
    
    /// 檢查回合結束
    func checkRoundEnd() -> Bool {
        let score = turnCurrentScore.value
        if turn.value == 2 {
            return true
        } else if round.value != 9, score == 10 {
            return true
        } else if round.value == 9 {
            guard let roundScore = self.turnsScoreArray.last,
                  turn.value != 0
            else { return false }
            return !(roundScore.contains(.strike) || roundScore.contains(.spare()))
        } else if turn.value == 1 {
            return true
        } else {
            return false
        }
    }
    
    /// 計算之前的 strick or spare
    func countStrikeOrSpare() {
        var turnScoresArray = self.turnsScoreArray
        var roundScoreArray = self.roundScoreArray
        let turnCurrentScore = self.turnCurrentScore.value
        var lastScore = roundScoreArray.last ?? 0
        
        turnScoresArray = turnScoresArray.map { typeArray in
            return typeArray.filter { element in
                return element != .blank
            }
        }
        
        let flatArray = turnScoresArray.flatMap { $0 }
        let flatArrayCount = flatArray.count
        if let lastType = flatArray[safe: flatArrayCount - 2], case .spare = lastType,
           self.turn.value != 2 {
            lastScore = lastScore + 10 + turnCurrentScore
            roundScoreArray.append(lastScore)
            self.roundScoreArray = roundScoreArray
        }
        
        if let lastType = flatArray[safe: flatArrayCount - 3], lastType == .strike,
           self.turn.value != 2 {
            var score = 0
            let lastType = flatArray[flatArrayCount - 1]
            switch lastType {
            case .spare(_):
                score = 10
            default:
                score = flatArray[flatArrayCount - 2].score + flatArray[flatArrayCount - 1].score
            }
            lastScore = lastScore + 10 + score
            roundScoreArray.append(lastScore)
            self.roundScoreArray = roundScoreArray
        }
    }
    
    /// 計算當回合分數
    func countRoundScore(isEnd: Bool) {
        
        var turnScoresArray = self.turnsScoreArray
        var roundScoreArray = self.roundScoreArray
        let round = self.round.value
        let turnCurrentScore = self.turnCurrentScore.value
        var lastScore = roundScoreArray.last ?? 0
        
        turnScoresArray = turnScoresArray.map { typeArray in
            return typeArray.filter { element in
                return element != .blank
            }
        }
        
        if isEnd, round == 9, let lastArray = turnScoresArray[safe: 9] {
            let newScore = lastArray.reduce(0) { partialResult, type in
                switch type {
                case .spare(let pinfall):
                    return partialResult + pinfall
                default:
                    return partialResult + type.score
                }
            }
            lastScore += newScore
            roundScoreArray.append(lastScore)
            self.roundScoreArray = roundScoreArray
        } else if isEnd, turnCurrentScore != 10 {
            lastScore += turnCurrentScore
            roundScoreArray.append(lastScore)
            self.roundScoreArray = roundScoreArray
        }
    }
    
    /// 檢查遊戲是否結束
    func checkGameEnd(isEnd: Bool) -> Bool {
        guard self.round.value == 9, isEnd else { return false }
        return true
    }
    
    /// 同局下一球
    func nextTurn() {
        self.turn.send(turn.value + 1)
        guard self.turnCurrentScore.value == 10 else {
            return
        }
        self.turnCurrentScore.send(0)
    }
    
    /// 下一局
    func nextRound() {
        self.round.send(round.value + 1)
        self.turn.send(0)
        self.turnCurrentScore.send(0)
    }
}
