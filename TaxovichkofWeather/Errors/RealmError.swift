//
//  RealmError.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 24.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

enum RealmError: Error {
    case findFavoriteError
}

extension RealmError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .findFavoriteError:
            return "Error finding your favorite city in the database. Reinstall the application. If reappeared, contact software developer"
        }
    }
}
