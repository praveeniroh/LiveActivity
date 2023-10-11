//
//  ViewController.swift
//  LiveActivity
//
//  Created by Praveenraj T on 11/10/23.
//

import UIKit
import ActivityKit
import AppIntents
import Combine

@available(iOS 16.1, *)
class ViewController: UIViewController {

    var subscriber: AnyCancellable?

    let startActivityButton:UIButton = {
        let button = UIButton()
        button.setTitle("Start ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        return button
    }()

    let updateActivityButton:UIButton = {
        let button = UIButton()
        button.setTitle("Update ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemMint
        return button
    }()

    let stopActivityButton:UIButton = {
        let button = UIButton()
        button.setTitle("Stop ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        return button
    }()


    let logLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureButtons()
    }

    func configureButtons(){
        view.addSubview(startActivityButton)
        startActivityButton.translatesAutoresizingMaskIntoConstraints = false
        startActivityButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        startActivityButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startActivityButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            startActivityButton.addTarget(self, action: #selector(startLiveActivity), for: .touchUpInside)


        view.addSubview(updateActivityButton)
        updateActivityButton.translatesAutoresizingMaskIntoConstraints = false
        updateActivityButton.topAnchor.constraint(equalTo: startActivityButton.bottomAnchor,constant: 10).isActive = true
        updateActivityButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateActivityButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        updateActivityButton.addTarget(self, action: #selector(updateLiveActivity), for: .touchUpInside)


        view.addSubview(stopActivityButton)
        stopActivityButton.translatesAutoresizingMaskIntoConstraints = false
        stopActivityButton.topAnchor.constraint(equalTo: updateActivityButton.bottomAnchor,constant: 10).isActive = true
        stopActivityButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stopActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stopActivityButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stopActivityButton.addTarget(self, action: #selector(stopLiveActivity), for: .touchUpInside)

        view.addSubview(logLabel)
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        logLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logLabel.topAnchor.constraint(equalTo: stopActivityButton.bottomAnchor).isActive = true

    }
    var stateUpdates:Activity<ActivityData>.ActivityUpdates?
    static var count:Int64 = 1
    
    @available(iOS 16.1, *)
    @objc func startLiveActivity(){
        let activityData = ActivityData(recordID: Self.count)
        Self.count += 1
        let contentState = ActivityData.State(name: "New activity \(Self.count)", startTime: Date(timeIntervalSinceNow: 60 * 60 * 4))
        DispatchQueue.global().async{
            LiveActivityUtil.startLiveActivity(for: activityData, state: contentState)
        }

    }


    @available(iOS 16.1, *)
    @objc func updateLiveActivity() {
        let updatedContent = ActivityData.ContentState(name: "New activity \(Self.count)", startTime: Date(timeIntervalSinceNow: 10))
        if let id = Activity<ActivityData>.activities.last?.attributes.recordID{
            LiveActivityUtil.updateLiveActivity(for: id , contentState: updatedContent)
        }
    }


    @objc func stopLiveActivity() {
        if let id = Activity<ActivityData>.activities.last?.attributes.recordID{
            LiveActivityUtil.endLiveActvity(for: Self.count.description)
        }
    }
}
