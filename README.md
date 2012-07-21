nme-drawingstage
================

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
