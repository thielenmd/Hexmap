# Hexmap
Hex mapping tool using **Asymptote** and **LaTeX** for space-based wargames. Designed for *Starfire* (all versions), but it may be used for any space-based wargame with adaptations.

# Information and Compiling
This tool uses [Asymptote](https://asymptote.sourceforge.io/) as well as **LaTeX**. The source file is parameterized to allow for different options (foreground color, background color, etc.). By default, Asymptote will compile the map to an EPS (encapsulated postscript file), however other output options are available. The command to cpopile the map is below (ensure that Asymptote is on your command line search path).

```
asy hexmap.asy
```

## Compiling to PNG
The map may be compiled to PNG directly, using the command line below, however, for a high-resolution PNG map, it is recommended to open the EPS file in an image editing program and then export the image to PNG at 300 DPI (or the desired resolution).

```
asy -f png hexmap.asy
```

## Compiling to SVG
Creating an SVG file from an EPS input requires **dvisvgm** and **gs** (a ghostscript tool typically included in Asymptote or LaTeX distributions). It is necessary to first locate the path to *gs* using the the command below.

```
which gs
```

The EPS output from **Asymptote** may then be converted to SVG using the command below.

```
dvisvgm -E --libgs=/path/to/gs hexmap.eps
```

## Compiling to PDF
Creating a PDF version of the map requires **LaTeX** and the **xelatex** compiler. The command for generating PDF output is below.

```
asy hexmap.asy -tex xelatex
```
