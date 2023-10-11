//
//  LiveActivityWidget.swift
//  LiveActivity
//
//  Created by Praveenraj T on 11/10/23.
//


import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

@available(iOS 16.1, *)
struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ActivityData.self) { context in
            // Lock screen/banner UI goes here
            ZStack{
                VStack(alignment: .leading) {
                    HStack(alignment: .center){
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .frame(width:38,height: 38)

                        VStack(alignment: .leading){
                            HStack{
                                Text("Task will start in")
                                    .font(.system(size: 18,weight: .bold))
                                Spacer()
                                let timeRange = Date()...context.state.startTime
                                Text(timerInterval: timeRange, pauseTime: timeRange.lowerBound, countsDown: true)
                                    .font(.system(size: 22,weight: .bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            Text(context.state.name)
                                .font(.system(size: 16,weight: .medium))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    if context.state.isCompleted {
                        RoundedRectangle(cornerRadius: 20, style: .circular)
                            .frame(width: .infinity,height: 40)
                            .foregroundStyle(Color.green)
                            .overlay(content: {
                                Text("Completed")
                                    .font(Font.system(size: 16,weight: .bold))
                            })
                    }else if !context.state.isLoading{
                        LiveActivityActionButtonsView(recordID: context.attributes.recordID.description)
                    }else{
                        //Loding view
                        RoundedRectangle(cornerRadius: 20, style: .circular)
                            .frame(width: .infinity,height: 40)
                            .foregroundStyle(Color.green)
                            .overlay(content: {
                                ProgressView(timerInterval: Date()...Date(timeIntervalSinceNow: 2), countsDown: false, label: {

                                }, currentValueLabel: {

                                })
                                .frame(width: 26,height: 26)
                                .progressViewStyle(.circular)
                                .foregroundStyle(.white)
                                .tint(.white)
                            })
                    }

                }

                .padding(16)
                .activityBackgroundTint(Color.black)
                .activitySystemActionForegroundColor(Color.white)
                .foregroundStyle(Color.white)
                //Provide your custom url to navigate to record when app is opened through live activity
                //                .widgetURL()
            }

        } dynamicIsland: { context in
            let timeRange = Date()...context.state.startTime

            return DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Task will start in")
                        .font(.system(size: 18))
                        .bold()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: timeRange, pauseTime: timeRange.lowerBound, countsDown: true)
                        .font(.system(size: 22,weight: .bold))
                        .multilineTextAlignment(.trailing)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(context.state.name)
                                .font(Font.system(size: 16,weight: .medium))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Spacer()
                        }

                        if context.state.isCompleted {
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .frame(width: .infinity,height: 40)
                                .foregroundStyle(Color.green)
                                .overlay(content: {
                                    Text("Completed")
                                        .font(Font.system(size: 16,weight: .bold))

                                })
                        }else if !context.state.isLoading{
                            LiveActivityActionButtonsView(recordID: context.attributes.recordID.description)
                        }else{
                            //Loading view
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .frame(width: .infinity,height: 40)
                                .foregroundStyle(Color.green)
                                .overlay(content: {
                                    ProgressView(timerInterval: Date()...Date(timeIntervalSinceNow: 2), countsDown: false, label: {

                                    }, currentValueLabel: {

                                    })
                                    .frame(width: 26,height: 26)
                                    .progressViewStyle(.circular)
                                    .foregroundStyle(.white)
                                })
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21, alignment: .center)
                    .clipShape(Circle())
            } compactTrailing: {
                Text(timerInterval: timeRange, pauseTime: timeRange.lowerBound, countsDown: true)
                    .frame(minWidth: 0,maxWidth: 65)
                    .multilineTextAlignment(.trailing)
            } minimal: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            }
            .keylineTint(Color.red)
            .contentMargins([.leading],20, for: .expanded)
            .contentMargins([.bottom],16, for: .expanded)
        }
    }
}


@available(iOS 16.1, *)
struct LiveActivityActionButtonsView:View {
    let recordID:String
    var body: some View {
        HStack{
            Button(intent: CompleteTaskAppIntent(recordID: recordID), label: {
                Label("Complete", image:"")
            })
            .buttonStyle(.plain)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,minHeight:40,maxHeight:40)
            .background(Color.green)
            .clipShape(Capsule())
            .foregroundStyle(Color.white)

        }
    }
}

