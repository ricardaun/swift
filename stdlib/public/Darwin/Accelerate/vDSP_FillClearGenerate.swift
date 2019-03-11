//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
import Accelerate

extension vDSP {
    
    /// Fill vector with specified scalar value, single-precision.
    ///
    /// - Parameter vector: The vector to fill.
    /// - Parameter value: The fill value.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func fill<V>(_ vector: inout V,
                               with value: Float)
        where V: _MutableContiguousCollection,
        V.Element == Float {
            
            let n = vDSP_Length(vector.count)
            
            vector.withUnsafeMutableBufferPointer { v in
                withUnsafePointer(to: value) {
                    vDSP_vfill($0,
                               v.baseAddress!, 1,
                               n)
                }
            }
    }
    
    /// Fill vector with specified scalar value, double-precision.
    ///
    /// - Parameter vector: The vector to fill.
    /// - Parameter value: The fill value.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func fill<V>(_ vector: inout V,
                               with value: Double)
        where V: _MutableContiguousCollection,
        V.Element == Double {
            
            let n = vDSP_Length(vector.count)
            
            vector.withUnsafeMutableBufferPointer { v in
                withUnsafePointer(to: value) {
                    vDSP_vfillD($0,
                                v.baseAddress!, 1,
                                n)
                }
            }
    }
    
    /// Fill vector with zeros, single-precision.
    ///
    /// - Parameter vector: The vector to fill.
    /// - Parameter value: The fill value.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func clear<V>(_ vector: inout V)
        where V: _MutableContiguousCollection,
        V.Element == Float {
            
            let n = vDSP_Length(vector.count)
            
            vector.withUnsafeMutableBufferPointer { v in
                vDSP_vclr(v.baseAddress!, 1,
                          n)
            }
    }
    
    /// Fill vector with zeros, double-precision.
    ///
    /// - Parameter vector: The vector to fill.
    /// - Parameter value: The fill value.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func clear<V>(_ vector: inout V)
        where V: _MutableContiguousCollection,
        V.Element == Double {
            
            let n = vDSP_Length(vector.count)
            
            vector.withUnsafeMutableBufferPointer { v in
                vDSP_vclrD(v.baseAddress!, 1,
                           n)
            }
    }
    
    public enum windowType {
        case hanningNormalized
        case hanningDenormalized
        case hamming
        case blackman
    }
    
    /// Fills a supplied array with the specified window, single-precision.
    ///
    /// - Parameter type: Specifies the window type.
    /// - Parameter result: Output values.
    /// - Parameter isHalfWindow: When true, creates a window with only the first `(N+1)/2` points.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateWindow<V>(ofType type: windowType,
                                         result: inout V,
                                         isHalfWindow: Bool)
        where V: _MutableContiguousCollection,
        V.Element == Float {
            
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { v in
                switch type {
                case .hanningNormalized:
                    vDSP_hann_window(v.baseAddress!,
                                     n,
                                     Int32(vDSP_HANN_NORM) |
                                        Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                case .hanningDenormalized:
                    vDSP_hann_window(v.baseAddress!,
                                     n,
                                     Int32(vDSP_HANN_DENORM) |
                                        Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                case .hamming:
                    vDSP_hamm_window(v.baseAddress!,
                                     n,
                                     Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                case .blackman:
                    vDSP_blkman_window(v.baseAddress!,
                                       n,
                                       Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                }
            }
    }
    
    /// Fills a supplied array with the specified window, double-precision.
    ///
    /// - Parameter type: Specifies the window type.
    /// - Parameter result: Output values.
    /// - Parameter isHalfWindow: When true, creates a window with only the first `(N+1)/2` points.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateWindow<V>(ofType type: windowType,
                                         result: inout V,
                                         isHalfWindow: Bool)
        where V: _MutableContiguousCollection,
        V.Element == Double {
            
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { v in
                switch type {
                case .hanningNormalized:
                    vDSP_hann_windowD(v.baseAddress!,
                                      n,
                                      Int32(vDSP_HANN_NORM) |
                                        Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                case .hanningDenormalized:
                    vDSP_hann_windowD(v.baseAddress!,
                                      n,
                                      Int32(vDSP_HANN_DENORM) |
                                        Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                case .hamming:
                    vDSP_hamm_windowD(v.baseAddress!,
                                      n,
                                      Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                case .blackman:
                    vDSP_blkman_windowD(v.baseAddress!,
                                        n,
                                        Int32(isHalfWindow ?  vDSP_HALF_WINDOW : 0))
                }
            }
    }
    
    // MARK: Ramps
    
    /// Fills a supplied array with monotonically incrementing or decrementing values, single-precision.
    ///
    /// - Parameter initialValue: Specifies the initial value.
    /// - Parameter increment: The increment (or decrement if negative) between consecutive elements.
    /// - Parameter result: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateRamp<V>(withInitialValue initialValue: Float,
                                       increment: Float,
                                       result: inout V)
        where V: _MutableContiguousCollection,
        V.Element == Float {
            
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { v in
                vDSP_vramp([initialValue],
                           [increment],
                           v.baseAddress!, 1,
                           n)
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values, double-precision.
    ///
    /// - Parameter initialValue: Specifies the initial value.
    /// - Parameter increment: The increment (or decrement if negative) between consecutive elements.
    /// - Parameter result: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateRamp<V>(withInitialValue initialValue: Double,
                                       increment: Double,
                                       result: inout V)
        where V: _MutableContiguousCollection,
        V.Element == Double {
            
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { v in
                vDSP_vrampD([initialValue],
                            [increment],
                            v.baseAddress!, 1,
                            n)
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values within a specified range, single-precision.
    ///
    /// - Parameter range: Specifies range of the ramp.
    /// - Parameter result: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateRamp<V>(in range: ClosedRange<Float>,
                                       result: inout V)
        where V: _MutableContiguousCollection,
        V.Element == Float {
            
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { v in
                vDSP_vgen([range.lowerBound],
                          [range.upperBound],
                          v.baseAddress!, 1,
                          n)
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values within a specified range, double-precision.
    ///
    /// - Parameter range: Specifies range of the ramp.
    /// - Parameter result: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateRamp<V>(in range: ClosedRange<Double>,
                                       result: inout V)
        where V: _MutableContiguousCollection,
        V.Element == Double {
            
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { v in
                vDSP_vgenD([range.lowerBound],
                           [range.upperBound],
                           v.baseAddress!, 1,
                           n)
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values, multiplying by a source vector, single-precision.
    ///
    /// - Parameter initialValue: Specifies the initial value. Modified on return to hold the next value (including accumulated errors) so that the ramp function can be continued smoothly.
    /// - Parameter multiplyingBy: Input values multiplied by the ramp function.
    /// - Parameter increment: The increment (or decrement if negative) between consecutive elements.
    /// - Parameter result: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateRamp<U,V>(withInitialValue initialValue: inout Float,
                                         multiplyingBy vector: U,
                                         increment: Float,
                                         result: inout V)
        where
        U: _ContiguousCollection,
        V: _MutableContiguousCollection,
        U.Element == Float, V.Element == Float {
            
            precondition(vector.count == result.count)
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { dest in
                vector.withUnsafeBufferPointer { src in
                    vDSP_vrampmul(src.baseAddress!, 1,
                                  &initialValue,
                                  [increment],
                                  dest.baseAddress!, 1,
                                  n)
                }
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values, multiplying by a source vector, double-precision.
    ///
    /// - Parameter initialValue: Specifies the initial value. Modified on return to hold the next value (including accumulated errors) so that the ramp function can be continued smoothly.
    /// - Parameter multiplyingBy: Input values multiplied by the ramp function.
    /// - Parameter increment: The increment (or decrement if negative) between consecutive elements.
    /// - Parameter result: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateRamp<U,V>(withInitialValue initialValue: inout Double,
                                         multiplyingBy vector: U,
                                         increment: Double,
                                         result: inout V)
        where
        U: _ContiguousCollection,
        V: _MutableContiguousCollection,
        U.Element == Double, V.Element == Double {
            
            precondition(vector.count == result.count)
            let n = vDSP_Length(result.count)
            
            result.withUnsafeMutableBufferPointer { dest in
                vector.withUnsafeBufferPointer { src in
                    vDSP_vrampmulD(src.baseAddress!, 1,
                                   &initialValue,
                                   [increment],
                                   dest.baseAddress!, 1,
                                   n)
                }
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values, multiplying by a source vector, stereo, single-precision.
    ///
    /// - Parameter initialValue: Specifies the initial value. Modified on return to hold the next value (including accumulated errors) so that the ramp function can be continued smoothly.
    /// - Parameter multiplierOne: Input values multiplied by the ramp function.
    /// - Parameter multiplierTwo: Input values multiplied by the ramp function.
    /// - Parameter increment: The increment (or decrement if negative) between consecutive elements.
    /// - Parameter resultOne: Output values.
    /// - Parameter resultTwo: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateStereoRamp<U,V>(withInitialValue initialValue: inout Float,
                                               multiplyingBy multiplierOne: U, _ multiplierTwo: U,
                                               increment: Float,
                                               results resultOne: inout V, _ resultTwo: inout V)
        where
        U: _ContiguousCollection,
        V: _MutableContiguousCollection,
        U.Element == Float, V.Element == Float {
            
            precondition(multiplierOne.count == multiplierTwo.count)
            precondition(resultOne.count == resultTwo.count)
            precondition(multiplierOne.count == resultOne.count)
            let n = vDSP_Length(resultTwo.count)
            
            resultOne.withUnsafeMutableBufferPointer { o0 in
                resultTwo.withUnsafeMutableBufferPointer { o1 in
                    multiplierOne.withUnsafeBufferPointer { i0 in
                        multiplierTwo.withUnsafeBufferPointer { i1 in
                            vDSP_vrampmul2(i0.baseAddress!,
                                           i1.baseAddress!, 1,
                                           &initialValue,
                                           [increment],
                                           o0.baseAddress!,
                                           o1.baseAddress!, 1,
                                           n)
                        }
                    }
                }
            }
    }
    
    /// Fills a supplied array with monotonically incrementing or decrementing values, multiplying by a source vector, stereo, double-precision.
    ///
    /// - Parameter initialValue: Specifies the initial value. Modified on return to hold the next value (including accumulated errors) so that the ramp function can be continued smoothly.
    /// - Parameter multiplierOne: Input values multiplied by the ramp function.
    /// - Parameter multiplierTwo: Input values multiplied by the ramp function.
    /// - Parameter increment: The increment (or decrement if negative) between consecutive elements.
    /// - Parameter resultOne: Output values.
    /// - Parameter resultTwo: Output values.
    @inline(__always)
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public static func generateStereoRamp<U,V>(withInitialValue initialValue: inout Double,
                                               multiplyingBy multiplierOne: U, _ multiplierTwo: U,
                                               increment: Double,
                                               results resultOne: inout V, _ resultTwo: inout V)
        where
        U: _ContiguousCollection,
        V: _MutableContiguousCollection,
        U.Element == Double, V.Element == Double {
            
            precondition(multiplierOne.count == multiplierTwo.count)
            precondition(resultOne.count == resultTwo.count)
            precondition(multiplierOne.count == resultOne.count)
            let n = vDSP_Length(resultTwo.count)
            
            resultOne.withUnsafeMutableBufferPointer { o0 in
                resultTwo.withUnsafeMutableBufferPointer { o1 in
                    multiplierOne.withUnsafeBufferPointer { i0 in
                        multiplierTwo.withUnsafeBufferPointer { i1 in
                            vDSP_vrampmul2D(i0.baseAddress!,
                                            i1.baseAddress!, 1,
                                            &initialValue,
                                            [increment],
                                            o0.baseAddress!,
                                            o1.baseAddress!, 1,
                                            n)
                        }
                    }
                }
            }
    }
    
    
}
