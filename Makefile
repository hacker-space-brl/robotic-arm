
LATEX=lualatex

TARGET=robotic-arm.pdf

DOT=$(wildcard figs/*.dot)
SVG=$(wildcard ./*/figs/*.svg)

MODE ?= batchmode

all: paper

$(SVG:.svg=.pdf): %.pdf: %.svg
	inkscape --export-pdf $(@) $(<)

%.aux: paper

%.svg: %.dot
	twopi -Tsvg -o$(@) $(<)

bib: $(TARGET:.tex=.aux)
	BSTINPUTS=:./style bibtex $(TARGET:.tex=.aux)

%.pdf: %.tex
	TEXINPUTS=:style $(LATEX) --interaction=$(MODE) -shell-escape `basename $<`; if [ $$? -gt 0 ]; then echo "Error while compiling $<"; touch `basename $<`; fi; \

paper: $(SVG:.svg=.pdf) $(DOT:.dot=.pdf) $(TARGET)

touch:
	touch $(TARGET:.pdf=.tex)

force: touch paper

%.nup: %.pdf
	pdfnup --nup 2x5 --no-landscape $<

nup: $(TARGET:.pdf=.nup)

clean:
	rm -f */*.vrb */*.spl */*.idx */*.aux */*.log */*.snm */*.out */*.toc */*.nav */*intermediate */*~ */*.glo */*.ist */*.bbl */*.blg $(SVG:.svg=.pdf) $(DOT:.dot=.svg) $(DOT:.dot=.pdf)
	rm -rf */_minted*

distclean: clean
	rm -f $(TARGET:.tex=.pdf)
