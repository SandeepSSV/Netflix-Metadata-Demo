//
//  NetflixAPIProtocol.swift
//  TelepartyDemoApp
//
//  Created by Sandeep S on 12/01/26.
//


import Foundation

protocol NetflixAPIProtocol {
    func fetchMetadata(videoId: String) async throws -> VideoMetadata
}

final class NetflixAPI: NetflixAPIProtocol {

    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func fetchMetadata(videoId: String) async throws -> VideoMetadata {
        guard let url = URL(
            string: "https://www.netflix.com/nq/website/memberapi/release/metadata" +
                    "?movieid=\(videoId)&imageFormat=png&withSize=true&materialize=true"
        ) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // ⚠️ DEMO ONLY — move to secure storage / config

#warning("Hardcoded for demo purpose, To get an actual cookie, inspect when logging into Netflix with credentials and Cookie is in the header of most post login APIs")
        
        request.setValue(
            "netflix-sans-normal-3-loaded=true; netflix-sans-bold-3-loaded=true; nfvdid=BQFmAAEBEIqat6jzfuSSEnE0jb_XCy5g2De7YfhBUkQ4yIASTE-r2uTdoKxvZVboN3wmW5JQuqNIPJ30KdufJG3-iL-BtWjxXq5bhvFGy-dZvORHI_RyldPGgFbbRqn26qoz2P_PA7DpaYvL_wvbL7ySaX57XpIK; profilesNewSession=0; flwssn=296fdbe9-5568-4c4f-8cf0-88b756cf0719; gsid=0c2079d3-29d1-4e13-bdce-d649f1068e3e; SecureNetflixId=v%3D3%26mac%3DAQEAEQABABTq8YGAVrv7hyZDj0zIyKANhQHew6Z-qio.%26dt%3D1768119253412; NetflixId=v%3D3%26ct%3DBgjHlOvcAxL4An2gx2GswM1sXXzUY5bU7_ymxs9lGQ_cnRGZYP4yI6uaPgLt7AVgoRBJH-_LdvqiulN2B1nTYl8mHqyvKMrRXnBP7p4uvQf89SUJwEUVPG-SS1zn-U7_cBqPjibL_A1CJwnkm_AWJQtp8SqYxqFFUhkfnO7ffcX7lHhIaEAuSgOF6QtVUMv7wVqsvwQ6BIw8SlP6aCf5RBDPMsSwzNZ4_qDvmV8HlDt_CP3a-N_8L_B_Hx_dWTEleUMmiDHiNv0G1uVMRc-nSU39r4pVcfdoVZmL_vm60AQt8VJgcF2LdJye0jsqZGPmJsKw0kZSxmw18K3FL4HSNGvzLFo-gdyg7gZFTD-5rBVRi8uDKoBzhlV0qumYXnO2c17XliEWYUxDiDr0fUVlz1VxSWWH0zlFgPkcdwwwza3wxAiXbL3Zq4APz3ExxrtbdcDKzzJgvCzCXV9SwS60nXRPtGtaAfVXW0fRgcnF_OStztOx2YQKErP3ZrVasSozYPcYBiIOCgzYt-VIzrL8meQvwd8.%26pg%3DDNIBULCJT5FZRHRFIXAVHUZ2C4%26ch%3DAQEAEAABABQbDSezj8ks3vWsIolm18nhaSuI_PXsl6s.; OptanonConsent=isGpcEnabled=0&datestamp=Sun+Jan+11+2026+13%3A44%3A16+GMT%2B0530+(India+Standard+Time)&version=202512.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=a93c40ee-06e0-4b22-8b1f-e2bfc8c5da51&interactionCount=1&isAnonUser=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0002%3A1%2CC0003%3A1%2CC0004%3A1&AwaitingReconsent=false",
            forHTTPHeaderField: "Cookie"
        )

        request.setValue(
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15",
            forHTTPHeaderField: "User-Agent"
        )

        return try await client.request(request)
    }
}
