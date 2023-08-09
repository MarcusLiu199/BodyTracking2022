//
//  BodySkeleton.swift
//  BodyTracking2022
//
//  Created by 柳铭坤 on 2023/8/9.
//

import Foundation
import RealityKit
import ARKit

class BodySkeleton: Entity {
    var joints: [String: Entity] = [:]
    var bones: [String: Entity] = [:]
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // Create a sphere entity for every single joint in our skeleton
    private func createJoint(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
    
    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointFromName)),
              let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName))
        else {
            return nil
        }
        
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        let jointFromEntityOffsetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3) // relative to root (i.e. hipjoint)
        let jointFromEntityPosition = jointFromEntityOffsetFromRoot + rootPosition // relative to world reference frame
        
        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3) // (i.e. hipjoint)
        let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition // relative to world reference frame
        
        let fromJoint = SkeletonJoint(name: bone.jointFromName, position: jointFromEntityPosition)
        let toJoint = SkeletonJoint(name: bone.jointToName, position: jointToEntityPosition)
        
        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }
    
    private func createBoneEntity(for skeletonBone: SkeletonBone, diameter: Float = 0.04, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, skeletonBone.length], cornerRadius: diameter / 2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}

