//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Сергей on 06.03.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
