import Foundation
import SwiftUI

class CarModelPrediction: ObservableObject {
    @Published var predictedClass: String = ""
    @Published var selectedImage: UIImage? = nil
}
