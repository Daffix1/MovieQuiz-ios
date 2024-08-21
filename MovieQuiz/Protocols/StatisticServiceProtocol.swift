//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Сергей Васильев on 05.04.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
