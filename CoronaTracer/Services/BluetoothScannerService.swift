//
//  BluetoothScannerService.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import CoreBluetooth

open class BluetoothScannerService: NSObject, CBCentralManagerDelegate {

    public typealias DidStartScanningClosure = (Peripheral) -> Void

    static let shared = BluetoothScannerService()

    var isScanning: Bool { centralManager?.isScanning ?? false }
    var state: CBManagerState = .unknown
    var centralManager: CBCentralManager?
    var onStartScanning: DidStartScanningClosure?
    private var peripheralCoreDataStorage = PeripheralCoreDataStorage()

    override init() {
        super.init()
    }

    open func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.state = central.state
        switch central.state {
        case .poweredOn:
            scanForPeripherals()
        case .poweredOff:
            central.stopScan()
        case .unsupported: print("Error: note you should run only on real device")
        default: break
        }
    }

    open func startScanning(_ onStartScanning: DidStartScanningClosure? = nil) {

        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        self.onStartScanning = onStartScanning
    }

    private func scanForPeripherals() {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }

    // MARK: - CBCentralManagerDelegate

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let peripheral = peripheral.toDomain(advertisementData: advertisementData, rssi: RSSI.intValue)
        peripheralCoreDataStorage.save(peripheral: peripheral, completion: { _ in })
        print("Discovered peripheral: \(peripheral.represntableData)")

        onStartScanning?(peripheral)
        onStartScanning = nil // we need to set to nil because we need to notify only once and release memory
    }

}
