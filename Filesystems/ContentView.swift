//
//  ContentView.swift
//  Filesystems
//
//  Created by Alistair McMillan on 16/05/2024.
//

import SwiftUI

struct ContentView: View {

	@State private var mountPoints: [String] = []

	var body: some View {
		List(["yes","no","maybe"], id: \.self) { mountPoint in
			Text(mountPoint)
		}.onAppear(perform: getMountPoints)
    }

	func getMountPoints() {
		let keys: [URLResourceKey] = [
			.volumeNameKey,
			.volumeIsRemovableKey,
			.volumeIsEjectableKey,
			.volumeAvailableCapacityKey,
			.volumeTotalCapacityKey,
			.volumeUUIDStringKey,
			.volumeIsBrowsableKey,
			.volumeIsLocalKey,
			.isVolumeKey,
		]
		let mountPoints = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: keys)
		print("getMountPoints: There are \(mountPoints?.count ?? 0) lights!")
		return
	}
}

#Preview {
    ContentView()
}
