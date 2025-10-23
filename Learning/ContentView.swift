//
//  ContentView.swift
//  Learning
//
//  Created by Noura Faiz Alfaiz on 21/10/2025.
//

import SwiftUI

// MARK: - Palette
private enum Palette {
    static let bg        = Color.black
    static let textMain  = Color.white
    static let textSub   = Color.white.opacity(0.72)
    static let line      = Color.white.opacity(0.12)
    static let glassTint = Color.white.opacity(0.06)
    static let pillStroke = Color.white.opacity(0.20)
    static let texthide = Color.white.opacity(0.22)

    static let orangeTop = Color(red: 0.99, green: 0.55, blue: 0.20)
    static let orangeBot = Color(red: 0.89, green: 0.36, blue: 0.12)
    static let redCore   = Color(red: 0.95, green: 0.12, blue: 0.10) // وهج أحمر للوسط
}

private enum DurationOption: String, CaseIterable, Identifiable {
    case week = "Week", month = "Month", year = "Year"
    var id: String { rawValue }
}

struct ContentView: View {
    @State private var topic: String = ""                // placeholder بدل نص ثابت
    @FocusState private var topicFocused: Bool
    @State private var duration: DurationOption = .week

    var body: some View {
        ZStack {
            Palette.bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 26) {

                // MARK: Logo circle (109x109) with red core glow
                HStack { Spacer()
                    GlassCircle(size: 109,
                                glowOffset: CGSize(width: 3, height: 4),
                                opacity: 0.220)
                    .overlay(
                        // وهج أحمر/برتقالي من الوسط
                        RadialGradient(
                            colors: [
                                Palette.redCore.opacity(0.05),
                                Palette.orangeBot.opacity(0.87),
                                .clear
                            ],
                            center: .center,
                            startRadius: 53, endRadius: 72
                        )
                        .blendMode(.plusLighter)
                        .clipShape(Circle())
                    )
                    .overlay(
                        Image(systemName: "flame.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(Palette.orangeTop)
                    )
                    Spacer()
                }
                .padding(.top, 40)

                // MARK: Titles
                Text("Hello Learner")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(Palette.textMain)

                Text("This app will help you learn everyday!")
                    .font(.system(size: 17))
                    .foregroundColor(Palette.textSub)

                // MARK: I want to learn
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Palette.textMain)

                    ZStack(alignment: .leading) {
                        // Placeholder يختفي تلقائيًا
                        if topic.isEmpty {
                            Text("Swift")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Palette.texthide)
                                .padding(.vertical, 6)
                                .allowsHitTesting(false)
                        }
                        TextField("", text: $topic)
                            .focused($topicFocused)
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                            .foregroundColor(Palette.textMain)
                            .font(.system(size: 19, weight: .semibold))
                            .padding(.vertical, 8)
                    }

                    Rectangle()
                        .fill(Palette.line)
                        .frame(height: 1)
                }

                // MARK: Duration pills
                VStack(alignment: .leading, spacing: 18) {
                    Text("I want to learn it in a")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Palette.textSub)

                    HStack(spacing: 8) {
                        ForEach(DurationOption.allCases) { opt in
                            DurationPill(
                                title: opt.rawValue,
                                isSelected: duration == opt
                            )
                            .onTapGesture {
                                if duration != opt {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    duration = opt
                                }
                            }
                        }
                    }
                }

                Spacer()

                // MARK: Start learning (narrower + centered)
                HStack {
                    Spacer()
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        print("Start learning \(topic.isEmpty ? "Swift" : topic) for a \(duration.rawValue)")
                    } label: {
                        Text("Start learning")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(minWidth: 0, maxWidth: 360)   // أضيق من عرض الشاشة
                            .background(
                                LinearGradient(colors: [Palette.orangeTop, Palette.orangeBot],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1)
                            )
                            .shadow(color: Palette.orangeTop.opacity(0.35), radius: 22, y: 10)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 10) // هوامش أوسع
        }
        .preferredColorScheme(.dark)
        .onAppear { topicFocused = false }
    }
}

// MARK: - Duration Pill (selected orange / unselected glass gray)
private struct DurationPill: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Group {
            if isSelected {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 109, height: 58)
                    .background(
                        LinearGradient(colors: [Palette.orangeTop, Palette.orangeBot],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1))
                    .shadow(color: Palette.orangeTop.opacity(0.35), radius: 14, y: 8)
            } else {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Palette.textMain.opacity(0.9))
                    .frame(width: 109, height: 58)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .background(Palette.glassTint.clipShape(Capsule()))
                    )
                    .overlay(Capsule().stroke(Palette.pillStroke, lineWidth: 1))
                    .shadow(color: .black.opacity(0.35), radius: 10, y: 6)
            }
        }
        .animation(.spring(response: 0.22, dampingFraction: 0.9), value: isSelected)
        .contentShape(Capsule()) // يضمن اللمس على كامل الكبسولة
    }
}

// MARK: - Glass circle with inset glow
private struct GlassCircle: View {
    let size: CGFloat
    let glowOffset: CGSize
    let opacity: Double

    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .background(
                Color.white.opacity(0.04).clipShape(Circle())
            )
            .frame(width: size, height: size)
            .opacity(opacity)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(1.0), lineWidth: 0.25)
                    .blur(radius: 2)
                    .offset(glowOffset) // 2px, 2px
                    .mask(
                        Circle().fill(
                            LinearGradient(colors: [.black, .clear],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                    )
            )
            .overlay(
                Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.45), radius: 10, y: 4)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .previewDevice("iPhone 16 Pro")
}
