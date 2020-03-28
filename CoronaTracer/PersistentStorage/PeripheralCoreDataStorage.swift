//
//  PeriferalCoreDataStorage.swift
//  CoronaTracer
//
//  Created by Oleh Kudinov on 28/03/2020.
//  Copyright © 2020 CoronaTracer. All rights reserved.
//

import Foundation

import CoreData

enum CoreDataMoviesQueriesStorageError: Error {
    case readError(Error)
    case writeError(Error)
    case deleteError(Error)
}

final class PeripheralCoreDataStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    func saveRecentQuery(peripheral: Peripheral, completion: @escaping (Result<Peripheral, Error>) -> Void) {

        coreDataStorage.performBackgroundTask { context in
            do {
                let entity = PeripheralEntity(peripheral: peripheral, insertInto: context)
                try context.save()

                completion(.success(Peripheral(peripheralEntity: entity)))
            } catch {
                completion(.failure(CoreDataMoviesQueriesStorageError.writeError(error)))
                print(error)
            }
        }
    }
}

private extension PeripheralEntity {
    convenience init(peripheral: Peripheral, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = peripheral.uuid
        name = peripheral.advertisedName
        state = peripheral.state
        rssi = peripheral.rssi
        createdAt = Date()
    }
}

private extension Peripheral {
    init(peripheralEntity: PeripheralEntity) {
        uuid = peripheralEntity.identifier ?? ""
        advertisedName = peripheralEntity.name
        state = peripheralEntity.state ?? ""
        rssi = peripheralEntity.rssi ?? ""
    }
}
