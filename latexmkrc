$emulate_aux = 1;
$aux_dir = "build";
$out_dir = ".";

$bibtex_use = 2;

$pdf_mode = 1;

$ENV{"BIBINPUTS"} = "src/::";
$ENV{"BSTINPUTS"} = "src/::";
$ENV{"TEXINPUTS"} = "./:src/:lib/::";

$pdflatex = "texfot --ignore '^Underfull' --ignore '^Overfull' xelatex %O -pdf -interaction=nonstopmode -synctex=1 -file-line-error -shell-escape %S";
