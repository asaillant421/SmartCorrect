//
//  HostManager.swift
//  SmartCorrect
//
//  Created by Meir Radnovich on 27 Tammuz 5782.
//
//  Chooses the base host URL for the application to use

import Foundation
import Combine

class HostManager {
    static let shared = HostManager()
    
    @Published var selectedHost: APIHost = {
        let hostNum: Int? = UserDefaults.standard.value(for: .host)
        
        if let hostNum = hostNum, //will return 0 if not found, so started enum at 1
           let host = APIHost(rawValue: hostNum) {
            return host
        } else {
            #if DEBUG
            return .development
            #else
            return .production
            #endif
        }
    }()
    
    var url: URL {
        return URL(string: selectedHost.url)!
    }
    
    var availableHosts: [APIHost] = [.development]
    
    private init() {
        
    }
    
    func updateHost(host: APIHost) {
        UserDefaults.standard.set(value: host.rawValue, for: .host)
        self.selectedHost = host
        UserDefaults.standard.synchronize()
    }

}
