This repository contains my personal implementation of WebView4Delphi,
   specifically for Delphi 6 Personal Edition.
   
The dévelopment is still ongoing. So, the present sources and binaries should be uses "as-is", with no warranty whatsoever.

Actually, the features implemented as DLL functions are:
- creation of the WebView components, positonning and sizing them on a destination component
- deletion of these compoents and liberation of the ressources
- loading and display of the default page (bin.com)
- execution of JavaScript, as well as directly from HTML as programmatically by a DLL function
- recover an HTML element's content into the calling Delphi program as string
- setting an HTML element's content from the calling Delphi program as string 
- receiving string messages from the HTML/Javascript into a Delphi TList component
- loading of local files, including SVG images
- these images are really limitless - the supplied demo image is 40.000 pixels wide, but it could as wass have been 4 Giga pixels...
- possibility to shift the SVG's ViewBox horizontally and/or vertically, regardless of the dimension sizes
- these shifts are done programmatically by a DLL function sending JavaScript snippets to the webpage
- a demo program showing these features
- a demo webpage containing a huge SVG image, and the associated JavaScript files

Package content:
- full WebView4Delphi sources, modified to fit the above purposes
- full sources and binaries of the DLLBrowser project - the actuall DLL including these function
- full sources and binaries of a demo projet: WebView4Delphi_Messages_With_DLL
- this file Readme.txt
- a Licence.txt file