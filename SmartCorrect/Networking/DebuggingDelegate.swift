//
//  DebuggingDelegate.swift
//  SmartCorrect
//
//  Created by Meir Radnovich on 7 Av 5782.
//

import Foundation

class DebuggingDelegate : NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError: Error?) {
        if let e = didCompleteWithError {
            NSLog("FLUFFERNUTTER Session completed with error: \(e.localizedDescription)")
        } else {
            NSLog("FLUFFERNUTTER Session completed: urlSession: \(session) task: \(task)")
        }
    }
}
