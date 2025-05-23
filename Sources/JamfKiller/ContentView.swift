import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var jamfService = JamfKillerService()
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var glowOpacity: Double = 0.5
    @State private var particleOffset: CGFloat = 0
    @State private var isButtonHovered = false
    
    var body: some View {
        ZStack {
            // Dynamic background gradient
            LinearGradient(
                colors: jamfService.isUltraKillEnabled ? [
                    Color.red.opacity(0.8),
                    Color.orange.opacity(0.6),
                    Color.black,
                    Color.red.opacity(0.4)
                ] : [
                    Color.black,
                    Color.gray.opacity(0.3),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.5), value: jamfService.isUltraKillEnabled)
            
            // Animated particles
            ParticleSystem(isActive: jamfService.isUltraKillEnabled)
            
            VStack(spacing: 40) {
                // Header with animated skulls
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        Image(systemName: "skull.fill")
                            .font(.system(size: 45))
                            .foregroundColor(jamfService.isUltraKillEnabled ? .orange : .red)
                            .rotationEffect(.degrees(rotationAngle))
                            .scaleEffect(jamfService.isUltraKillEnabled ? 1.2 : 1.0)
                        
                        Text("JAMF KILLER")
                            .font(.custom("Menlo-Bold", size: 42))
                            .fontWeight(.black)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: jamfService.isUltraKillEnabled ? 
                                        [.cyan, .white, .yellow] : 
                                        [.white, .gray],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: jamfService.isUltraKillEnabled ? .cyan : .red, radius: 15)
                        
                        Image(systemName: "skull.fill")
                            .font(.system(size: 45))
                            .foregroundColor(jamfService.isUltraKillEnabled ? .orange : .red)
                            .rotationEffect(.degrees(-rotationAngle))
                            .scaleEffect(jamfService.isUltraKillEnabled ? 1.2 : 1.0)
                    }
                    .animation(.easeInOut(duration: 2.0), value: jamfService.isUltraKillEnabled)
                    
                    Text("ULTRA KILL MODE")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(jamfService.isUltraKillEnabled ? .orange : .gray)
                        .animation(.easeInOut(duration: 0.5), value: jamfService.isUltraKillEnabled)
                }
                
                // Status display
                StatusCard(
                    message: jamfService.statusMessage,
                    isActive: jamfService.isActive,
                    killCount: jamfService.killCount
                )
                
                // Giant toggle button
                UltraKillButton(
                    isEnabled: jamfService.isUltraKillEnabled,
                    pulseScale: pulseScale,
                    glowOpacity: glowOpacity,
                    isHovered: $isButtonHovered
                ) {
                    jamfService.toggleUltraKill()
                }
                
                // Info text
                Text(jamfService.isUltraKillEnabled ? 
                     "Monitoring every 0.1 seconds - Jamf processes eliminated instantly!" :
                     "Tap the button to activate ultra-fast Jamf elimination")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut(duration: 0.5), value: jamfService.isUltraKillEnabled)
            }
            .padding(50)
        }
        .frame(width: 600, height: 700)
        .onAppear {
            startAnimations()
            // Force app activation and window focus
            NSApp.activate(ignoringOtherApps: true)
            
            // Additional aggressive focus grabbing with delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NSApp.activate(ignoringOtherApps: true)
                // Make sure window is key and visible
                if let window = NSApp.keyWindow ?? NSApp.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    window.orderFrontRegardless()
                }
            }
        }
    }
    
    private func startAnimations() {
        // Pulse animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
        }
        
        // Rotation animation
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Glow animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowOpacity = 1.0
        }
    }
}

struct UltraKillButton: View {
    let isEnabled: Bool
    let pulseScale: CGFloat
    let glowOpacity: Double
    @Binding var isHovered: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var hoverRotation: Double = 0
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Button background with gradient
                Circle()
                    .fill(
                        RadialGradient(
                            colors: isEnabled ? [
                                Color.orange.opacity(isHovered ? 1.0 : 0.9),
                                Color.red.opacity(isHovered ? 0.9 : 0.8),
                                Color.black.opacity(0.6)
                            ] : [
                                Color.red.opacity(isHovered ? 0.8 : 0.7),
                                Color.red.opacity(isHovered ? 0.6 : 0.5),
                                Color.black.opacity(0.8)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .shadow(
                        color: isEnabled ? .orange : .red,
                        radius: isHovered ? 35 : (isPressed ? 40 : 25)
                    )
                    .scaleEffect(isPressed ? 0.95 : pulseScale)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    .animation(.easeInOut(duration: 0.3), value: isHovered)
                
                // Outer glow ring
                Circle()
                    .stroke(
                        isEnabled ? 
                            LinearGradient(
                                colors: isHovered ? [.yellow, .orange, .red] : [.orange, .yellow], 
                                startPoint: .topLeading, 
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: isHovered ? [.pink, .red, .orange] : [.red, .pink], 
                                startPoint: .topLeading, 
                                endPoint: .bottomTrailing
                            ),
                        lineWidth: isHovered ? 6 : 4
                    )
                    .frame(width: 180, height: 180)
                    .opacity(isHovered ? glowOpacity * 1.3 : glowOpacity)
                    .animation(.easeInOut(duration: 0.3), value: isHovered)
                
                // Inner content
                VStack(spacing: 8) {
                    Image(systemName: isEnabled ? "bolt.fill" : "power")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                        .rotationEffect(.degrees(hoverRotation))
                    
                    Text(isEnabled ? "ACTIVE" : "START")
                        .font(.custom("Menlo-Bold", size: 18))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                }
                .scaleEffect(isEnabled ? 1.1 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isEnabled)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isEnabled ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isEnabled)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.3)) {
                isHovered = hovering
                hoverRotation = hovering ? 15 : 0
            }
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct StatusCard: View {
    let message: String
    let isActive: Bool
    let killCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            // Status message
            HStack {
                Image(systemName: isActive ? "checkmark.circle.fill" : "info.circle.fill")
                    .foregroundColor(isActive ? .green : .blue)
                    .font(.title2)
                
                Text(message)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            
            // Kill count
            if killCount > 0 {
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.orange)
                    Text("Eliminated: \(killCount) processes")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .stroke(
                    LinearGradient(
                        colors: isActive ? [.green, .blue] : [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
        .animation(.easeInOut(duration: 0.3), value: message)
        .animation(.easeInOut(duration: 0.3), value: killCount)
    }
}

struct ParticleSystem: View {
    let isActive: Bool
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            generateParticles()
            animateParticles()
        }
        .onChange(of: isActive) {
            updateParticleIntensity()
        }
    }
    
    private func generateParticles() {
        particles = (0..<(isActive ? 30 : 15)).map { _ in
            Particle(
                id: UUID(),
                position: CGPoint(x: CGFloat.random(in: 0...600), y: CGFloat.random(in: 0...700)),
                size: CGFloat.random(in: 1...3),
                color: isActive ? 
                    [Color.orange, Color.red, Color.yellow].randomElement()! : 
                    Color.red.opacity(0.3),
                opacity: Double.random(in: 0.2...0.8)
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(.linear(duration: 15.0).repeatForever(autoreverses: false)) {
            for i in 0..<particles.count {
                particles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...600),
                    y: CGFloat.random(in: 0...700)
                )
            }
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            for i in 0..<particles.count {
                particles[i].opacity = Double.random(in: 0.1...0.9)
            }
        }
    }
    
    private func updateParticleIntensity() {
        generateParticles()
        animateParticles()
    }
}

struct Particle {
    let id: UUID
    var position: CGPoint
    let size: CGFloat
    let color: Color
    var opacity: Double
}

#Preview {
    ContentView()
} 