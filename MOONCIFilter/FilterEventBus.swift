//
//  FilterEventBus.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit

class FilterEventBus {
    
    static let shared = FilterEventBus()
    private init() {}
    
    enum EventsType {
        case draw
    }
    
    var events: [EventsType] = []
    
    func sendEvent(_ type: EventsType) {
        if events.count > 1 {
            events[1] = type
        }
    }
    
    func regist(_ listener: Any) {
        
    }
}
