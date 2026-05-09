//
//  SongsView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import SwiftUI

struct SongsView: View {
    
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            List {
                HStack(spacing: 16) {
                    Image("musical-note")
                        .resizable()
                        .frame(width: 52, height: 52)
                        .background(.red)
                        .clipShape(.rect(cornerRadius: 8))
                    LabeledContent {
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .tint(Color(.secondaryLabel))
                        .popover(isPresented: .constant(false)) {
                            NavigationLink("View Album") {
                                EmptyView()
                            }
                            .padding()
                            .presentationCompactAdaptation(.popover)
                        }
                        
                    } label: {
                        Text("Purple Rain")
                        Text("Prince")
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Songs")
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search")
        }
    }
}

#Preview {
    SongsView()
}
