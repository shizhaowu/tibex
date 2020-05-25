all: dz d DamCan b dwd dk mKon lhjrinj shiyan

TMPDIR=midtmp

%.pdf : %.tbx
	sed -f subtibex.sed $< > $(TMPDIR)/$*.tex
	xetex $(TMPDIR)/$*

%.tex : %.tbx
	sed -f ../subtibex.sed $< > $(TMPDIR)/$*.tex

dz : dz.pdf

d : d.pdf

DamCan : DamCan.pdf
#DamCan.pdf : DamCan.tex tibex.tex
#	xetex DamCan
#DamCan.tex : DamCan.tbx
#	sed -f subtibex.sed DamCan.tbx > DamCan.tex

b:b.pdf
    
dwd: dwd.pdf

dk: dk.pdf

mKon: mKon.pdf

lhjrinj: lhjrinj.pdf

Thor: Thor1.pdf Thor2.pdf Thor3.pdf Thorcnt.pdf

Thor1.pdf: Thor1.tbx

Thor2.pdf: Thor2.tbx

Thor3.pdf: Thor3.tbx

Thorcnt.pdf: Thorcnt.tbx Thor1.cnt Thor2.cnt Thor3.cnt

2233: 2233.pdf

ALaXabDan: ALaXabDan.pdf

Al: Al.pdf

shiyan: shiyan.pdf
