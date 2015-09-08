#!/bin/bash


# definition of the variables
workingDirectory='Test_21_August'
date='31August'
vcftools="/home/picandet/Summer_Project/vcftools_0.1.12b/bin/vcftools"
plink="/home/picandet/Documents/plink-1.07-x86_64/plink"
expression="/home/picandet/Summer_Project/DATA/GeneExpr_v64.csv"

#0 input=VCF file

#1-do CADD scoring

#2 Produce plink files 
$vcftools --vcf ~/$workingDirectory/1VCF_CADDscore.vcf --plink --out ~/$workingDirectory/plink_file$date


#3 making alternate phenotype file: OK

#Anduril script creating the alternate phenotype file
~/SCRIPTS/runAlternatePhenotype.sh
Phenotype="/home/picandet/exec/alternate_filtered/csv.csv"
cat /home/picandet/exec/alternate_filtered/csv.csv| sed -r 's/\"//g' > ~/Test_21_August/PhenotypeFile.csv


#4 producing Hardy-Weinberg and Minor Allele Frequency files: OK


#production of a table with an Hardy-Weinberg p-value for each variant
$plink --map ~/$workingDirectory/plink_file$date.map --ped ~/$workingDirectory/plink_file$date.ped  --hardy  --out ~/$workingDirectory/Hardy_Weinberg --noweb --allow-no-sex

# conversion of this table into CSV
cat ~/$workingDirectory/Hardy_Weinberg.hwe | sed -r 's/^\s+//g' | sed -r 's/\s+/\t/g' | sed -r 's/\t$//g' > ~/$workingDirectory/Hardy_Weinberg.csv

#production of a table with the Minor Allele Frequency for each variant
$plink --map ~/$workingDirectory/plink_file$date.map --ped ~/$workingDirectory/plink_file$date.ped  --pheno $Phenotype --freq --out ~/$workingDirectory/MinorAlleleFrequency --noweb --allow-no-sex


# conversion of this table into CSV
cat ~/$workingDirectory/MinorAlleleFrequency.frq | sed -r 's/^\s+//g' | sed -r 's/\s+/\t/g' | sed -r 's/\t$//g' > ~/$workingDirectory/MinorAlleleFrequency.csv



#5- filtering the VCF file with hardy-weinberg and minor allele frequency (don't forget to change inputs of the Anduril script !): OK

# separation of the header of the VCF file
grep ^##  ~/$workingDirectory/1VCF_CADDscore.vcf > ~/$workingDirectory/filteredVCF.vcf

#filtering of the VCF file woth an Anduril script
~/Scripts_eQTL_Study/runFilterVCF.sh

#removing of the quotes of the VCF output, adding # before the column names, pasting the filtered VCF file to its header
cat ~/exec/VCF_filtered_withoutHeader_cleaned/table.csv | sed -r 's/\"//g'| sed -r 's/CHROM/#CHROM/g'  >>  ~/$workingDirectory/filteredVCF.vcf

#6 production of filtered plink files: 

# same as step #2 but with the filtered VCF file
vcftools --vcf ~/$workingDirectory/filteredVCF.vcf --plink --out ~/$workingDirectory/plink_fileFILTERED$date


#7 filtering of ped file :
# removing the indels, the multiallelic variants, putting the phenotype of the ped file to -9
R --file=~/Scripts_eQTL_Study/ped_filtering.R

#8 eQTL study
# performing the eQTL study with Plink. For each gene, one file is produced with the association of this gene to all the variants for all the patients

numberGenes=21307 # the number of genes in the expression table may vary
for i in `seq 3 $numberGenes`
do 
    name=`cut -f$i /home/picandet/Summer_Project/Plink_Biallelic/2dversion/alternate_pheno_file2.txt | head -n 1 `
    ~/Documents/plink-1.07-x86_64/plink  --map  ~/$workingDirectory/plink_files$date.map --ped ~/$workingDirectory/plink_file31AugustBiallelic.ped  --linear --out ~/$workingDirectory/eQTL_output/outputeQTL$name --pheno $Phenotype --pheno-name $name --noweb --allow-no-sex 
done

#9 Processing of the output of the eQTL study
cd $(find ~/$workingDirectory/eQTL_output/ -type d)


# Removing extra files

for file in *.nof
do
  rm $file
done 
 
for file in *.log
do
  rm $file
done  

for file in *.nosex
do
  rm $file
done 

# Convert files into CSV
for file in *
do
  cat $file | sed -r 's/^\s+//g' | sed -r 's/\s+/\t/g' | sed -r 's/\t$//g' > /home/picandet/Test_11_AUGUST/eQTL_output/$file.csv
done  

# Writing the list of all the genes names
cd ~/$workingDirectory/eQTL_output
ls  > ~/$workingDirectory/list_files.txt

#10 Make a table of the association between genes and variants

# for each gene in the list, put into a table all the associations with the gene name, the variant name and the p-value
R--file=~/Scripts_eQTL_Study/AssociationeQTL.R

#11 Remove the associations between genes and variants that are not in the gene or within 20 kb from the gene

~/Scripts_eQTL_Study/runAnnotation.sh




