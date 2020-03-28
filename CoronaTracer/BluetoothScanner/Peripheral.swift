//
//  Peripheral.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol PeripheralRepresntable {
    var advertisedName: String? { get }
    var state: String { get }
    var rssi: String { get }
    var uuid: String { get }
}

extension PeripheralRepresntable {

    public var tableViewData: [String: String] {
        return [
            "ID": uuid,
            "NAME": advertisedName ?? "unknown",
            "STATE": state,
            "RSSI": "\(rssi)"
        ]
    }

}

extension CBPeripheralState {
    var stringRepresentation: String {
        switch self {
        case .disconnected: return "disconnected"
        case .connected: return "connected"
        case .connecting: return "connecting"
        case .disconnecting: return "disconnecting"
        @unknown default:
            fatalError()
        }
    }
}

extension CBPeripheral {
    public func asPeripheral(advertisementData: [String: Any],rssi: Int) -> PeripheralRepresntable {
        return Peripheral(self, advertisementData: advertisementData, rssi: rssi)
    }
}

struct Peripheral: PeripheralRepresntable {

    let advertisedName: String?
    var state: String { return peripheral.state.stringRepresentation }
    var uuid: String { return peripheral.identifier.uuidString }

    let rssi: String
    let peripheral: CBPeripheral

    init(_ peripheral: CBPeripheral, advertisementData: [String: Any], rssi: Int) {
        self.advertisedName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? peripheral.name
        self.peripheral = peripheral
        self.rssi = "\(rssi)"
    }

}
