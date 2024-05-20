//
//  VolumeDetail.swift
//  Filesystems
//
//  Created by Alistair McMillan on 19/05/2024.
//

import SwiftUI

struct VolumeDetail: View {
	var volume: URL
	
	@State private var type: UInt32 = 0
	@State private var subtype: UInt32 = 0
	@State private var typeName: String = ""
	@State private var mountFrom: String = ""
	@State private var mountOn: String = ""
	@State private var blockSize: UInt32 = 0
	@State private var freeBlocks: UInt64 = 0
	@State private var blockCount: UInt64 = 0
	@State private var freeNodes: UInt64 = 0
	@State private var nodeCount: UInt64 = 0
	@State private var flags: UInt32 = 0
	@State private var flagsText: String = ""

	var body: some View {
		VStack(alignment: .leading) {
			List {
				VolumeRow(name: "Mount from", val: mountFrom)
				VolumeRow(name: "Mount on", val: mountOn)
				VolumeRow(name: "Type name", val: typeName)
				VolumeRow(name: "Number of blocks", val: blockCount.formatted())
				VolumeRow(name: "Number of free blocks", val: freeBlocks.formatted())
				VolumeRow(name: "Block size (bytes)", val: blockSize.formatted())
				VolumeRow(name: "Number of file nodes", val: nodeCount.formatted())
				VolumeRow(name: "Number of free file nodes", val: freeNodes.formatted())
				VolumeRow(name: "Flags", val: flagsText)
			}
		}.onAppear(perform: getData)
	}
	
	func parseFlags(flags: UInt32) {
		print(String(flags, radix: 2))
		if(flags & 0b00000000000000000000000000000001 == 1) {
			flagsText = "read-only"
		} else {
			flagsText = "read-write"
		}
	}

	func getVolumeInfo(volume: URL) -> statfs {
		let statsptr = UnsafeMutablePointer<statfs>.allocate(capacity: 1)
		if (statfs(volume.path, statsptr) != 0) {
			print("getVolumeInfo failed")
		}
		let res = Array(UnsafeBufferPointer(start: statsptr, count: 1))
		statsptr.deallocate()
		return res[0]
	}

	func getData() {
		let infos = getVolumeInfo(volume: volume)

		type = infos.f_type
		subtype = infos.f_fssubtype
		typeName = String(cString: withUnsafeBytes(of: infos.f_fstypename) { ptr in [UInt8](ptr) })
		mountFrom = String(cString: withUnsafeBytes(of: infos.f_mntfromname) { ptr in [UInt8](ptr) })
		mountOn = String(cString: withUnsafeBytes(of: infos.f_mntonname) { ptr in [UInt8](ptr) })
		blockSize = infos.f_bsize
		freeBlocks = infos.f_bfree
		blockCount = infos.f_blocks
		nodeCount = infos.f_files
		freeNodes = infos.f_ffree
		flags = infos.f_flags
		parseFlags(flags: flags)

		return
	}

}

#Preview {
	VolumeDetail(volume: URL(string: "/")!)
}
