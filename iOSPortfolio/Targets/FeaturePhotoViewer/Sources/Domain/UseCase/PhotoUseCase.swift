//
//  PhotoUseCase.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import Photos
import UIKit

public protocol PhotoUseCase {

    func loadingPhotoAsset(pageNo: Int) async throws -> [PhotoEntity]
    func loadOriginPhotoAsset(asset: PHAsset) async throws -> UIImage?
}

public class PhotoUseCaseImpl: PhotoUseCase {

    let photoRepository: PhotoRepository

    public init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }

    private func requestAuthorization() async -> PHAuthorizationStatus {

        return await withCheckedContinuation { continuation in

            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in

                continuation.resume(returning: status)
            }
        }
    }

    public func loadOriginPhotoAsset(asset: PHAsset) async throws -> UIImage? {
        await photoRepository.getOriginPhoto(asset: asset)
    }

    public func loadingPhotoAsset(pageNo: Int) async throws -> [PhotoEntity] {

        let auth = await requestAuthorization()

        switch auth {
        case .denied, .restricted:
            throw NSError(domain: "사진첩 권한 제한", code: 800)
        case .limited:
            throw NSError(domain: "사진첩 권한 전체 허용 해주세요.", code: 810)
        case .notDetermined:
            throw NSError(domain: "사진첩 권한 전체 허용 해주세요.", code: 820)
        case .authorized :
            return await photoRepository.getPhotoAssets(pageNo: pageNo)
        @unknown default:
            throw NSError(domain: "알수 없음", code: 999)
        }
    }
}
