# Internship2015


The script Total_eQTLAnalysis.sh is sufficient to run the entire eQTL analysis.
required inputs : VCF file, Gene expression data.
https://drive.google.com/folderview?id=0B_D-zNel2DMNfmdqOXlsZlFKUTczeUQ5SnFQVm56cmhjZWlyaFhTdkFnb21iSlZlcUJ4TEk&usp=sharing
required software : Anduril, R, VCFTools
In this script, other scripts are called. 
The main script is commented but not the additionnal scripts, so I describe here what they are doing.
NB : each Anduril script (.and), must be run in the main bash script Total_eQTLAnalysis.sh through a small bashScript runXXX.sh.
This script gives the path of Anduril on the computer. 

Here is the description of the steps performed by the script :

- production of plink files (ped and map files) from the VCF file given as an input

- creation of the alternate phenotype file from the gene expression data with the script AlternatePhenotype.and :
  input files : ped file and gene expression file
  conversion of the patient IDs so that they match with the ones in the gene expression file (the first 4 patients are removed because they are not in the gene expression file)
  the gene expression data is converted into the specific format of the alternate phenotype for plink (transposition, names of the columns FID and IID),
  that can be found on http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#pheno  . 
  the last line of the script filter out the 4 patients that had been removed from the ped file.

- with plink, production of tables with the Hardy-Weinberg and Minor Allele Frequency value for each variant

- the output of plink are not tab delimited, the script converts the tables into CSV files.

- the script FilterVCF.and uses the tables with the Hardy-Weinberg value and the minor allele frequency value to filter the VCF file
  the lines above the column names are removed so that Anduril can read the column names of the VCF file
  the variants IDs are converted by adding "1:" 
  the tables with Hardy Weinberg and the minor allele frequency are joined to the VCF file
  the rows with a Minor allele frequency below 0.07 or a Hardy Weinberg p-value below 0.05 are filtered out
  the VCF file is converted back to its initial form, and in the script TotaleQTLAnalysis.sh the first line are put back before the column names
  
- new plink files(ped and map file) are produced from the filtered VCF file

- the script pedFiltering.R filters the ped file.
  the first for loop remove the indels (genotypes with more than 1 base)
  the 2d for loop removes the "1" that can sometimes appear because of the first for loop (I don not know why)
  the 3d for loop transforms the genotypes into biallelic ones. for example if a genotype is 0G with one allele missing, the for loop transforms it into 00 with both alleles missing.
  the 4th for loop sets the phenotype of the ped file to missing with -9 (this is needed because I give an alternate phenotype to Plink)
  The ped file given at the end looks like the filtered_ped_file_example that you can find on the git.
  
  
- an eQTL study is performed with a for loop : plink is called for each gene with the option --linear to make a linear association between the phenotype(gene expression) and the genotype(SNPs)

- the linear association files produced are converted into CSV files.

- a list with the names of all the association files is written (they have the shape EnsemblIdentifier.assoc.linear)

- the script AssociationeQTL.R produces a table with in each row a gene, a variant, and the p-value of the association between them.
  an empty table is created with the columns "gene", "SNP", "p-value"
  the column "gene" is filled with the list of the association files (with the Enseml Identifier)
  the colum "snp" is filled with the 2d column of the association files (variant name)
  the column "pvalue " is filled with the 9th column of the association files (pvalue)
  
- the script annotation.and removes the associations between genes and variants that are situated more than 20 KB appart.
  input file : the table created by AssociationeQTL.R
  for each gene are find the positions of its beginning and its end with Biomart
  the genes not in chromosome 1 are removed
  The beginning position of each gene is transformed in beginning position -20.
  The ending position of each gene is transformed in ending position +20.
  The row with the variant not situated between beginning position -20 and ending position +20 are removed.
  
- Boxplots for validating the associations can be created with Boxplots.R. The boxplots with a very low standard deviation (threshold that can be altered) are not produced.

  
