$out_dir = "build";

$bibtex_use = 2;

$pdf_mode = 1;
$pdflatex = "texfot --ignore '^Underfull' --ignore '^Overfull' xelatex %O -bibtex -interaction=nonstopmode -synctex=1 -file-line-error -shell-escape %S";
