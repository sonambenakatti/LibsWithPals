//
//  MPCHandler.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

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
    
    func advertiseSelf(advertise:Bool){
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
        } else {
            advertiser!.stop()
            advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerId": peerId, "state":state.rawValue] as [String : Any]
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotif"), object: nil)
        //})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        <#code#>
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        <#code#>
    }

}
