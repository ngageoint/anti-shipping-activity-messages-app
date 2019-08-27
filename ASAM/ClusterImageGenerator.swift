//
//  ClusterImageGenerator.swift
//  anti-piracy-iOS-app
//


import Foundation
import UIKit

struct ClusterImageGenerator {

    static func textToImage(_ drawText: NSString, inImage: UIImage) -> UIImage{
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.white
        let textFont: UIFont = UIFont.systemFont(ofSize: 12.0)
        
        
        let textFontAttributes = [NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor]
        
        //Put the image into a rectangle as large as the original image.
        let imageRectangle: CGRect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
        inImage.draw(in: imageRectangle)
        
        //center text
        let size: CGSize = drawText.size(attributes: textFontAttributes)
        let rect: CGRect = CGRect(x: imageRectangle.origin.x + (imageRectangle.size.width - size.width)/2.0,
            y: imageRectangle.origin.y + (imageRectangle.size.height - size.height)/2.0,
            width: imageRectangle.size.width, height: imageRectangle.size.height)
        
        //Draw the text into an image.
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
}
