//
//  CompleteTaskAppIntent.swift
//  LiveActivity
//
//  Created by Praveenraj T on 11/10/23.
//

import Foundation
import AppIntents
import ActivityKit

@available(iOS 17.0, *)
struct CompleteTaskAppIntent:LiveActivityIntent{
    init() {
    }

    @Parameter(title:"RecordID")
    var recordID : String

    init(recordID:String){
        self.recordID = recordID

    }

    static var openAppWhenRun: Bool = false

    static var title: LocalizedStringResource = "Live activity"

    static var isDiscoverable: Bool = false


    func perform() async throws -> some IntentResult {

        LiveActivityUtil.showLoadingView(recordID: recordID)
///Note:  The sleep funtion is only for demo purpose , in real world case the loading animation will be shown until the API response returns
        sleep(2)
        return await withCheckedContinuation{continuation in
            //API handling comes here

                LiveActivityUtil.showCompletedView(recordID: recordID)

                if let state = LiveActivityUtil.getCurrentStateData(forRecordID: recordID){
                    let newState = ActivityData.ContentState(name: state.name,startTime: state.startTime,isCompleted: true)
                    LiveActivityUtil.updateLiveActivity(forRecordID: recordID, state: newState)
                    sleep(5)
                    LiveActivityUtil.endLiveActvity(for: recordID)
                }
                continuation.resume(returning: IntentResultContainer.result())
            }

    }
}

