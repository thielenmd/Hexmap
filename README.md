# Hexmap
Hex mapping tool using **Asymptote** and **LaTeX** for space-based wargames. Designed for *Starfire* (all versions), but it may be used for any space-based wargame with adaptations.

# Information and Compiling
This tool uses [Asymptote](https://asymptote.sourceforge.io/) as well as **LaTeX**. The source file is parameterized to allow for different options (foreground color, background color, etc.). By default, Asymptote will compile the map to an EPS (encapsulated postscript) file, however other output options are available. The command to compile the map is below (ensure that Asymptote is on your command line search path).

```bash
asy hexmap.asy
```

## Compiling to PNG
The map may be compiled to PNG directly, using the command line below, however, for a high-resolution PNG map, it is recommended to open the EPS file in an image editing program and then export the image to PNG at 300 DPI (or the desired resolution).

```bash
asy -f png hexmap.asy
```

## Compiling to SVG
Creating an SVG file from an EPS input requires **dvisvgm** and **gs** (a ghostscript tool typically included in Asymptote or LaTeX distributions). It is necessary to first locate the path to *gs* using the the command below.

```bash
which gs
```

The EPS output from **Asymptote** may then be converted to SVG using the command below.

```bash
dvisvgm -E --libgs=/path/to/gs hexmap.eps
```

**NOTE**: The output of background images (if enabled) for SVG output will only be grayscale.

## Compiling to PDF
Creating a PDF version of the map requires **LaTeX** and the **xelatex** compiler. The command for generating PDF output is below.

```bash
asy hexmap.asy -tex xelatex
```

# Map Splitting and Printing
An additional shel script, **mkmap.sh**, is provided to trim the map into chunks, so that it can be printed onto sheets of paper and then glued together. This script reqires the **poster** package. More information on this package is procided at [Details of source package poster](https://packages.ubuntu.com/source/groovy/poster).

# Acknowledgements
The Hex Map Generator's principal authors are Harald Katzer and Mike Thielen. Please refer to the hexmap.asy file for legal information.

The script can (or is planed to) use additional resources created by other people:

- The Starfire counter font created by William Hostman (aka **Aramis**).
        http://aramis.hostman.us/fonts/

- The counter images taken from the Starfire VASSAL module.
        http://www.vassalengine.org/wiki/Module:Starfire

- The Classic Starfire countersheets created by Chase Murphy (aka **Godsgopher**).
        http://www.starfiredesign.com/forum/download/file.php?id=62

- Mike Fisher's 'All the Ships' counter and the M8 Map System.
        http://www.cke1st.com/m_games4.htm

These works are the intellectual property of their respective authors.

# Future Enhancements
The following things are yet to be implemented:

- [ ] add godsgophers countersheets (cut them down to individual image files)
- [ ] add/fix usage of Aramis postscript font
- [ ] import of csv textfiles with scenario definitions
- [ ] convert counter images to vector graphics