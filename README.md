Haxe NME DrawingStage
=====================

A multi-touch-friendly fullscreen drawing canvas made with a grid of bitmaps.

    var grid = new BitmapGrid( width, height, cellSize, backgroundColor );
    var brush = new BitmapBrush( bitmapData, color );
  
    grid.lineStyle( id, brush );
    grid.moveTo( id, x, y );
    grid.lineTo( id, x, y );
    grid.clearStyle( id );

- A cell size of 128px works best on mobile: the bottleneck on mobile is often the quantity of memory 
accessed during computations (bitmap drawing is CPU-bound) and performance collapses if you go over 
some threshold (it's related to L1 and L2 CPU memory cache sizes).

- Compatible with native and Flash NME targets. 
HTML5 target actually works... but the brush isn't colored because BitmapData.draw doesn't seem to 
support color transforms.

License
-------

    This code was created by Philippe Elsass and is provided under a MIT-style license. 
    Copyright (c) Philippe Elsass. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.