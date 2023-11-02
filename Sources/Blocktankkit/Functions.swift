//
//  File.swift
//  
//
//  Created by Florian Hubl on 30.10.23.
//

import Foundation

@available(iOS 13, macOS 12, *)
extension Blocktank {
    
    /// Get Info
    /// - Returns: Information about Blocktank Lightning node and services on offer.
    public func getInfo() async throws -> Info {
        try await request(for: .info, method: .get, type: Info.self)
    }
    
    /// Request a channel to purchase.
    /// - Parameters:
    ///   - remoteBalance: The amount of sats you want on the remote side. The inbound liquidity. The amount of sats you can recieve on this channel.
    ///   - localBalance: The amount of sats you want on the your side. The outbound liquidity. The amount of sats you can send on this channel.
    ///   - weeks: How many weeks the channel will be open.
    /// - Returns: Purchase Information.
    public func purchaseChannel(remoteBalance: Int, localBalance: Int, weeks: Int, productID: String) async throws -> Channel {
        let payload = "{\"remote_balance\": \(remoteBalance),\"local_balance\": \(localBalance),\"channel_expiry\": \(weeks), \"product_id\": \"\(productID)\"}"
        return try await request(for: .buyChannel, method: .post, type: Channel.self, payload: payload)
    }
    
    /// Finalise a purchased channel
    /// - Parameters:
    ///   - productID: The ID of the product.
    ///   - orderID: The ID of the channel purchase from the Channel struct.
    ///   - nodeURI: Your Nodes URI: nodesPublicKey@Address:Port
    ///   - privateChannel: True if you want a private channel. Private channels are for mobile lightning Nodes that are often offline. Public channels are for always on lightning nodes. You cant route a payment with a private channel.
    public func finanlisePurchaseChannel(productID: String, orderID: String, nodeURI: String, privateChannel: Bool) async throws {
        let payload = "{\"product_id\": \(productID),\"oder_id\": \(orderID),\"node_uri\": \(nodeURI), \"private\": \(privateChannel)}"
        return try await request(for: .finaliseChannel, method: .post, payload: payload)
    }
    
    /// Get Order
    /// - Parameter orderID: The ID of the order.
    /// - Returns: Get all information regarding a channel order
    public func getOrder(orderID: String) async throws -> Channel {
        try await request(for: .getOrder, method: .post, type: Channel.self, urlExtention: "?order_id=\(orderID)")
    }
    
    /// LN URL connect to node
    /// - Parameters:
    ///   - orderID: Required for LNURL connect
    ///   - k1: Required for LNURL callback
    ///   - remoteID: Required for LNURL callback. Remote node address of form node_key@ip_address:port_number. IP address and port number is optional
    /// - Returns: Details about the LNURL
    public func lnURLConnectToNode(orderID: String, k1: String, remoteID: String) async throws -> LNURLConnectToNode {
        try await request(for: .lnurl, method: .post, type: LNURLConnectToNode.self, urlExtention: "?order_id=\(orderID)&k1=\(k1)&remote_id=\(remoteID)")
    }
}
