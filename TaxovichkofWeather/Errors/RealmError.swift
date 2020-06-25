//
//  RealmError.swift
//  TaxovichkofWeather
//
//  Created by Дмитрий Константинов on 24.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

enum RealmError: Error {
    case createFavoriteError
    case findFavoriteError
    case expiredDataError
}

extension RealmError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .createFavoriteError:
            return "Error creating a list of favorite cities in the database"
        case .findFavoriteError:
            return "Error finding your favorite city in the database. If reappeared, contact software developer"
        case .expiredDataError:
            return "Error validating data. If appears again, contact software developer."
        }
    }
}
