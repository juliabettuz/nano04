//
//  TimeFormatting.swift
//  Nano04
//
//  Created by Julia Bettuz on 03/10/23.
//

import Foundation

func calcTimeSince (date: Date) -> String {
    
let minutes = Int (-date.timeIntervalSinceNow)/60
let hours = minutes/60
let days = hours/24
    
    if minutes < 120 {
        return "há \(minutes) minutos"
    } else if minutes >= 120 && hours < 48 {
        return "há \(hours) horas"
    }else {
        return " há \(days) dias"
    }
    
}
