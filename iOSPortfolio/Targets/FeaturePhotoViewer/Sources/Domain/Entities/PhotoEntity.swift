//
//  Entities.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import CoreLocation
import UIKit
import Photos

public struct PhotoEntity: Identifiable {

    public let id: String
    let image: UIImage?
    let photoLocation: CLLocationCoordinate2D?

    let imageSize: CGSize
    let createDate: Date?
    let mediaType: PHAssetMediaType
}
