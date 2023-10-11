//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by Praveenraj T on 11/10/23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        Widgets()
        WidgetsLiveActivity()
        LiveActivityWidget()
    }
}
