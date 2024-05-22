//
//  BowlingTests.swift
//  BowlingTests
//
//  Created by user on 2023/12/26.
//

import XCTest
@testable import Bowling

final class BowlingTests: XCTestCase {

    var viewModel: ViewModel!
    
    override func setUpWithError() throws {
        viewModel = ViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    /// 設定初始 turnScore
    func testSetRoundScore() {
        viewModel.setTurnScores()
        let turnsScoreArray = viewModel.turnsScoreArray
        XCTAssertEqual(turnsScoreArray, [[ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank], [ScoreType.blank, ScoreType.blank, ScoreType.blank]])
    }
    
    // MARK: - addCurrent
    func testAddCurrent0() {
        viewModel.addCurrent(score: 0)
        let score = viewModel.turnCurrentScore.value
        XCTAssertEqual(score, 0)
    }
    
    func testAddCurrent1() {
        viewModel.addCurrent(score: 1)
        let score = viewModel.turnCurrentScore.value
        XCTAssertEqual(score, 1)
    }

    func testAddCurrent9() {
        viewModel.addCurrent(score: 9)
        let score = viewModel.turnCurrentScore.value
        XCTAssertEqual(score, 9)
    }

    func testAddCurrent10() {
        viewModel.addCurrent(score: 10)
        let score = viewModel.turnCurrentScore.value
        XCTAssertEqual(score, 10)
    }

    // MARK: - convertToType
    func testConvertScore0() {
        viewModel.addCurrent(score: 0)
        let type = viewModel.convertToType(score: 0)
        XCTAssertEqual(type, .zero)
    }

    func testConvertScore9() {
        viewModel.addCurrent(score: 9)
        let type = viewModel.convertToType(score: 9)
        XCTAssertEqual(type, .int(pinfall: 9))
    }

    func testConvertStrike() {
        viewModel.addCurrent(score: 10)
        let type = viewModel.convertToType(score: 10)
        XCTAssertEqual(type, .strike)
    }
    
    func testConvertSpare() {
        viewModel.addCurrent(score: 8)
        var type = viewModel.convertToType(score: 8)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        XCTAssertEqual(type, .spare(pinfall: 2))
    }
    
    // MARK: - addScoreToTurn
    func testAddScoreToTurn() {
        viewModel.addCurrent(score: 0)
        let type = viewModel.convertToType(score: 0)
        viewModel.addScoreToTurn(type: type)
        let round = viewModel.round.value
        let turnsScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(turnsScore, [.zero, .blank])
    }
    
    func testAddScoreToTurn9() {
        viewModel.addCurrent(score: 9)
        let type = viewModel.convertToType(score: 9)
        viewModel.addScoreToTurn(type: type)
        let round = viewModel.round.value
        let turnsScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(turnsScore, [.int(pinfall: 9), .blank])
    }
    
    func testAddScoreToTurn10() {
        viewModel.addCurrent(score: 10)
        let type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        let round = viewModel.round.value
        let turnsScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(turnsScore, [.strike, .blank])
    }
    
    // MARK: - checkRoundEnd
    
    func testTurnEnd0() {
        viewModel.addCurrent(score: 0)
        let type = viewModel.convertToType(score: 0)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, false)
    }
    
    func testTurnEnd9() {
        viewModel.addCurrent(score: 9)
        let type = viewModel.convertToType(score: 9)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, false)
    }

    func testTurnEnd10() {
        viewModel.addCurrent(score: 10)
        let type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, true)
    }
    
    // MARK: - testTurn2
    func testAddScoreToTurn1() {
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 8)
        type = viewModel.convertToType(score: 8)
        viewModel.addScoreToTurn(type: type)
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.spare(pinfall: 8)])
    }
    
    func testAddScoreToTurn3() {
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 7)
        type = viewModel.convertToType(score: 7)
        viewModel.addScoreToTurn(type: type)
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.int(pinfall: 7)])
    }
    
    func testAddScoreToTurn31() {
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 7)
        type = viewModel.convertToType(score: 7)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.int(pinfall: 7)])
    }
    
    func testAddScoreToTurn32() {
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 8)
        type = viewModel.convertToType(score: 8)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 7)
        type = viewModel.convertToType(score: 7)
        viewModel.addScoreToTurn(type: type)

        let turnsScoreArray = viewModel.turnsScoreArray
        XCTAssertEqual(turnsScoreArray[0], [ScoreType.int(pinfall: 2), ScoreType.spare(pinfall: 8)])
        XCTAssertEqual(turnsScoreArray[1], [ScoreType.int(pinfall: 7), ScoreType.blank])
    }
    
    func testAddScoreToRound4() {
        (1...8).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 7)
        type = viewModel.convertToType(score: 7)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.int(pinfall: 7)])
    }
    
    // MARK: - testTurn10
    func testAddScoreToRound5() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 7)
        type = viewModel.convertToType(score: 7)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.int(pinfall: 7), ScoreType.blank])
    }
    
    // x 7 /
    func testAddScoreToRound6() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 7)
        type = viewModel.convertToType(score: 7)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 3)
        type = viewModel.convertToType(score: 3)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.strike, ScoreType.int(pinfall: 7), ScoreType.spare(pinfall: 3)])
    }
    
    // 2 / x
    func testAddScoreToRound7() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 8)
        type = viewModel.convertToType(score: 8)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 10)
        type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.spare(pinfall: 8), ScoreType.strike])
    }
    
    // 2 / 1
    func testAddScoreToRound8() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 2)
        var type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 8)
        type = viewModel.convertToType(score: 8)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 1)
        type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.int(pinfall: 2), ScoreType.spare(pinfall: 8), ScoreType.int(pinfall: 1)])
    }
    
    // X X 1
    func testAddScoreToRound29() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 10)
        type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 1)
        type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.strike, ScoreType.strike, ScoreType.int(pinfall: 1)])
    }
    
    // X X X
    func testAddScoreToRound11() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 10)
        type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 10)
        type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.strike, ScoreType.strike, ScoreType.strike])
    }
    
    // X 2 1
    func testAddScoreToRound12() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        viewModel.nextTurn()
        
        viewModel.addCurrent(score: 1)
        type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        
        let round = viewModel.round.value
        let roundScore = viewModel.turnsScoreArray[round]
        XCTAssertEqual(roundScore, [ScoreType.strike, ScoreType.int(pinfall: 2), ScoreType.int(pinfall: 1)])
    }
    
    // MARK: - nextTurn
    func testCheckTurn() {
        viewModel.nextTurn()
        XCTAssertEqual(1, viewModel.turn.value)
    }
    
    func testCheckTurn2() {
        viewModel.nextTurn()
        viewModel.nextTurn()
        XCTAssertEqual(2, viewModel.turn.value)
    }
    
    // MARK: - nextRound
    func testNextRound() {
        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.value, 1)
        XCTAssertEqual(viewModel.turn.value, 0)
        XCTAssertEqual(viewModel.turnCurrentScore.value, 0)
    }
    
    func testNextRound1() {
        viewModel.nextTurn()
        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.value, 1)
        XCTAssertEqual(viewModel.turn.value, 0)
        XCTAssertEqual(viewModel.turnCurrentScore.value, 0)
    }
    
    func testNextRound2() {
        viewModel.nextRound()
        viewModel.nextRound()
        XCTAssertEqual(viewModel.round.value, 2)
        XCTAssertEqual(viewModel.turn.value, 0)
        XCTAssertEqual(viewModel.turnCurrentScore.value, 0)
    }
    
    // MARK: - testRound10isEnd
    func testLastRoundStrike() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        viewModel.addCurrent(score: 10)
        let type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, false)
    }
    
    func testLastRound6() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        viewModel.addCurrent(score: 6)
        let type = viewModel.convertToType(score: 6)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, false)
    }
    
    func testLastRoundSpare() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        viewModel.addCurrent(score: 6)
        var type = viewModel.convertToType(score: 6)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
    
        viewModel.addCurrent(score: 4)
        type = viewModel.convertToType(score: 4)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, false)
    }
    
    func testLastRoundSpare1() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        viewModel.addCurrent(score: 6)
        var type = viewModel.convertToType(score: 6)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 3)
        type = viewModel.convertToType(score: 3)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, true)
    }
    
    func testLastRoundStrike1() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, false)
    }
    
    func testLastRoundTurn() {
        (1...9).forEach { _ in
            viewModel.nextRound()
        }
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        isEnd = viewModel.checkRoundEnd()
        XCTAssertEqual(isEnd, true)
    }
    
    // TODO: - testCountStrikeOrSpare
    
    // MARK: - testRoundScoreArray
    func testRoundScore() {
        viewModel.addCurrent(score: 1)
        let type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [])
    }
    
    func testRoundScore1() {
        viewModel.addCurrent(score: 1)
        var type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [3])
    }
    
    func testRoundScore2() {
        viewModel.addCurrent(score: 1)
        var type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 9)
        type = viewModel.convertToType(score: 9)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [])
    }
    
    func testRoundScore3() {
        viewModel.addCurrent(score: 10)
        let type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        let isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [])
    }
    
    func testRoundScore4() {
        viewModel.addCurrent(score: 1)
        var type = viewModel.convertToType(score: 1)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 9)
        type = viewModel.convertToType(score: 9)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 9)
        type = viewModel.convertToType(score: 9)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [19])
    }
    
    func testRoundScore5() {
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [])
    }
    
    func testRoundScore6() {
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 3)
        type = viewModel.convertToType(score: 3)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [15, 20])
    }
    
    func testLastRound() {
        (1...8).forEach { _ in
            viewModel.nextRound()
        }
        
        viewModel.addCurrent(score: 10)
        var type = viewModel.convertToType(score: 10)
        viewModel.addScoreToTurn(type: type)
        var isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 2)
        type = viewModel.convertToType(score: 2)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        viewModel.addCurrent(score: 3)
        type = viewModel.convertToType(score: 3)
        viewModel.addScoreToTurn(type: type)
        isEnd = viewModel.checkRoundEnd()
        viewModel.countStrikeOrSpare()
        viewModel.countRoundScore(isEnd: isEnd)
        isEnd ? viewModel.nextRound() : viewModel.nextTurn()
        
        let roundScoreArray = viewModel.roundScoreArray
        let round9 = roundScoreArray[0]
        let round10 = roundScoreArray[1]
        XCTAssertEqual(round9, 15)
        XCTAssertEqual(round10, 20)
    }
    
    // MARK: - testPinfall
    func testPinfall() {
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2)
        let roundScoreArray = viewModel.roundScoreArray
        let round = roundScoreArray[0]
        XCTAssertEqual(round, 4)
    }
    
    func testPinfall11() {
        viewModel.pinfall.send(0)
        viewModel.pinfall.send(0)
        let roundScoreArray = viewModel.roundScoreArray
        let roundScore = roundScoreArray[0]
        XCTAssertEqual(roundScore, 0)
    }
    
    func testPinfall12() {
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        let roundScoreArray = viewModel.roundScoreArray
        let roundScore = roundScoreArray[safe: 0]
        XCTAssertEqual(roundScore, nil)
    }
    
    func testPinfall13() {
        viewModel.pinfall.send(10)
        let roundScoreArray = viewModel.roundScoreArray
        let roundScore = roundScoreArray[safe: 0]
        XCTAssertEqual(roundScore, nil)
    }
    
    func testPinfall14() {
        viewModel.pinfall.send(10)
        viewModel.pinfall.send(1)
        let roundScoreArray = viewModel.roundScoreArray
        let roundScore = roundScoreArray[safe: 0]
        XCTAssertEqual(roundScore, nil)
    }
    
    func testPinfall15() {
        viewModel.pinfall.send(10)
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(2)
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [13, 16])
    }
    
    func testPinfall16() {
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(2)
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [12])
    }
    
    func testPinfall17() {
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2)
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [12, 16])
    }
    
    func testPinfall18() {
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(10)
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [20])
    }
    
    func testPinfall1() {
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(10)
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [4, 34])
    }
    
    func testPinfall2() {
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2) // 4
        
        viewModel.pinfall.send(10) // 30
        
        viewModel.pinfall.send(10) // 25
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(5)
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [4, 34, 59])
    }
    
    func testPinfall3() {
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2) // 4
        
        viewModel.pinfall.send(10) // 30
        
        viewModel.pinfall.send(10) // 25
        
        viewModel.pinfall.send(10) // 20
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5)
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [4, 34, 59, 79])
    }
    
    func testPinfall4() {
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2) // 4
        
        viewModel.pinfall.send(10) // 30 34
        
        viewModel.pinfall.send(10) // 25 59
        
        viewModel.pinfall.send(10) // 20 79
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5) // 20 99
        
        viewModel.pinfall.send(10) //20 119
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5) // 15 134
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5) // 20 154
        
        viewModel.pinfall.send(10) // 16
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [4, 34, 59, 79, 99, 119, 134, 154])
    }
    
    func testPinfall5() {
        viewModel.pinfall.send(2)
        viewModel.pinfall.send(2) // 4
        
        viewModel.pinfall.send(10) // 30 34
        
        viewModel.pinfall.send(10) // 25 59
        
        viewModel.pinfall.send(10) // 20 79
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5) // 20 99
        
        viewModel.pinfall.send(10) //20 119
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5) // 15 134
        
        viewModel.pinfall.send(5)
        viewModel.pinfall.send(5) // 20 154
        
        viewModel.pinfall.send(10) // 19 173

        viewModel.pinfall.send(6)
        viewModel.pinfall.send(3) // 182
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [4, 34, 59, 79, 99, 119, 134, 154, 173, 182])
    }
    
    func testPinfall6() {
        viewModel.pinfall.send(6)
        viewModel.pinfall.send(4) // 20
        
        viewModel.pinfall.send(10) // 31
        
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(0)// 32
        
        viewModel.pinfall.send(10) // 52
        
        viewModel.pinfall.send(10) // 70
        
        viewModel.pinfall.send(0)
        viewModel.pinfall.send(8) // 78
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1) // 91
        
        viewModel.pinfall.send(3)
        viewModel.pinfall.send(5) // 99
        
        viewModel.pinfall.send(4)
        viewModel.pinfall.send(0) // 103
        
        viewModel.pinfall.send(10) // 123
        viewModel.pinfall.send(3)
        viewModel.pinfall.send(7)
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [20, 31, 32, 52, 70, 78, 91, 99, 103, 123])
    }
    
    func testPinfall7() {
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(7)
        viewModel.pinfall.send(3)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(9)
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [20, 37, 56, 75, 95, 125, 154, 174, 193, 212])
    }
    
    func testPinfall8() {
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(7)
        viewModel.pinfall.send(3)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(10)
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1) 
        
        viewModel.pinfall.send(9)
        viewModel.pinfall.send(1)
        viewModel.pinfall.send(10)
        
        let roundScoreArray = viewModel.roundScoreArray
        XCTAssertEqual(roundScoreArray, [20, 37, 56, 75, 95, 125, 154, 174, 193, 213])
    }
    
    // TODO: - testGameEnd

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
