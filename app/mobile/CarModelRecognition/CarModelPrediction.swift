import Foundation
import SwiftUI

class CarModelPrediction: ObservableObject, Identifiable {
    let id = UUID()
    var predictedClass: String = ""
    var selectedImage: UIImage?
}
