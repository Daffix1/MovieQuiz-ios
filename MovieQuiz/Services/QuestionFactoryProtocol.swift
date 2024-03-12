//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Сергей on 06.03.2024.
//

import Foundation

protocol QuestionFactoryProtocol{
    var delegate: QuestionFactoryDelegate? {get set}
    func requestNextQuestion()
}
