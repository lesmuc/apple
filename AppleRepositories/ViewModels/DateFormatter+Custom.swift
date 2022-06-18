//
//  DateFormatter+Custom.swift
//  AppleRepositories
//
//  Created by Udo Von Eynern on 18.06.22.
//

import Foundation

extension DateFormatter {
    
    static let mediumDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none

        return df
    }()
}
