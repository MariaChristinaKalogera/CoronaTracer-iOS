//
//  IntialViewController.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import UIKit

class IntialViewController: UIViewController {

    var bluetoothScanner: BluetoothScanner?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func enableBluetoothAction(_ sender: Any) {

        self.bluetoothScanner = BluetoothScanner { scanner in
            scanner.startScanning { (peripheral) in
                print("Discovered peripheral: \(peripheral.tableViewData)")
            }
        }
    }
}



