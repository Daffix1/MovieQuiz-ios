//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Сергей on 07.03.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: UIViewController?
    
    init(viewController: UIViewController?) {
        self.delegate = viewController
    }
    
    func showResult(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
        
        alert.addAction(action)
        guard let viewController = delegate else { return }
        viewController.present(alert, animated: true, completion: nil)
        alert.view.accessibilityIdentifier = "Game results"
    }
}





