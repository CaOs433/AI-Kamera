//
//  ModelListView.swift
//  AI-Kamera
//
//  Created by Oskari Saarinen on 4.12.2022.
//

import SwiftUI
import CoreData

struct ModelListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(COREML_MODELS) { model in
                    NavigationLink {
                        // Content
                        HostedCameraViewController(modelFileName: model.id)
                    } label: {
                        // List Label
                        Text(model.name)
                    }
                }
            }
            Text("Select an item")
        }
    }
    
}

struct ModelListView_Previews: PreviewProvider {
    static var previews: some View {
        ModelListView()
    }
}
