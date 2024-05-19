//
//  ContentView.swift
//  Filesystems
//
//  Created by Alistair McMillan on 16/05/2024.
//

import SwiftUI

struct ContentView: View {

	@State private var mountPoints: [URL] = []

	var body: some View {
		NavigationStack {
			Section {
				List(mountPoints, id: \.self) { mountPoint in
					Text(mountPoint.path)
				}.onAppear(perform: getMountPoints)
			}.navigationTitle("Volumes")
		}
    }

	func mountPoints(_ statBufs: UnsafePointer<statfs>, _ fsCount: Int) -> [URL] {
		var urls: [URL] = []

		for fsIndex in 0..<fsCount {
			var fs = statBufs.advanced(by: fsIndex).pointee

			let mountPoint = withUnsafePointer(to: &fs.f_mntonname.0) { (ptr: UnsafePointer<Int8>) -> String in
				return FileManager.default.string(withFileSystemRepresentation: ptr, length: strlen(ptr))
			}
			urls.append(URL(fileURLWithPath: mountPoint, isDirectory: true))
		}
		return urls
	}

	func getMountPoints() {
		var statBufPtr: UnsafeMutablePointer<statfs>?
		let fsCount = getmntinfo_r_np(&statBufPtr, MNT_WAIT)
		guard let statBuf = statBufPtr, fsCount > 0 else {
			return
		}
		mountPoints = mountPoints(statBuf, Int(fsCount))
		print("getMountPoints: There are \(fsCount) lights!")
		return
	}
}

#Preview {
    ContentView()
}
