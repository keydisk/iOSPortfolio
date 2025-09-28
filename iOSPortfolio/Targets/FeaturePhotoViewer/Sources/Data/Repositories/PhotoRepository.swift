//
//  PhotoRepository.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import Photos
import UIKit

public protocol PhotoRepository {

    func getPhotoAssets(pageNo: Int) async -> [PhotoEntity]
    func getOriginPhoto(asset: PHAsset) async -> UIImage?
}

public class PhotoRepositoryImpl: PhotoRepository {

    private let imageManager = PHImageManager.default()
    /// 페이지 크기
    private let pageSize: Int = 20

    public init() {
        
    }

    private func loadImage(_ asset: PHAsset) async -> PhotoEntity? {

        return await withCheckedContinuation {[weak self] cont in
            let options = PHImageRequestOptions()

            options.deliveryMode = .opportunistic
            options.resizeMode   = .fast

            options.isNetworkAccessAllowed = false

            let targetSize = CGSize(width: 300, height: 300)

            self?.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { uiImage, metaInfo in

                guard let uiImage = uiImage else {

                    cont.resume(returning: nil)
                    return
                }

                cont.resume(returning: PhotoEntity(id: asset.localIdentifier,
                                                   image: uiImage,
                                                   photoLocation: asset.location?.coordinate,
                                                   imageSize: uiImage.size,
                                                   createDate: asset.creationDate,
                                                   mediaType: asset.mediaType) )
            }
        }
    }

    public func getOriginPhoto(asset: PHAsset) async -> UIImage? {

        return await withCheckedContinuation {[weak self] cont in
            let options = PHImageRequestOptions()

            options.deliveryMode = .opportunistic

            options.isNetworkAccessAllowed = true

            self?.imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { uiImage, metaInfo in

                cont.resume(returning: uiImage )
            }
        }
    }

    public func getPhotoAssets(pageNo: Int) async -> [PhotoEntity] {

        let pageSize = pageSize

        return await withTaskGroup(of: PhotoEntity?.self) {[weak self] group in

            let fetchOptions = PHFetchOptions()
            // 최신 사진이 먼저 오도록 정렬
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.predicate = NSPredicate(
                format: "mediaType == %d || mediaType == %d",
                PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue )

            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)

            let startIndex = (pageNo - 1) * pageSize
            let endIndex   = min(startIndex + pageSize, fetchResult.count)

            let indexSet = IndexSet(integersIn: startIndex..<endIndex)

            let assets: [PHAsset] = fetchResult.objects(at: indexSet)

            for asset in assets {

                group.addTask {
                    await self?.loadImage(asset)
                }
            }

            // group 내의 모든 작업이 완료될 때까지 기다린 후, 배열로 반환합니다.
            return await group.compactMap { $0 }.reduce(into: []) { $0.append($1) }
        }
    }
}
