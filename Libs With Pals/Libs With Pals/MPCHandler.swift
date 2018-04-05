//
//  MPCHandler.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

// class to set up the server connection between players 
class MPCHandler: NSObject, MCSessionDelegate {
    
    // id of every device connected in LAN
    var peerId:MCPeerID!
    
    // session of this game
    var session:MCSession!
    
    // view controller for browser
    var browser:MCBrowserViewController!
    
    // necesssary, need to advertise advice so visible to every other devide
    var advertiser:MCAdvertiserAssistant? = nil
    
    func setupPeerWithDisplayName(displayName:String) {
        peerId = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: peerId)
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "my-game", session:session)
    }
    
    // advertise to peer to start connection
    func advertiseSelf(advertise:Bool){
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
            print(advertiser.debugDescription)
        } else {
            advertiser!.stop()
            advertiser = nil
        }
    }
    
    // function to notify obervers when the state of the connection has changed
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerId": peerId, "state":state.rawValue] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    // function to notify observers when data is sent over the server
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data": data, "peerID": peerID] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    // not recieving any resources but required by protocol
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    // not recieving any resources but required by protocol
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
    
    // not recieving a data stream but required by protocol
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }

}
