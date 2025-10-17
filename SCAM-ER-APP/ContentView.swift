//
//  ContentView.swift
//  SCAM-ER
//
//  Created by PANACEA-ECOSYSTEM-IA Team on 17/10/25.
//  Copyright © 2025 Inversiones y Servicios Eleusis Icono S.A. All rights reserved.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @EnvironmentObject private var walletConnectManager: WalletConnectManager
    @EnvironmentObject private var fraudDetectionService: FraudDetectionService
    @EnvironmentObject private var notificationService: NotificationService
    @EnvironmentObject private var analyticsService: AnalyticsService
    
    @State private var selectedTab = 0
    @State private var showOnboarding = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Principal
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
                .tag(0)
            
            // Detección de Fraudes
            FraudDetectionView()
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Detectar")
                }
                .tag(1)
            
            // Reportar Fraude
            ReportFraudView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Reportar")
                }
                .tag(2)
            
            // Estadísticas
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Estadísticas")
                }
                .tag(3)
            
            // Wallet
            WalletView()
                .tabItem {
                    Image(systemName: "wallet.pass.fill")
                    Text("Wallet")
                }
                .tag(4)
            
            // Perfil
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(5)
        }
        .accentColor(.orange)
        .onAppear {
            checkOnboardingStatus()
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
    
    private func checkOnboardingStatus() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        if !hasSeenOnboarding {
            showOnboarding = true
        }
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    @EnvironmentObject private var fraudDetectionService: FraudDetectionService
    @EnvironmentObject private var analyticsService: AnalyticsService
    @State private var stats = DashboardStats()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header con logo y notificaciones
                    headerView
                    
                    // Estadísticas principales
                    statsCardsView
                    
                    // Alertas de seguridad recientes
                    recentAlertsView
                    
                    // Casos destacados
                    featuredCasesView
                    
                    // Acciones rápidas
                    quickActionsView
                }
                .padding()
            }
            .navigationTitle("SCAM-ER")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .refreshable {
                await refreshData()
            }
        }
        .onAppear {
            loadDashboardData()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("¡Bienvenido!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Protege tus activos cripto")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Acción de notificaciones
            }) {
                ZStack {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    
                    if stats.unreadAlerts > 0 {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
    }
    
    // MARK: - Stats Cards
    private var statsCardsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Reportes Hoy",
                value: "\(stats.todayReports)",
                icon: "exclamationmark.triangle.fill",
                color: .orange,
                trend: "+\(stats.reportsTrend)%"
            )
            
            StatCard(
                title: "Fraudes Detectados",
                value: "\(stats.detectedFrauds)",
                icon: "shield.fill",
                color: .red,
                trend: "+\(stats.detectionTrend)%"
            )
            
            StatCard(
                title: "Pérdidas Evitadas",
                value: "$\(String(format: "%.1f", stats.avoidedLosses))M",
                icon: "dollarsign.circle.fill",
                color: .green,
                trend: "+\(stats.savingsTrend)%"
            )
            
            StatCard(
                title: "Precisión IA",
                value: "\(stats.aiAccuracy)%",
                icon: "brain.head.profile",
                color: .purple,
                trend: "+\(stats.accuracyTrend)%"
            )
        }
    }
    
    // MARK: - Recent Alerts
    private var recentAlertsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Alertas Recientes")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Ver Todas") {
                    // Navegar a alertas
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(stats.recentAlerts, id: \.id) { alert in
                        AlertCard(alert: alert)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Featured Cases
    private var featuredCasesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Casos Destacados")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Ver Todos") {
                    // Navegar a casos
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                ForEach(stats.featuredCases, id: \.id) { case_ in
                    CaseRow(case_: case_)
                }
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Acciones Rápidas")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "magnifyingglass",
                    title: "Verificar TX",
                    color: .blue
                ) {
                    // Verificar transacción
                }
                
                QuickActionButton(
                    icon: "plus.circle",
                    title: "Reportar",
                    color: .orange
                ) {
                    // Reportar fraude
                }
                
                QuickActionButton(
                    icon: "shield.checkered",
                    title: "Escanear",
                    color: .green
                ) {
                    // Escanear QR
                }
            }
        }
    }
    
    // MARK: - Actions
    private func loadDashboardData() {
        // Cargar datos del dashboard
        stats = DashboardStats.sample()
    }
    
    private func refreshData() async {
        // Refrescar datos
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simular delay
        loadDashboardData()
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(trend)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct AlertCard: View {
    let alert: SecurityAlert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(alert.severityColor)
                    .frame(width: 8, height: 8)
                
                Text(alert.timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(alert.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(alert.message)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct CaseRow: View {
    let case_: FeaturedCase
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(case_.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("\(case_.reports) reportes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(case_.status)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(case_.statusColor)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemGray6))
        )
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.1))
            )
        }
    }
}


// MARK: - Placeholder Views
struct FraudDetectionView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Detección de Fraudes")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Funcionalidad en desarrollo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Detectar Fraudes")
        }
    }
}

struct ReportFraudView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "plus.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Reportar Fraude")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Funcionalidad en desarrollo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Reportar")
        }
    }
}

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "chart.bar")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Estadísticas")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Funcionalidad en desarrollo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Estadísticas")
        }
    }
}

struct WalletView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "wallet.pass")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Wallet")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Funcionalidad en desarrollo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Wallet")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Perfil")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Funcionalidad en desarrollo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Perfil")
        }
    }
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("¡Bienvenido a SCAM-ER!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Protege tus activos cripto con la mejor tecnología de detección de fraudes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button("Comenzar") {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange)
                )
            }
            .padding()
            .navigationTitle("Onboarding")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(WalletConnectManager())
        .environmentObject(FraudDetectionService())
        .environmentObject(NotificationService())
        .environmentObject(AnalyticsService())
}
