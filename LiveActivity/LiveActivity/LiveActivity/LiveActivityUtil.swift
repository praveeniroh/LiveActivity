//
//  LiveActivityUtil.swift
//  LiveActivity
//
//  Created by Praveenraj T on 11/10/23.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityUtil{



    static func startLiveActivity(for activityData:ActivityData,state contentState:ActivityData.State){
        do{
            if #available(iOS 16.2, *) {
                let content = ActivityContent(state: contentState, staleDate: Date(timeIntervalSinceNow: 10))
                let _ =  try Activity<ActivityData>.request(attributes: activityData, content: content)

            } else {
                // Fallback on earlier versions
                    let _ = try Activity<ActivityData>.request(attributes: activityData, contentState: contentState)

            }

        }catch{
            print("Error:\(error)")
        }
    }

    static func updateLiveActivity(for recordID:Int64,contentState state:ActivityData.State){
        guard let activity = getLiveActivity(for: recordID) else{
            return
        }
        if #available(iOS 16.2, *) {
            let isNewScoreNeeded = activity.content.state.startTime != state.startTime
            let content = ActivityContent(state: state, staleDate: Date(timeIntervalSinceNow: 60 * 60 * 12),relevanceScore:isNewScoreNeeded ? getRelevanceScore(for: state.startTime) : activity.content.relevanceScore)
            Task{
                await  activity.update(content)
            }
        } else  {
            Task{
                await  activity.update(using: state)
            }
        }
    }

    static func endLiveActvity(for recordID:String,contentState state:ActivityData.State? = nil,dismissalPolicy:ActivityUIDismissalPolicy = .immediate){
        guard let id = Int64(recordID), let activity = getLiveActivity(for: id) else{
            return
        }
        Task{
            if #available(iOS 16.2, *),let state {
                let content = ActivityContent(state: state, staleDate: Date(timeIntervalSinceNow: 60 * 60 * 12),relevanceScore: activity.content.relevanceScore)
                await  activity.end(content,dismissalPolicy:dismissalPolicy)
            }else{
                await activity.end(using:state,dismissalPolicy: dismissalPolicy)
            }
        }
    }

    static func getCurrentStateData(forRecordID id:String)-> ActivityData.ContentState?{
        guard let recordID = Int64(id) else {return nil}
        let activity = getLiveActivity(for: recordID)
        if #available(iOS 16.2, *) {
            return activity?.content.state
        } else {
            return activity?.contentState
        }
    }

    static func getLiveActivity(for recordID:Int64) -> Activity<ActivityData>?{
        Activity<ActivityData>.activities.first(where: {$0.attributes.recordID == recordID})
    }

    @available(iOS 16.2, *)
    private static func getRelevanceScore(for date:Date) -> Double{
        //To avoid overflow while calculating the sum, /2 added to each element
        let minScore = Double.greatestFiniteMagnitude * 0.8
       let sortedActivities =  Activity<ActivityData>.activities.sorted(by: {$0.content.state.startTime < $1.content.state.startTime})
        if sortedActivities.isEmpty{
            return minScore/2 + Double.greatestFiniteMagnitude / 2
        }
        var firstLargeDateIndex:Int?
        firstLargeDateIndex = sortedActivities.firstIndex(where: {$0.content.state.startTime > date})

        if let index = firstLargeDateIndex{
            if index == 0{
                return sortedActivities[index].content.relevanceScore/2 + Double.greatestFiniteMagnitude/2
            }else{
                return sortedActivities[index].content.relevanceScore/2 +  sortedActivities[index - 1].content.relevanceScore/2
            }
        }else{
            return minScore/2 + sortedActivities[sortedActivities.count - 1].content.relevanceScore/2
        }
    }
}

@available(iOS 17.0,*)
extension LiveActivityUtil{

    @available(iOS 17.0,*)
    static func showLoadingView(recordID:String){
        if let currentState = getCurrentStateData(forRecordID: recordID){
            let state = ActivityData.State(name: currentState.name, startTime: currentState.startTime , isLoading: true)
            updateLiveActivity(forRecordID: recordID, state: state)
        }
    }

    @available(iOS 17.0,*)
    static func showCompletedView(recordID:String){
        if let activity = LiveActivityUtil.getLiveActivity(for: Int64(recordID)!),let currentState = getCurrentStateData(forRecordID: recordID){
            let state = ActivityData.State(name: currentState.name, startTime: currentState.startTime ,isCompleted: true)
            Task{
                await  activity.update(using: state)
            }
//            updateLiveActivity(forRecordID: recordID, state: <#T##ActivityData.ContentState#>)
        }
    }


    static func updateLiveActivity(forRecordID id:String,state:ActivityData.ContentState){
        guard let recordID = Int64(id) else{
            return
        }
        updateLiveActivity(for: recordID, contentState: state)
    }
}



