//
//  ContentView.swift
//  AnalogClock
//
//  Created by valentine on 06.11.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var isDark = false
    @State var currentTime = Time(sec: 15, min: 10, hour: 10)
    var receiver = Timer.publish(every: 1, on: .current, in: .default)
        .autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Text("Analog Clock")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
                Appearance(isDark: $isDark)
                    .preferredColorScheme(isDark ? .dark : .light)
            }
            .padding()
            Spacer()
            clockFace(isDark: $isDark, currentTime: $currentTime)
            Text(getTime())
                .font(.system(size: 45))
                .fontWeight(.heavy)
                .padding()
            Spacer()
        }
        .onAppear(perform: {
            getTimeComponents()
        })
        .onReceive(receiver) { _ in
            getTimeComponents()
        }
    }
    private func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh mm a"
        return format.string(from: Date())
    }
    private func getTimeComponents() {
        let calender = Calendar.current
        let sec = calender.component(.second, from: Date())
        let min = calender.component(.minute, from: Date())
        let hour = calender.component(.hour, from: Date())
        withAnimation(Animation.linear(duration: 0.01)) {
            currentTime = Time(sec: sec, min: min, hour: hour)
        }
    }
}

struct clockFace: View {
    
    @Binding var isDark: Bool
    @Binding var currentTime: Time
    var width = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(isDark ? .white : .black))
                .opacity(0.1)
            ForEach(0..<60) { second in
                            Rectangle()
                                .fill(Color.primary)
                                .frame(width: 2, height: (second % 5) == 0 ? 15 : 5)
                                .offset(y: (width - 110) / 2)
                                .rotationEffect(.init(degrees: Double(second) * 6))
            }
            Rectangle()
                .fill(Color.primary)
                .frame(width: 2, height: (width - 180) / 2)
                .offset(y: -(width - 180) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
            
            Rectangle()
                .fill(Color.primary)
                .frame(width: 4, height: (width - 200) / 2)
                .offset(y: -(width - 200) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.min) * 6))
            
            Rectangle()
                .fill(Color.primary)
                .frame(width: 4.5, height: (width - 240) / 2)
                .offset(y: -(width - 240) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.hour) * 30))
            
            Circle()
                .fill(Color.primary)
                .frame(width: 15, height: 15)
        }
        .frame(width: width - 80, height: width - 80)
        Spacer()

    }
}
    
struct Time {
    var sec: Int
    var min: Int
    var hour: Int
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Appearance: View {
    
    @Binding var isDark: Bool
    var body: some View {
        Button(action: {isDark.toggle()}) {
            Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                .font(.system(size: 22))
                .foregroundColor(isDark ? .black : .white)
                .padding()
                .background(Color.primary)
                .clipShape(Circle())
        }
    }
}
