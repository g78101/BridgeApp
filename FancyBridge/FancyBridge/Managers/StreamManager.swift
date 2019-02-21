//
//  StreamManager.swift
//  Socket
//
//  Created by Talka_Ying on 2018/1/18.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

let ServerURL = "127.0.0.1"
let ServerPort = 9999
let bufferSize = 1024

protocol StreamManagerDelegate:class {
    func getData(_ data:String)
}

class StreamManager: NSObject, StreamDelegate {
    static var instance:StreamManager!
    //MARK: - Member
    weak var delegate:StreamManagerDelegate!
    
    var iStream:InputStream?
    var oStream:OutputStream?
    
    //MARK: - Init
    static func getInstance() -> StreamManager {
        
        if instance == nil {
            instance = StreamManager()
        }
        return instance!
    }
    
    override init() {
        super.init()
    }
    
    //MARK: - Function
    func connect() {
        if ServerURL != "0.0.0.0" {
            let host = CFHostCreateWithName(nil,ServerURL as CFString).takeRetainedValue()
            CFHostStartInfoResolution(host, .addresses, nil)
            var success: DarwinBoolean = false
            if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
                let theAddress = addresses.firstObject as? NSData {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                               &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    let numAddress = String(cString: hostname)
//                    print(numAddress)
                    socketStart(numAddress)
                }
            }
        }
        else {
            socketStart(ServerURL)
        }
    }
    
    func disconnect() {
        if (self.iStream != nil) && (self.oStream != nil) {
            self.iStream?.close()
            self.oStream?.close()
        }
    }
    
    func socketStart(_ ip:String) {
        DispatchQueue(label: "Stream").async {
            
            Stream.getStreamsToHost(withName: ip, port: ServerPort, inputStream: &self.iStream, outputStream: &self.oStream)
            
            if (self.iStream != nil) && (self.oStream != nil) {
                CFReadStreamSetProperty(self.iStream, CFStreamPropertyKey(rawValue: kCFStreamPropertyShouldCloseNativeSocket), kCFBooleanTrue)
                CFWriteStreamSetProperty(self.oStream, CFStreamPropertyKey(rawValue: kCFStreamPropertyShouldCloseNativeSocket), kCFBooleanTrue)
                
                self.iStream?.delegate = self
                self.iStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
                self.iStream?.open()
                
                self.oStream?.delegate = self
                self.oStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
                self.oStream?.open()
                
                RunLoop.current.run()
            }
        }
    }
    
    func sendMessage(_ message:String) {
        DispatchQueue(label: "Stream").async{
            let encodedDataArray = [UInt8](message.utf8)
            self.oStream?.write(encodedDataArray, maxLength: encodedDataArray.count)
        }
    }
    
    //MARK: - StreamDelegate
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        if (eventCode == .errorOccurred) {
            DispatchQueue.main.async {
                UIAlertController.showAlert(title: "Server Error", message: "Something is wrong")
            }
            
        }
        else if (eventCode == .hasBytesAvailable) {
            
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            let length = iStream?.read(&buffer, maxLength: buffer.count)
            if length! < 0 {
                return
            }
            let data = String(bytesNoCopy: &buffer, length: length!, encoding: String.Encoding.utf8, freeWhenDone: false)!
            
            DispatchQueue.main.async {
                if (self.delegate != nil) {
                    if data != "" {
                        for subData in data.split(separator: "\0") {
                            self.delegate.getData(String(subData))
                        }
                    }
                    else if !StateManager.getInstance().isGameOver {
                        // error func
//                        exit(1)
                        UIAlertController.showAlert(title: "Server Error", message: "Something is wrong")
                    }
                }
            }

        }
    }
}
