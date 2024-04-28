//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Сергей on 06.03.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
