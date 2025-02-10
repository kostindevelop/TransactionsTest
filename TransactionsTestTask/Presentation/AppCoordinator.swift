//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 05.02.2025.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private var transactionsListCoordinator: TransactionsListCoordinator?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        transactionsListCoordinator = TransactionsListCoordinator(navigationController: navigationController)
        transactionsListCoordinator?.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
