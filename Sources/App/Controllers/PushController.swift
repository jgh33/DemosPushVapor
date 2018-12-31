//
//  PushController.swift
//  Run
//
//  Created by 焦国辉 on 2018/12/30.
//

import Vapor
import Fluent
import PerfectNotifications


struct Payload: Content {
    var body: String
    var title: String
    var sound = "default"
    var badge = 1
    var token: String
    
}

class PushController: RouteCollection {
    func boot(router: Router) throws {
        router.post(Payload.self, at: "push", "one", use: pushOne)
    }
    
    
    func pushOne(_ req: Request, payload: Payload) throws -> String {
        pushOne(deviceToken: payload.token, payload: payload)
        return "ok"
    }
    
    func pushOne(deviceToken: String, payload: Payload) {
        let appId = "com.zyxx.jgh.Demos"
        let keyId = "DQ9TAR87JX"
        let teamId = "U68NQEERZT"
        let apnsKeyFilePath = "./apns/AuthKey_DQ9TAR87JX.p8"
        NotificationPusher.addConfigurationAPNS(name: appId, production: false, keyId: keyId, teamId: teamId, privateKeyPath: apnsKeyFilePath)
        let pusher = NotificationPusher(apnsTopic: appId)
        pusher.pushAPNS(configurationName: appId, deviceToken: deviceToken, notificationItems: [.alertBody(payload.body), .alertTitle(payload.title), .sound(payload.sound), .badge(payload.badge)]) { (response) in
            print("response: \(response)")
        }
    }
}
