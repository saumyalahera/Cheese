//
//  SLPocket.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/29/21.
//
import Foundation
import MetalKit
import UIKit

/**This class holds important functions required to render shapes*/
public class SLPocket {
    

    /**It inits a metal device object so that you can create other object without passing metal object as a parameter*/
    init() {
        //Init metal device
    }
}

//MARK: - Metal View Functions
/**This extension creates metal view*/
extension SLPocket {
    
    /**This function creates a metal view
        - Parameters:
            - frame: Frame of the metal view
            - device: Metal device needed to attach to the view
        - Returns: Metal view*/
    class func createMetalView(frame: CGRect, device: MTLDevice?, clearColor: MTLClearColor) -> MTKView{
        
        //Create a metal view
        let metalView = MTKView(frame: frame, device: device)
        
        //Set a clear color
        metalView.clearColor = clearColor
        
        //Return metal view
        return metalView
    }
    
    /**This function creates a metal view
        - Parameters:
            - frame: Frame of the metal view
            - device: Metal device needed to attach to the view
            - clearColor: clear color for the metal view
            - superview: Add the metalview on top the superview
        - Returns: Metal view*/
    class func createMetalViewOnSuperview(frame:CGRect, device:MTLDevice?, clearColor:MTLClearColor, superview: inout UIView) {
        
        //Create a metal view
        let metalView = MTKView(frame: frame, device: device)
        
        //Set a clear color
        metalView.clearColor = clearColor
        
        //Add them to a superview
        superview.addSubview(metalView)
    }
    
}


//MARK: - Metal Device Functions
/**This extension is to work with metal device object*/
extension SLPocket {
    /**Get a GPU instance. It is a class method and do not need to create
        - Returns: Metal Device*/
    class func createDevice() -> MTLDevice?{
        //Returns a device
        return MTLCreateSystemDefaultDevice()
    }
}

//MARK: - Metal Command Queue Functions
/**This extension is to work with Metal Command Queue*/
extension SLPocket {
    /**Creates command Queue and returns one
        - Returns: Metal Command Queue*/
    class func createCommandQueue(device: MTLDevice?) -> MTLCommandQueue?{
        //Returns a queue
        return device?.makeCommandQueue()
    }
}

//MARK: - Render Pipeline Descriptor
/**This extension helps create a render pipeline descriptor needed for render pipeline state*/
extension SLPocket {
    
    /**This function creates a Render Pipeline Descriptor
        - Parameters:
            - pixelFormat:      Frame buffer pixel format
            - vertexFunction:   It attaches vertex buffer required for Pipeline state
            - fragmentFunction: It attaches fragment buffer required for Pipeline state
        - Returns: A render pipeline descriptor*/
    class func createRenderPipelineDescriptor(pixelFormat: MTLPixelFormat = MTLPixelFormat.bgra8Unorm, vertexFunction:MTLFunction?, fragmentFunction:MTLFunction?) -> MTLRenderPipelineDescriptor?{
        
        //Create render pipeline descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        //Set frame buffer pixel format
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        //Set vertex function
        renderPipelineDescriptor.vertexFunction = vertexFunction
        
        //Set fragment function
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        //Return render pipeline descriptor
        return renderPipelineDescriptor
    }
    
    /**This function creates a Render Pipeline Descriptor
        - Parameters:
            - pixelFormat:      Frame buffer pixel format
            - vertexFunctionName:   It attaches vertex buffer required for Pipeline state
            - fragmentFunctionName: It attaches fragment buffer required for Pipeline state
        - Returns: A render pipeline descriptor*/
    class func createRenderPipelineDescriptor(device: MTLDevice?, pixelFormat: MTLPixelFormat = MTLPixelFormat.bgra8Unorm, vertexFunctionName:String, fragmentFunctionName:String) -> MTLRenderPipelineDescriptor?{
        
        //Create render pipeline descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        //Set frame buffer pixel format
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        //Get vertex function
        let vertexFunction = SLPocket.getMetalFunction(device: device, name: vertexFunctionName)
        
        //Get Fragment function
        let fragmentFunction = SLPocket.getMetalFunction(device: device, name: fragmentFunctionName)
        
        //Set vertex function
        renderPipelineDescriptor.vertexFunction = vertexFunction
        
        //Set fragment function
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        //Return render pipeline descriptor
        return renderPipelineDescriptor
    }
}

//MARK: - Render Pipeline
/**This extension helps create a render pipeline state*/
extension SLPocket {
    
    /**This function creates a Render Pipeline Descriptor
        - Parameters:
            - device: It is needed to make a render pipeline state
            - renderPipelineDescriptor: This is needed to create a render pipeline
        - Returns: A render pipeline*/
        class func createRenderPipeline(device: MTLDevice?, renderPipelineDescriptor: MTLRenderPipelineDescriptor) -> MTLRenderPipelineState? {
        
        //Render pipeline state
        var renderPipelineState:MTLRenderPipelineState?
        
        //Create render pipeline state
        do {
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError {
            print("Could not create render pipeline: \(error.localizedDescription)")
            
        }
        
        //Return render pipeline state
        return renderPipelineState
        
    }
    
}

//MARK: - Metal Buffer Functions
/**This extension is to work with metal buffer object*/
extension SLPocket {
    
    /**This method will make the use of a simple. It is independent of the class
        - Parameters:
            - device: Metal device for creating a metal buffer
            - rawData: It is unformatted data
            - length: Raw data length
            - options: Resource storage modes allow you to define the storage location and access permissions for your MTLBuffer and MTLTexture objects.*/
    class func createBuffer(device: MTLDevice?, rawData: UnsafeRawPointer, length: Int, options: MTLResourceOptions) -> MTLBuffer?{
        
        //Return a simple function
        return device?.makeBuffer(bytes: rawData, length: length, options: options)
    }
    
}

//MARK: - Metal Library Functions
/**This extension has shader library functions required to attach to a render pipeline*/
extension SLPocket {
    
    /**It returns a MTLFunction from a shader file. This function is indepedent of the metal device object in the class
        - Parameters:
            - device: MTLDevice object needed to create Metal Library
            - name:   It is the name of the function to fetch from a Metal file
        - Returns:    It returns the metal function of the name*/
    class func getMetalFunction(device: MTLDevice?, name: String) -> MTLFunction? {
        guard let defaultLibrary = device?.makeDefaultLibrary() else {
            return nil
        }
        return defaultLibrary.makeFunction(name: name)
    }
    
    /**It returns a MTLFunction from a shader file. This function is indepedent of the metal device object in the class. It doesnt need other objects, but the function name
        - Parameters:
            - name:   It is the name of the function to fetch from a Metal file
        - Returns:    It returns the metal function of the name*/
    class func getMetalFunction(name: String) -> MTLFunction? {
        
        //Create a metal device
        let device = MTLCreateSystemDefaultDevice()
        
        //Create a default library for getting functions
        let defaultLibrary = device?.makeDefaultLibrary()
        
        //Return a function
        return defaultLibrary?.makeFunction(name: name)
    }
}

//MARK: - Metal Color Functions
/**This extension has metal color functions*/
extension SLPocket {
    
    /**This function comverts UIColor to MTLClearColor
        - Parameters:
            - color - This is a UIColor that is supposed to be converted
        - Returns: MTLClearColor that is equivalent UIColor values or nil */
    class func colorToMTLClearColor(color:UIColor?) -> MTLClearColor? {
        
        //Get color components
        guard let components = color?.cgColor.components else {
            return nil
        }
        /*This happens with colors like black and white where there are only two inputs. rgb have same value and alpha.*/
        if(components.count < 4) {
            return MTLClearColor(red: Double(components[0]), green: Double(components[0]), blue: Double(components[0]), alpha: Double(components[1]))
        }
        //Map them to the right components
        return MTLClearColor(red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), alpha: Double(components[3]))
    }
    
    /**This function comverts UIColor to MTLClearColor simd_float4 components
        - Parameters:
            - color - This is a UIColor that is supposed to be converted
        - Returns: simd_float4 that is equivalent UIColor values or nil */
    class func colorToSIMDComponents(color:UIColor?) -> simd_float4? {
        
        //Get color components
        guard let components = color?.cgColor.components else {
            return nil
        }
        /*This happens with colors like black and white where there are only two inputs. rgb have same value and alpha.*/
        if(components.count < 4) {
            return simd_float4(Float(components[0]), Float(components[0]), Float(components[0]), Float(components[1]))
        }else {
            return simd_float4(Float(components[0]), Float(components[1]), Float(components[2]), Float(components[3]))
        }
    }
}

//MARK: - Normalise Coordinates
/**This extension has coordinates normalise functions*/
extension SLPocket {
    
    /**This function normalises a coordinate
        - Parameters:
            - x - x coordinate to be normalised
            - frame: frame which will be used for converting coordinates
        - Returns: returns x normalised coordinate*/
    /*Create a class that will normaliseX coordinates*/
    class func normaliseX(x: Float, frame:CGRect?) -> Float?{
        guard let frame = frame else {
            return nil
        }
        let xk:Float = 1/Float(frame.width)
        return ((2*x)*xk)-1
    }
    
    /**This function normalises a coordinate
        - Parameters:
            - y - y coordinate to be normalised
            - frame: frame which will be used for converting coordinates
        - Returns: returns xynormalised coordinate*/
    /*Create a class that will normaliseY coordinates*/
    class func normaliseY(y:Float, frame:CGRect?) -> Float?{
        guard let frame = frame else {
            return nil
        }
        let yk:Float = 1/Float(frame.height)
        return ((-2*y)*yk)+1
    }
    
    /**This function normalises a coordinate
        - Parameters:
            - x - x coordinate to be normalised
            - frame: frame which will be used for converting coordinates
        - Returns: returns x normalised coordinate*/
    /*Create a class that will normaliseX coordinates*/
    class func normaliseX(x: Float, frame:CGRect) -> Float{
        let xk:Float = 1/Float(frame.width)
        return ((2*x)*xk)-1
    }
    
    /**This function normalises a coordinate
        - Parameters:
            - y - y coordinate to be normalised
            - frame: frame which will be used for converting coordinates
        - Returns: returns xynormalised coordinate*/
    /*Create a class that will normaliseY coordinates*/
    class func normaliseY(y:Float, frame:CGRect) -> Float{
        let yk:Float = 1/Float(frame.height)
        return ((-2*y)*yk)+1
    }
    
}

//MARK: - Metal Radians Functions
/**This extension has metal radians functions*/
extension SLPocket {
    
    /**It is used to cnovert degrees to radians. A lot of functions need parameters in radians*/
    class func degreesToRadians(_ degrees: Float)->Float {
        return (Float.pi*degrees)/180
    }
    
    /**It is used to convert orthographic projection matrix**/
    class func makeOrthographicMatrixc(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> simd_float4x4 {
        return simd_float4x4(
            [ 2 / (right - left), 0, 0, 0],
            [0, 2 / (top - bottom), 0, 0],
            [0, 0, 1 / (far - near), 0],
            [(left + right) / (left - right), (top + bottom) / (bottom - top), near / (near - far), 1]
        )
    }
    
}

//MARK: - UI Elements
/*This is going to hold label*/
extension SLPocket {
    class func getButton(title: String, background: UIColor, titleColor:UIColor, font: UIFont) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = background
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        return button
    }
    
    class func getView(color: UIColor) -> UIView{
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    class func getLabel(textColor:UIColor, font:UIFont) -> UILabel{
        let label = UILabel()
        label.font = font
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }
}

//MARK: - Autolayout Methods
/**This class is to add Autolayout constraints**/
extension SLPocket {
    
/**This is used to make **/
   class func addConstraints(leading:CGFloat, trailing:CGFloat, top:CGFloat, bottom:CGFloat, view:UIView) {
        guard let superview = view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
        ])
        
    }
    
    class func addConstraints(leading:CGFloat, trailing:CGFloat, bottom:CGFloat, height:CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
             view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
             view.heightAnchor.constraint(equalToConstant: height),
             view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
         ])
     }
    
    class func addConstraints(leading:CGFloat, top:CGFloat, bottom:CGFloat, widthMultiplier: CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
             view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
             view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: widthMultiplier),
             view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
         ])
     }
    
    class func addConstraints(trailing:CGFloat, top:CGFloat, bottom:CGFloat, widthMultiplier: CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
             view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
             view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: widthMultiplier),
             view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
         ])
     }
    
    class func addConstraints(leading:CGFloat, trailing:CGFloat, top:CGFloat, height: CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
             view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
             view.heightAnchor.constraint(equalToConstant: height),
             view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading)
         ])
     }
    
    class func addConstraints(height:CGFloat, width:CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.widthAnchor.constraint(equalToConstant: width),
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
         ])
     }
    
    class func addConstraints(leading: CGFloat, trailing: CGFloat, height:CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing)
         ])
     }
}





