ped=read.table("/home/picandet/Test_21_August/plink_file31AugustBiallelicTest.ped", header=F, sep='\t', stringsAsFactors = F)

ped=read.table("/mnt/storageBig5/picandet/plink_file31AugustBiallelicTest.ped", header=F, sep='\t', stringsAsFactors = F)

for(j in seq(50000,ncol(ped))) {
  print(j)
  for (i in seq(1,nrow(ped))) {
    if (nchar(as.character(ped[i,j]))>1){
      ped[i,j]<-0
    }
  }
}

for(j in seq(7,ncol(ped))) {
  for (i in seq(1,nrow(ped))) {
    if (ped[i,j]==1 |ped[i,j]=="TRUE"){
      ped[i,j]<-0
    }
  }
}

for(i in seq(1,nrow(ped))){
  for(j in seq(7,ncol(ped),by=2)){
    if (ped[i,j] == 0 | ped[i,j+1] == 0 ) {
      if(ped[i,j] != ped[i,j+1] ) {
        ped[i,j] = 0
        ped[i,j+1] = 0
      }
    }
  }
}


for (i in seq(1,nrow(ped))) {
  ped[i,6]=-9
}


write.table(ped, file="/mnt/storageBig5/picandet/plink_file31AugustBiallelic.ped", quote=F, col.names = F, row.names = F, sep='\t')
           
q()

