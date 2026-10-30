//
//  SharingView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/26/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import Combine

struct SharingView: View {
    private static let context = CIContext()
    let questions: [Question]
    let answers: [Answer]
    let teamNotes: [TeamNotes]
    @State private var qrIndex = 0
    
    let frameDuration = 0.3
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: frameDuration, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        let payload = SharingContainer(questions: questions, answers: answers, teamNotes: teamNotes)
        VStack {
            if let qrImages = SharingView.generate(from: payload) {
                Text("\((qrIndex % qrImages.count)) / \(qrImages.count)")
                Image(uiImage: qrImages[qrIndex % qrImages.count])
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .padding()
//                Button("-->") {
//                    qrIndex += 1
//                }
            }
        }
        .onReceive(timer) { _ in
            qrIndex += 1
        }
    }
    
    static func generate(from payload: SharingContainer) -> [UIImage]? {
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(payload) else { return nil }

        var chunks: [ChunkContainer] = []
        var offset = 0
        let totalBytes = jsonData.count
        let chunkCount = Int(ceil(Double(totalBytes) / 500))
        var index = 0
        
        while offset < totalBytes {
            let chunkSize = min(500, totalBytes - offset)
            
            let chunk = jsonData.subdata(in: offset..<(offset + chunkSize))
            chunks.append(ChunkContainer(num: index, total: chunkCount, chunk: chunk))
            
            offset += chunkSize
            index += 1
        }
        
        var output: [UIImage] = []
        
        for chunk in chunks {
            guard let chunkJsonData = try? encoder.encode(chunk) else { return nil }
            
            let filter = CIFilter.qrCodeGenerator()
            filter.message = chunkJsonData
            filter.correctionLevel = "L"
            
            guard let outputImage = filter.outputImage else { return nil }
            let scale = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: scale)
            
            guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
            
            output.append(UIImage(cgImage: cgImage))
        }
        return output
    }
}

#Preview {
    SharingView(questions: [], answers: [Answer(teamNumber: 9990, answers: [String(repeating: "the quick brown fox jumps over the lazy dog ", count: 50)])], teamNotes: [])
}
