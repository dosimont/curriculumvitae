# Makefile

TEX = pdflatex
BIB = bibtex

TEXDIR = tex
TEXSUBDIR = ${TEXDIR}/*
BIBDIR = bib
CONFIG = config

VERSIONA = cat ${CONFIG}/version
VERSIONFILE = ${TEXDIR}/def/version.tex

TEXSRC = $(wildcard *.tex)
TEXSUBSRC = $(wildcard $(TEXSUBDIR)/*.tex)
BIBSRC = $(wildcard $(BIBDIR)/*.bib)
PDF = $(TEXSRC:.tex=.pdf)


TEXCOMPILE = $(TEX) $(TEXSRC)


all : all-bib-default

todo : clean version touchtodo bib-default finalize

all-bib-default : clean version bib-default finalize

all-noclean : version bib-default finalize

todo-noclean : version touchtodo all-noclean

touchtodo : 
	${TOUCHTODO}

$(PDF) : $(TEXSRC) $(TEXSUBSRC) $(BIBSRC)
	$(TEXCOMPILE)
	$(TEXCOMPILE)

bib-default : $(PDF)
	i="$(shell ls *.aux)"; for j in $$i; do $(BIB) $$j; done

finalize :
	$(TEXCOMPILE)
	$(TEXCOMPILE)
	$(TEXCOMPILE)

version :
	git log --oneline > git.log
	wc -l git.log | sed -e 's/[^0-9]//g' > ${VERSIONFILE}
	echo "`$(VERSIONA)`.`cat ${VERSIONFILE}`" > ${VERSIONFILE}
	rm git.log
	
	
clean :
	rm -rf ${VERSIONFILE} *.idx *.nlo *.log *.lof *.lot *.bbl *.blg *.thm *.pdf *.aux *.backup *.bak *.toc *.out *.ilg *.nls *~ .*~	
