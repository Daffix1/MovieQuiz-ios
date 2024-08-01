//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Сергей on 06.03.2024.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
