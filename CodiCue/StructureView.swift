//
//  StructureView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/5/25.
//

import SwiftUI
import VoidUtilities

struct StructureView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        VStack {
            HeaderView()
                .padding(.bottom)
            Spacer()
            // Content area switching based on selectedTab
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .stylist:
                    StylistMainView()
                case .closet:
                    ClosetPlaceholder()
                case .mypage:
                    MyPageMainView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
        .padding()
    }
}

struct HeaderView: View {
    @AppStorage("point") var point = 0
    var body: some View {
        HStack{
            Image("logoType")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)
            Spacer()
            Image("coins")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)
            Text("\(point)P")
                .fontWeight(.semibold)
                .font(.headline)
        }
    }
}

enum Tab: String, CaseIterable, Identifiable {
    case home
    case stylist
    case closet
    case mypage
    
    var id: String { self.rawValue }
    
    var filledIconName: String {
        switch self {
        case .home: return "house.fill"
        case .stylist: return "sparkles"
        case .closet: return "square.righthalf.filled"
        case .mypage: return "person.fill"
        }
    }
    
    var unfilledIconName: String {
        switch self {
        case .home: return "house"
        case .stylist: return "sparkles"
        case .closet: return "square.split.2x1"
        case .mypage: return "person"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach(Array(Tab.allCases.enumerated()), id: \.element.id) { index, tab in
                VStack(spacing: 4) {
                    Image(systemName: selectedTab == tab ? tab.filledIconName : tab.unfilledIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 22)
                        .foregroundColor(selectedTab == tab ? Color("primaryColor") : .primary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTab = tab
                }
                if index != Tab.allCases.count - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct HomePlaceholder: View { var body: some View { Text("Home").font(.largeTitle) } }
struct StylistPlaceholder: View { var body: some View { Text("Stylist").font(.largeTitle) } }
struct ClosetPlaceholder: View { var body: some View { Text("Closet").font(.largeTitle) } }
struct MyPagePlaceholder: View { var body: some View { Text("My Page").font(.largeTitle) } }


#Preview {
    StructureView()
}
