PAPER=paper
TEX=pdflatex
FLAGS=-halt-on-error -shell-escape
TARGET=1000

all: pdf

test: pdf testcount

quick:
	$(TEX) $(FLAGS) $(PAPER).tex

pdf: *.tex literature.bib src/*.tex
	$(TEX) -draftmode $(FLAGS) $(PAPER).tex
	bibtex $(PAPER)
	$(TEX) -draftmode $(FLAGS) $(PAPER).tex
	$(TEX) $(FLAGS) $(PAPER).tex
	detex thesis.tex | wc -w

count: *.tex src/*.tex
	echo "$$(date +"%F %T"),$$(detex thesis.tex | wc -w)" >> wordcount.csv
	tail wordcount.csv

testcount: *.tex src/*.tex
	echo "($$(tail -1 wordcount.csv | awk -F, '{print $$2}')+$(TARGET))-$$(detex thesis.tex | wc -w)" | bc

clean:
	rm $(PAPER).aux $(PAPER).bbl $(PAPER).blg $(PAPER).log $(PAPER).pdf
