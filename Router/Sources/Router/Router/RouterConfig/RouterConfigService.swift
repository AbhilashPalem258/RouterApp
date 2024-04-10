//
//  File.swift
//  
//
//  Created by Abhilash Palem on 10/04/24.
//

import Foundation
import FirebaseRemoteConfig
import Combine

struct FIRRouterConfigService {
    
    let remoteConfig: RemoteConfig
    let items: [RouterConfigItem] = []
    let onDataChange = PassthroughSubject<Data, Never>()
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    func fetchConfig() {
        remoteConfig.fetch { (status, error) -> Void in
          if status == .success {
              logInfo("Config fetched!")
              fetchData()
              listenForChanges()
          } else {
              logInfo("Config not fetched")
              logError("Error: \(error?.localizedDescription ?? "No error available.")")
          }
        }
    }
    
    func fetchData() {
        self.remoteConfig.activate { changed, error in
            guard error == nil else { return }
            self.onDataChange.send(self.remoteConfig.configValue(forKey: "router_config").dataValue)
        }
    }
    
    func listenForChanges() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                logError("Error listening for config updates: \(error)")
                return
            }

            logInfo("Updated FIR keys: \(configUpdate.updatedKeys)")
            fetchData()
        }
    }
}
