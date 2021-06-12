//
//  NoInternetService.swift
//  smartPOS
//
//  Created by I Am Focused on 12/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import SwiftEntryKit
import SwiftEventBus

class EntryAttributeWrapper {
    var attributes: EKAttributes
    init(with attributes: EKAttributes) {
        self.attributes = attributes
    }
}

class NoInternetService {
    // MARK: - Properties

    let network = NetworkManager.sharedInstance
    
    private var displayMode: EKAttributes.DisplayMode {
        return PresetsDataSource.displayMode
    }
    
    private var attributes: EKAttributes?
    
    private lazy var attributesWrapper: EntryAttributeWrapper = {
        var attributes = EKAttributes()
        attributes.positionConstraints = .fullWidth
        attributes.hapticFeedbackType = .success
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.entryBackground = .visualEffect(style: .standard)
        return EntryAttributeWrapper(with: attributes)
    }()
    
    static func isReachable() -> Bool {
        return UserDefaults.standard.bool(forKey: "isReachable")
    }

    init() {
        SwiftEventBus.onMainThread(self, name: "ReachableInternet") { result in
//            SwiftEventBus.post("login", sender: Person(name: "cesar ferreira"))
            let isReachable = result?.object as! Bool
            UserDefaults.standard.setValue(isReachable, forKey: "isReachable")
            print("Internet in Reachable: ", isReachable)
            self.setup()
            SwiftEventBus.post("UpdatePOSStatus", sender: isReachable)
            if isReachable {
                SwiftEntryKit.dismiss()
                return
            }
            self.showImageNote(attributes: self.attributes!)
//            self.play()
        }
        network.reachability.whenReachable = { _ in
            let isReachable = true
            SwiftEventBus.post("ReachableInternet", sender: isReachable)
        }
        network.reachability.whenUnreachable = { _ in
            let isReachable = false
            SwiftEventBus.post("ReachableInternet", sender: isReachable)
        }
    }

    private func setup() {
        attributes = .statusBar
        attributes!.displayMode = displayMode
        attributes!.hapticFeedbackType = .error
        attributes!.displayDuration = .infinity
        attributes!.popBehavior = .animated(animation: .translation)
        attributes!.entryBackground = .color(color: Color.Netflix.light)
        attributes!.statusBar = .light
    }

    private func showImageNote(attributes: EKAttributes) {
        let text = "The internet is not availabel!"
        let style = EKProperty.LabelStyle(
            font: MainFont.light.with(size: 10),
            color: .white,
            alignment: .center,
            displayMode: displayMode
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )
        let imageView = UIImageView(image: UIImage(named: "ic_no_wifi"))
        imageView.setImageColor(color: UIColor.purple)
        let imageContent = EKProperty.ImageContent(
            image: imageView.image!,
            displayMode: displayMode
        )
        let contentView = EKImageNoteMessageView(
            with: labelContent,
            imageContent: imageContent
        )
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    fileprivate func play() {
        let title = EKProperty.LabelContent(
            text: "Hi there!",
            style: EKProperty.LabelStyle(
                font: MainFont.bold.with(size: 16),
                color: .black
            )
        )
        let description = EKProperty.LabelContent(
            text: "Are you ready for some testing?",
            style: EKProperty.LabelStyle(
                font: MainFont.light.with(size: 14),
                color: .black
            )
        )
        let image = EKProperty.ImageContent(
            image: UIImage(named: "ic_info_outline")!,
            size: CGSize(width: 30, height: 30)
        )
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributesWrapper.attributes)
    }
}
