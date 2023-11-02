
import Foundation

public struct Order: Codable {
    public let local_balance, remote_balance, channel_expiry, channel_expiry_ts, order_expiry, total_amount: Int
    public let btc_address: String
    public let created_at: Int
    public let amount_received: Double
    public let remote_node: RemoteNode
    
    public struct RemoteNode: Codable {
        public let err: Bool
        public let port: Double
        public let ip: String
        public let addr: String
        public let public_key: String
    }
    
    public let channel_open_tx: ChannelOpenTx
    
    public struct ChannelOpenTx: Codable {
        public let transaction_id: String
        public let transaction_vout: String
    }
    
    public let purchase_invoice: String
    public let lnurl: LNURL
    
    public struct LNURL: Codable {
        public let uri: String
        public let callback: String
        public let k1: String
        public let tag: String
    }
    
    public let state: State
    
    public struct State: Codable {
        public let CREATED, PAID, URI_SET, OPENING, CLOSING, GIVE_UP, CLOSED, OPEN: Double
    }
    
    public let onchain_payments: [OnchainPayments]
    
    public struct OnchainPayments: Codable {
        public let height: Int
        public let hash: String
        public let to: String
        public let amount_base: Int
        public let zero_conf: Bool
    }
}
