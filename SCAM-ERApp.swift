//
//  SCAM_ERApp.swift
//  SCAM-ER
//
//  Created by PANACEA-ECOSYSTEM-IA Team on 17/10/25.
//  Copyright © 2025 Inversiones y Servicios Eleusis Icono S.A. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct SCAM_ERApp: App {
    // MARK: - Shared Model Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FraudReport.self,
            WalletConnection.self,
            UserProfile.self,
            SecurityAlertModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // MARK: - Services
    @StateObject private var walletConnectManager = WalletConnectManager()
    @StateObject private var fraudDetectionService = FraudDetectionService()
    @StateObject private var notificationService = NotificationService()
    @StateObject private var analyticsService = AnalyticsService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(walletConnectManager)
                .environmentObject(fraudDetectionService)
                .environmentObject(notificationService)
                .environmentObject(analyticsService)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    // MARK: - App Setup
    private func setupApp() {
        // Configure analytics
        analyticsService.configure()
        
        // Setup notifications
        notificationService.requestPermission()
        
        // Initialize fraud detection
        fraudDetectionService.initialize()
        
        // Setup wallet connect
        walletConnectManager.setupWalletConnect()
        
        print("🛡️ SCAM-ER App initialized successfully")
    }
}

// MARK: - Data Models
@Model
class FraudReport {
    var id: UUID
    var fraudType: String
    var blockchain: String
    var transactionHash: String
    var walletAddress: String
    var reportDescription: String
    var evidenceImages: [Data]
    var status: String
    var createdAt: Date
    var updatedAt: Date
    
    init(fraudType: String, blockchain: String, transactionHash: String, walletAddress: String, description: String) {
        self.id = UUID()
        self.fraudType = fraudType
        self.blockchain = blockchain
        self.transactionHash = transactionHash
        self.walletAddress = walletAddress
        self.reportDescription = description
        self.evidenceImages = []
        self.status = "pending"
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
class WalletConnection {
    var id: UUID
    var walletName: String
    var walletAddress: String
    var blockchain: String
    var isConnected: Bool
    var connectedAt: Date?
    
    init(walletName: String, walletAddress: String, blockchain: String) {
        self.id = UUID()
        self.walletName = walletName
        self.walletAddress = walletAddress
        self.blockchain = blockchain
        self.isConnected = false
        self.connectedAt = nil
    }
}

@Model
class UserProfile {
    var id: UUID
    var username: String
    var email: String
    var phoneNumber: String
    var preferences: [String: Any]
    var createdAt: Date
    var updatedAt: Date
    
    init(username: String, email: String, phoneNumber: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.preferences = [:]
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
class SecurityAlertModel {
    var id: UUID
    var title: String
    var message: String
    var severity: String
    var isRead: Bool
    var createdAt: Date
    
    init(title: String, message: String, severity: String) {
        self.id = UUID()
        self.title = title
        self.message = message
        self.severity = severity
        self.isRead = false
        self.createdAt = Date()
    }
}
