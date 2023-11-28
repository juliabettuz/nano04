//
//  RemindersStruct.swift
//  Nano04
///Users/juliabettuz/Downloads/Documentos/Nano 04 Pasta/Nano04/Nano04/Helpers/RemindersStruct.swift
//  Created by Julia Bettuz on 09/10/23.
//

import Foundation

struct ReminderStruct: Encodable, Decodable, Sendable {
    var reminderName: String
    var reminderState: Bool

}
