//
//  Peripheral.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import Foundation
import CoreBluetooth



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
    public func toDomain(advertisementData: [String: Any],rssi: Int) -> Peripheral {
        return Peripheral(self, advertisementData: advertisementData, rssi: rssi)
    }
}

public struct Peripheral {

    public let advertisedName: String?
    public let state: String
    public let uuid: String
    public let rssi: String

    init(_ peripheral: CBPeripheral, advertisementData: [String: Any], rssi: Int) {
        self.uuid = peripheral.identifier.uuidString
        self.advertisedName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? peripheral.name
        self.state = peripheral.state.stringRepresentation
        self.rssi = "\(rssi)"
    }

}

extension Peripheral {

    public var represntableData: String {
        return """
            "ID": \(uuid) "NAME": \(advertisedName ?? "unknown") "STATE": \(state) "RSSI": "\(rssi)"
        """
    }
}
