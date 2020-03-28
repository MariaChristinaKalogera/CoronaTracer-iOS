//
//  AppFlowCoordiantor.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import UIKit

class AppFlowCoordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        if BluetoothScannerService.shared.isScanning {
            showLoginScreen()
        } else {
            showInitialScreen()
        }
    }

    private func showInitialScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IntialViewController") as! IntialViewController
        vc.didStartBluetooth = showLoginScreen
        navigationController.setViewControllers([vc], animated: false)

    }

    private func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController.setViewControllers([vc], animated: true)
    }
}
