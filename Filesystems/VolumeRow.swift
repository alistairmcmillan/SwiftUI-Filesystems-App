//
//  VolumeRow.swift
//  Filesystems
//
//  Created by Alistair McMillan on 19/05/2024.
//

import SwiftUI

struct VolumeRow: View {
	var name: String
	var val: String

    var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(val).font(.title3)
				Text(name).foregroundStyle(.secondary)
			}
		}.padding(.vertical, 8)
    }
}

#Preview {
	VolumeRow(name: "Name", val: "/home/alistair")
}
