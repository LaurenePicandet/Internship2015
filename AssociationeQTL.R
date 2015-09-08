list=read.delim("/home/picandet/Test_21_August/list_files2.txt", stringsAsFactors=F,header=F)

tab = data.frame(gene=1,SNP=1,pvalue=1)





setwd('/home/picandet/Test_21_August/eQTL_output')

i=1

for(gene in seq(1,nrow(list))){
  
  geneName=substr(list$V1[gene],11,25)
  
  f <- read.delim(as.character(list$V1[gene]), stringsAsFactors = F)
  
 
  
  for (snp in seq(1, nrow(f))){
    if (f$P[snp] < 0.05 & !is.na(f$P[snp])) {
      tab[i,1]=geneName
      tab[i,2]=f[snp,2]
      tab[i,3]=f[snp,9]
      i=i+1
    }  
  }
}






write.table(tab, file="~/Test_21_August/associationGeneSNP.txt", row.names=F, quote=F, sep='\t')




