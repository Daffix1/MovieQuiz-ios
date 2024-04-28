//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Сергей Васильев on 24.03.2024.
//

import Foundation


final class StatisticServiceImplementation: StatisticService{
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        if count > self.bestGame.correct {
            self.bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        let correctStored = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correctStored + count, forKey: Keys.correct.rawValue)
        
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.setValue(total + amount, forKey: Keys.total.rawValue)
        
        userDefaults.setValue(self.gamesCount + 1, forKey: Keys.gamesCount.rawValue)
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get{
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get{
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double{
        let correctTotal = userDefaults.double(forKey: Keys.correct.rawValue)
        let count = userDefaults.double(forKey: Keys.total.rawValue)
        return (correctTotal / count) * 100
    }
    
    var gamesCount: Int {
        get{
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), // достаем из хранилища данные
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            // Здесь мы пытаемся раcкодировать данные из модели newValue в json
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.setValue(data, forKey: Keys.bestGame.rawValue)
        }
    }
}

// сериализация - из модели в json - JSONEncoder
// десериализация - из json в модель  - JSONDecoder
