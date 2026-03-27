import UIKit
import CoreImage

extension UIImage {
    func applyGaussianBlur(radius: CGFloat = 25) -> UIImage {
        guard let ciImage = self.ciImage ?? CIImage(image: self) else {
            return self
        }
        
        let originalExtent = ciImage.extent
        let clampedImage = ciImage.clampedToExtent()
        
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            return self
        }
        blurFilter.setValue(clampedImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputImage = blurFilter.outputImage else {
            return self
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: originalExtent) else {
            return self
        }
        
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
