//
//  ActivityData.swift
//  LiveActivity
//
//  Created by Praveenraj T on 11/10/23.
//

import Foundation
import ActivityKit

struct ActivityData:ActivityAttributes{

    typealias ContentState = State

    struct State:Codable,Hashable{
        var name:String
        var startTime:Date
        var isLoading = false
        var isCompleted = false
    }

    let recordID:Int64
    var isActivityCompleted = false
}
