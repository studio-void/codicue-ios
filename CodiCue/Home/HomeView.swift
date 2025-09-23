//
//  HomeView.swift
//  CodiCue
//
//  Created by 임정훈 on 9/21/25.
//

import SwiftUI
import SwiftyJSON
import VoidUtilities

struct HomeView: View {
    @State var condition: String = ""
    @State var isLoading: Bool = true
    @State var stylists: [StylistInfo] = []
    var body: some View {
        VStack{
            TextField("상황을 알려주시면 스타일링해드립니다!", text: $condition)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom,8)
            if condition != "" {
                ScrollView(.horizontal) {
                    HStack{
                        ConditionChipView(label: "MOOD")
                        ConditionChipView(label: "OOTD")
                    }
                }
                .padding(.bottom,8)
            }
            ScrollView(.horizontal) {
                if stylists.isEmpty || isLoading {
                    HStack{
                        Spacer ()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    HStack(spacing: 24){
                        ForEach(stylists) { stylist in
                            HomeStylistCardView(imageURL: URL(string: stylist.profileImageUrl), name: stylist.name, rating: stylist.rating, descriptions: stylist.career, isVerified: stylist.isVerified)
                        }
                    }
                    .padding()
                }
            }
            .background(isLoading ? Color.clear : Color("lightPink"))
            .onAppear(perform: fetchStylists)
            Spacer()
        }
    }
    
    func fetchStylists() {
        Task { @MainActor in
            isLoading = true
            let (isSuccess, jsonOpt) = await sendGetRequest(endpoint: "stylists")
            defer { isLoading = false }
            guard isSuccess, let json = jsonOpt else {
                return
            }

            // Expecting an array of stylist objects
            let array = json.arrayValue

            // Temporary container to avoid partial updates
            var parsed: [StylistInfo] = []

            // Date formatter if server returns ISO8601 strings
            let iso = ISO8601DateFormatter()

            for item in array {
                // Extract typed values using SwiftyJSON accessors
                let id = item["id"].stringValue
                let name = item["name"].stringValue
                let rating = item["rating"].doubleValue
                let reviewCount = item["reviewCount"].intValue
                let isVerified = item["isVerified"].boolValue
                let introduction = item["introduction"].stringValue
                let career = item["career"].arrayObject as? [String] ?? []
                let profileImageUrl = item["profileImageUrl"].stringValue
                let specialtyStyles = item["specialtyStyles"].arrayObject as? [String] ?? []

                // Parse dates from either timestamp or ISO8601 string
                var createdAt: Date = Date()
                var updatedAt: Date = Date()
                if let createdMillis = item["createdAt"].double { // milliseconds since epoch
                    createdAt = Date(timeIntervalSince1970: createdMillis / 1000.0)
                } else if let createdStr = item["createdAt"].string, let date = iso.date(from: createdStr) {
                    createdAt = date
                }
                if let updatedMillis = item["updatedAt"].double {
                    updatedAt = Date(timeIntervalSince1970: updatedMillis / 1000.0)
                } else if let updatedStr = item["updatedAt"].string, let date = iso.date(from: updatedStr) {
                    updatedAt = date
                }

                // Construct your model. If your array is [Stylist], ensure you initialize Stylist. If it's [StylistInfo], change the state var accordingly.
                // Here we assume "Stylist" has an initializer matching these fields.
                let stylist = StylistInfo(
                    id: Int(id) ?? 0,
                    name: name,
                    rating: rating,
                    reviewCount: reviewCount,
                    isVerified: isVerified,
                    introduction: introduction,
                    career: career,
                    profileImageUrl: profileImageUrl,
                    specialtyStyles: specialtyStyles,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
                parsed.append(stylist)
            }

            stylists = parsed
        }
    }
}

struct ConditionChipView: View {
    var label: String = "MOOD"
    var body: some View {
        Text("#\(label)")
            .padding(8)
            .foregroundStyle(Color("primaryColor"))
            .background(Color("primaryColor").opacity(0.2))
            .clipShape(Capsule())
    }
}

#Preview {
    StructureView()
}
