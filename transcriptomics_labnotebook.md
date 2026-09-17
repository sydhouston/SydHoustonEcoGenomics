# Transcriptomics Notebook

**Course**: Intro to Ecological Genomics - Fall 2026

**Name**: Syd Houston

------------------------------------------------------------------------

## 9.15.2026 - Setting up Lab Notebook and Learning Markdown

-   Setting up transcriptomics notebook

-   Learn how to take notes in markdown

-   Push notes to github

**Working Directory**

`/gpfs1/home/s/r/srhousto/eco_genomics_2026/transcriptomics`

**Input Files:**

`none`

**Output Files:**

`/gpfs1/home/s/r/srhousto/eco_genomics_2026/transcriptomics/trancriptomics_notebook.md`

**Programs and Dependencies:**

-   `R Version: 4.5.1`

-   `R Studio`

**Scripts:**

`none`

**Code:**

``` r
Library()

print("Hello World")
```

**Table:**

| Col1 | Col2 | Col3 |
|------|------|------|
|      |      |      |
|      |      |      |
|      |      |      |

![](markdowncheatsheet.png){width="664"}

**Notes/Observations:**

-   Oh cool graph! It makes sense

**Next Steps**

-   What you want to do next time

------------------------------------------------------------------------

## 9.15.2026 - Diving into Code

-   Setting up transcriptomics notebook

-   Learn how to take notes in markdown

-   Push notes to github

**Working Directory**

`/gpfs1/home/s/r/srhousto/eco_genomics_2026/transcriptomics`

**Input Files:**

`none`

**Output Files:**

`/gpfs1/home/s/r/srhousto/eco_genomics_2026/transcriptomics/trancriptomics_notebook.md`

**Programs and Dependencies:**

-   `R Version: 4.5.1`

-   `R Studio`

**Scripts:**

`none`

**Code:**

``` r
Library()

print("Hello World")
```

------------------------------------------------------------------------

## 9.17.2026 - Experiment Introduction to Copepod Data

AM - Ambient (Control)

OW - Ocean Warming

OA - Ocean Acidification

OWA - Ocean Warming and Acidification

What questions can we ask or hypotheses can we test with this experimental design, with these data?

1.  Change in GE in response to stressor?
2.  Change in GE thru time within a treatment?
    -   which are stable? (\# genes, magnitude of DGE)
3.  Overlap across treatments?
4.  What genes are correlated with the phenotypes from the other paper?

The "Raw Data" is a .fastq or .fq file

Each File has a

1.  Sequence Identifier (Read Name)
2.  Nucelotide Sequence A,T,C,G, sometimes N
3.  Separator Line (usually just a +)
4.  Quality scores for each base.

**Working Directory**

`/gpfs1/home/s/r/srhousto/eco_genomics_2026/transcriptomics`

**Input Files:**

`none`

**Output Files:**

`/gpfs1/home/s/r/srhousto/eco_genomics_2026/transcriptomics/trancriptomics_notebook.md`

**Programs and Dependencies:**

-   `R Version: 4.5.1`

-   `R Studio`

**Code (In Shell):**

``` r
cd /gpfs1/cl/biol3990 #changes the directory

cd C (starting letter of data set) (tab)

cd ll #shows what is inside data set

zcat AA (tab) #helps unzip do not hit enter and print the whole thing!!! - use "head"

zcat AA_F0_Rep3_2_clean.fq.gz | head -n 4 (just shows the first few lines)

zcat AA_F0_Rep3_2_clean.fq.gz | wc -l (says how many times are in a program)
```
