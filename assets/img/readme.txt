Your graphical assets.

Your NMML references such a directory as:

  <assets path="assets/img" rename="img" />

These assets can then be loaded in your code as:

  var bmp = new Bitmap(nme.Assets.getBitmapData("img/foo.png"));
