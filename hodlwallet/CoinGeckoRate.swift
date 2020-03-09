//
//  CoinGeckoRate.swift
//  hodlwallet
//
//  Created by Eric Britten on 3/6/20.
//  Copyright © 2020 Hodl Wallet Inc. All rights reserved.
//

import Foundation
import UIKit

struct CoinGeckoRate {
    let code: String
    let name: String
    let rate: Double

    var currencySymbol: String {
        if let symbol = CoinGeckoRate.symbolMap[code] {
            return symbol
        } else {
            let components: [String : String] = [NSLocale.Key.currencyCode.rawValue : code]
            let identifier = Locale.identifier(fromComponents: components)
            return Locale(identifier: identifier).currencySymbol ?? code
        }
    }

    static var symbolMap: [String: String] = {
        var map = [String: String]()
        Locale.availableIdentifiers.forEach { identifier in
            let locale = Locale(identifier: identifier)
            guard let code = locale.currencyCode else { return }
            guard let symbol = locale.currencySymbol else { return }

            if let collision = map[code] {
                if collision.utf8.count > symbol.utf8.count {
                    map[code] = symbol
                }
            } else {
                map[code] = symbol
            }
        }
        return map
    }()

    var locale: Locale {
        let components: [String : String] = [NSLocale.Key.currencyCode.rawValue : code]
        let identifier = Locale.identifier(fromComponents: components)
        return Locale(identifier: identifier)
    }
    
    static var empty: CoinGeckoRate {
        return CoinGeckoRate(code: "", name: "", rate: 0.0)
    }
}

extension CoinGeckoRate {
    init?(data: Any) {
        guard let (c, r) = data as? (String, Any) else { return nil }
        let code = c.uppercased()
        let name = code
        guard let rate = r as? Double else { return nil }
        self.init(code: code, name: name, rate: rate)
    }

    var dictionary: [String: Any] {
        return [
            "code": code,
            "name": name,
            "rate": rate
        ]
    }
    
    var rateObject: Rate {
        return Rate(code: code, name: name, rate: rate)
    }
}

extension CoinGeckoRate : Equatable {}

func ==(lhs: CoinGeckoRate, rhs: CoinGeckoRate) -> Bool {
    return lhs.code == rhs.code && lhs.name == rhs.name && lhs.rate == rhs.rate
}
