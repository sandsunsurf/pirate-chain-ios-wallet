//
//  String+localized.swift
//  wallet
//
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
          return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
      }

      func localizeWithFormat(arguments: CVarArg...) -> String{
          return String(format: self.localized(), arguments: arguments)
      }
}
