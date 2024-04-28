//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Сергей on 07.03.2024.
//

import UIKit


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
