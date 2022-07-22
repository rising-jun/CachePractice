//
//  DoodleRepository.swift
//  DiskCache
//
//  Created by 김동준 on 2022/07/21.
//

import Foundation

final class DoodleRepository {
    
    func bind(updateImageData: ((Data) -> Void)?) {
        self.updateImageData = updateImageData
    }
    
    private var updateImageData: ((Data) -> Void)?
    
    private func fetchDoodleJson() async throws -> [DoodleDTO]? {
        guard let url = URL(string: "https://public.codesquad.kr/jk/doodle.json") else { throw NetworkError.invailUrl }
        let result = try await URLSession.shared.data(from: url)
        return try jsonDecode(data: result.0, decodeType: [DoodleDTO].self)
    }
    
    func jsonDecode<T: Decodable>(data: Data, decodeType: T.Type) throws -> T {
        guard let decodeEntity = try? JSONDecoder().decode(decodeType.self, from: data) else {
            throw NetworkError.parsingError
        }
        return decodeEntity
    }
    
    func fetchImages() async throws {
        guard let doodles = try await fetchDoodleJson() else { return }
        let urls = doodles.map { URL(string: $0.image) }.compactMap { $0 }
        for url in urls {
            Task.init {
                if let updateImageData = updateImageData {
                    let data = try await ImageManager.shared.fetchImage(from: url)
                    updateImageData(data)
                }
            }
        }
    }
}
    
enum NetworkError: Error{
    case invailUrl
    case parsingError
}
