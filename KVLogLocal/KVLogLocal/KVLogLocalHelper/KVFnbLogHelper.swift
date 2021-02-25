//
//  KVFnbLogHelper.swift
//  SimpleLocalLogStart
//
//  Created by AnhVH on 05/02/2021.
//  Copyright © 2021 anhvh. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

@objc public class KVFnbLogHelper: NSObject {
    @objc public static let shared = KVFnbLogHelper()
    
    @objc var hostName = ""
    @objc var networkStatus = ""
    
    @objc override init() {
        super.init()
    }
    
    // MARK: - Setting
    @objc public func setup () {
        let fileManager = FileManager.default
        guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let logPath = documentPath.appendingPathComponent(LogConstants.Directory.logs)
        fileManager.createDirectoryIfNeeded(path: logPath)
        print("LogsDB: \(logPath)")
    }
    
    @objc public func verifyLogHelper () {
        guard let previousTime = Defaults[LogConstants.FnbLogKey.timeIntervalChecked] else {
            // first time deploying Log
            Defaults[LogConstants.FnbLogKey.timeIntervalChecked] = Date()
            return
        }
        let days = Date().difDays(from: previousTime)
        
        if days > 1 {
            // clear log on the day before
            let toDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            KVFnbLogStore.shared.clearLogToGivenTime(date: toDate)
            self.cleanLogFile()
        }
    }
    
    // MARK: - Handler
    @objc public func saveLogLocal (eventLog: String, networkStatus: String = "") {
        DispatchQueue.main.async {
            let fnbLog = FnbLogModel()
            fnbLog.logEvent = eventLog
            fnbLog.networkStatus = networkStatus
            fnbLog.createdDate = Date()
            KVFnbLogStore.shared.saveLog(logEvent: fnbLog)
        }
    }
    
    @objc public func getAllLog () -> [FnbLogModel] {
        return KVFnbLogStore.shared.getLogs()
    }
    
    /// Saving app info
    @objc public func saveAppInfoLog() {
        DispatchQueue.main.async {
            let defaultParams : Dictionary = [
                LogConstants.FnbLogKey.IpAddress : Utils.getIPAddress(),
                LogConstants.FnbLogKey.deviceModel : UIApplication.shared.shortVersionString,
                LogConstants.FnbLogKey.deviceIosVersion : Utils.getOSInfo()
            ]
            
            let appInfo = self.json(from: defaultParams)
            let fnbAppInfoLog = FnbLogModel()
            fnbAppInfoLog.logEvent = appInfo ?? ""
            fnbAppInfoLog.networkStatus = ""
            fnbAppInfoLog.createdDate = Date()
            KVFnbLogStore.shared.saveLog(logEvent: fnbAppInfoLog)
        }
    }
    
    // MARK: - Utils
    @objc public func dataFilePathLogs (fileName: String) -> String {
        return FileManager.default.logDirectoryPath.appendingFormat("\(fileName)")
    }
    
    @objc public func writeToReportFile () -> URL {
        // get logs from db
        let logs = self.getAllLog()
        // save logs to file
        let path = URL(fileURLWithPath: dataFilePathLogs(fileName: "/logs.txt"))
        do {
            let logEncoded = try JSONEncoder().encode(logs)
            do {
                try logEncoded.write(to: path)
            }
            catch {
                KVFnbLogHelper.shared.saveLogLocal(eventLog: "Failed to write logs: \(error.localizedDescription)", networkStatus: "current Network status")
            }
        } catch {
            KVFnbLogHelper.shared.saveLogLocal(eventLog: "Failed to encode logs: \(error.localizedDescription)", networkStatus: "current Network status")
        }
        return path
    }
    
    @objc public func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    @objc public func cleanLogFile () {
        let fileManager = FileManager.default
        guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let logPath = documentPath.appendingPathComponent("\(LogConstants.Directory.logs)/logs.txt")
        let t = ""
        do {
            try t.write(to: logPath, atomically: true, encoding: .utf8)
            print("success clean logs file at: \(logPath)")
        } catch let error {
            //could not delete log at file path
            print("Could not clean logs at file path: \(error.localizedDescription)")
        }
    }
    
    @objc public func getInfos (params: FnbLogModel) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}

