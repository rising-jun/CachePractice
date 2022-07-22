//
//  File.swift
//  DiskCache
//
//  Created by 김동준 on 2022/07/22.
//

import Foundation

final class DoodleUsecase {
    
    private let repository = DoodleRepository()
    
    var updateImageData: ((Data) -> ())?
    var updateDoodleCount: ((Int) -> ())?
    
    func requestDoodleJson() {
        repository.bind(updateImageData: updateImageData)
        Task.init {
            try await repository.fetchImages()
        }
    }
}
