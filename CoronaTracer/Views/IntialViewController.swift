//
//  IntialViewController.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import UIKit

class IntialViewController: UIViewController {

    var bluetoothScannerService: BluetoothScannerService?
    var peripheralCoreDataStorage = PeripheralCoreDataStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func enableBluetoothAction(_ sender: Any) {

        self.bluetoothScannerService = BluetoothScannerService { [weak self] scanner in
            scanner.startScanning { peripheral in
                self?.peripheralCoreDataStorage.saveRecentQuery(peripheral: peripheral, completion: { result in
                    if case let .success(peripheral) = result {
                        print("Discovered peripheral: \(peripheral.represntableData)")
                    }
                })
            }
        }
    }
}



