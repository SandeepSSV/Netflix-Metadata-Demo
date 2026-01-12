//
//  ContentView.swift
//  TelepartyDemoApp
//
//  Created by Sandeep S on 11/01/26.
//

import SwiftUI

struct NFDemoView: View {
    
    @StateObject var viewModel = MetaDataViewModel()
    @State private var webViewLoading = true
    
    var body: some View {
        VStack {
            
            // Web view mode only works on iPad. Using with simulator causes WebKit to crash due to DRM Fairplay concerns, so needs to be tested on a real device. To bypass this, switch mode to direct fetch and back to web view and meta data will be dynamically fetched even on simulator but only once.
            
            Button(viewModel.shouldUseWebView ? "Switch to Direct Fetch" : "Switch Mode to Dynamic Web View") {
                viewModel.shouldUseWebView.toggle()
            }
            .padding(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            }
            
            if viewModel.shouldUseWebView {
                ZStack {
                    NFWebView(url: "https://netflix.com", onURLChange: { string in
                        print(string)
                        if string.contains("/watch") {
                            let id = string.components(separatedBy: "?").first?.components(separatedBy: "/").last ?? ""
                            if !id.isEmpty {
                                viewModel.videoMetadata = nil
                                viewModel.fetchVideoMetadata(videoId: String(id))
                            }
                        }
                    }, isLoading: $webViewLoading)
                    
                    if webViewLoading {
                            ZStack {
                                Color.black.opacity(0.2)
                                    .ignoresSafeArea()

                                ProgressView("Loading…")
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground))
                                    )
                            }
                        }
                }
            } else {
                TextField("Enter Video ID", text: $viewModel.videoId)
                    .padding()
                    .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding()
                   
                
                Button("Fetch Metadata") {
                    if viewModel.lastFetchedId == viewModel.videoId {
                        return
                    }
                    viewModel.videoMetadata = nil
                    viewModel.fetchVideoMetadata(videoId: viewModel.videoId)
                }
                .padding(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                }
            }
            if viewModel.videoMetadata != nil {
                ScrollView {
                    
                    AsyncImage(url: URL(string: viewModel.videoMetadata?.video.artwork.first?.url ?? ""), scale: 1, content: { image in
                        image.resizable()
                    }, placeholder: {
                        ProgressView()
                    })
                        .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) * Double(viewModel.videoMetadata?.video.artwork.first?.h ?? 1) / Double(viewModel.videoMetadata?.video.artwork.first?.w ?? 1))
                        .cornerRadius(8)
                        .scaledToFill()
                        .padding()
                        
                    
                    Text("Title: " + (viewModel.videoMetadata?.video.title ?? "No Title"))
                        .font(.title)
                        .padding()
                    Text("Synopsis: " + (viewModel.videoMetadata?.video.synopsis ?? "No Synopsis"))
                        .font(.title2)
                        .padding()
                    Text("Rating: \(viewModel.videoMetadata?.video.rating ?? "N/A")")
                        .font(.headline)
                    if viewModel.videoMetadata?.video.type == "show" {
                        Text("Seasons: \(viewModel.videoMetadata?.video.seasons?.count ?? 0)")
                            .font(.headline)
                        ForEach(viewModel.videoMetadata?.video.seasons ?? [], id: \.id) { season in
                            Text("Season \(season.seq): \(season.episodes.count) episodes")
                        }
                    } else {
                        Text("Run Time: \(viewModel.videoMetadata?.video.runTime ?? "N/A")")
                            .font(.headline)
                    }
                    Text("Release Date: \(viewModel.videoMetadata?.video.releaseDate ?? "N/A")")
                        .font(.headline)
                    
                        
                }
            } else {
                if viewModel.isLoading {
                    ProgressView("Loading metadata…")
                }

                if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                }
            }
                
        }
        .padding()
    }
}

#Preview {
    NFDemoView()
}
