# LaTeX Paper Template
[![Build](https://github.com/Virtlink/latex-paper-template/actions/workflows/docs.yml/badge.svg)](https://github.com/Virtlink/latex-paper-template/actions)
[![GitHub](https://img.shields.io/github/license/Virtlink/latex-paper-template)](https://github.com/Virtlink/latex-paper-template/blob/main/LICENSE)

This is an opinionated template for LaTeX papers that uses XeLaTeX and BibLaTeX.


## Getting Started
How to get started using this template.

### GitHub
In GitHub, click the _Use this template_ button to clone this repository and get started.

### Git
Otherwise, use Git to create a repository locally, based on this template:

```shell
mkdir my-latex-paper/
cd my-latex-paper/
git init
git remote add upstream https://github.com/Virtlink/latex-paper-template.git
git fetch upstream
git merge upstream/main
```


## Usage
How to build the LaTeX document.

### VS Code
When working in VS Code, install the [LaTeX Workshop](https://github.com/James-Yu/LaTeX-Workshop/) extension. When saving a LaTeX file, the project will rebuild automatically. Refer to the extension's documentation for more information on its usage and configuration.

### Overleaf
Just import the Git repository into Overleaf.

### Other editors
From a terminal, invoke the Makefile's default target to build the project:

```shell
make
```

To watch the directory for changes and rebuild the paper automatically, invoke:

```shell
make watch
```

### GitHub
If the repository is on GitHub, it automatically builds a new version of the PDF on each push.
Find the built paper as an artifact ZIP attached to each build on Github's _Actions_ page, such as [the latest artifact](https://nightly.link/Virtlink/latex-paper-template/workflows/build/main/paper.zip).

## Bibliography
There are various tools to manage the bibliography in your paper.

### Researchr
If you have a bibliography at [Researchr](https://researchr.org/), adjust the `RESEARCHR` variable in the `Makefile` to have the name of the bibliography. To update the Bibtex file from Researchr, invoke:

```shell
make bib
```

The bibiliography file is named `researchr.bib`. Include it in the paper using:

```latex
\bibliography{researchr}
```

### Zotero
In Zotero, install the [Better BibTeX](https://retorque.re/zotero-better-bibtex/) extension, see their website for instructions. Then, from Zotero's _File_ menu, choose _Export Library_ or right-click and collection and choose _Export Collection_. Set the following:

- Format: `Better BibLaTeX`
- Keep updated: `yes`

Specify where the resulting `.bib` file should be stored in this project. We recommend using the `zotero.bib` filename.


### Mendeley
You can export references from Mendeley using [this guide](https://www.mendeley.com/guides/mendeley-reference-manager/08.-exporting-references).


## License
[![License: CC0-1.0](https://licensebuttons.net/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)
To the extent possible under law, Daniel A. A. Pelsmaeker has waived all copyright and related or neighboring rights to the LaTeX Paper Template repository. Feel free to use this as you see fit, no attribution required.
