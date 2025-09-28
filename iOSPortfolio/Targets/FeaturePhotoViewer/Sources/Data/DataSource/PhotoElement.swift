//
//  DataSource.swift
//  FeaturePhotoViewer
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import Foundation
import Photos


struct PhotoElement {
    
    let id: String
    let asset: PHAsset

    let imageSize: CGSize
    let createDate: Date?
    let mediaType: PHAssetMediaType
}
