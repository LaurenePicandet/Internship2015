library("Hmisc")

## making the genotype file

ped=read.table("/home/picandet/Scripts_eQTL_Study/Filtered_Ped_File_example.ped",header = F,sep='\t',stringsAsFactors = F)


for (i in seq(1,nrow(ped))){
  for (j in seq(7,1390,by=2)){
    ped[i,j]=paste(ped[i,j]," ",ped[i,j+1])
    ped[i,j+1]=NA
  }
}

write.table(ped,file="/home/picandet/Save.ped",quote=F,row.names=F,col.names = F,sep = '\t')
ped=read.table("/home/picandet/Save.ped",header = F,sep='\t',stringsAsFactors = F)
ped$
save(ped,file="~/Save.ped")
ped=load("~/Save.ped")

for (j in seq(8,ncol(ped))){
  ped[,j]=NULL
}




map=read.table("/home/picandet/Test_21_August/plink_file21August.map",header=F,sep='\t',stringsAsFactors = F)
colnames(ped) <- c("","","","","","",map$V2) 

ped[,2]<-NULL

ped2=as.matrix(ped)
ped2=t(ped2)
write.table(ped2,file="/home/picandet/Test_21_August/Genotype.ped",quote=F,row.names=T,col.names = F,sep = '\t')

##making expr file
expr= read.table("/home/picandet/Summer_Project/Plink_Biallelic/2dversion/alternate_pheno_file2.txt", header=T, sep='\t')
expr$FID<-NULL
expr=t(expr)
write.table(expr,file="/home/picandet/Test_21_August/Expression.ped",quote=F,row.names=T,col.names=F,sep ='\t')

## Validation with box plots

setwd('/home/picandet/Test_11_AUGUST/Boxplots')

expr= read.table("/home/picandet/Test_21_August/Expression.ped", header=T, sep='\t',stringsAsFactors = F)

snp = read.table("/home/picandet/Test_21_August/Genotype.ped", header=T, sep='\t',stringsAsFactors = F)







setwd('/home/picandet/Test_21_August/Final_Boxplots')
for (i in seq(1,nrow(expr2))) {
  for (j in seq(101,1000)){
    box<-boxplot(as.numeric(expr2[i,-1])~unlist(snp[j,-1]),medcol="red",col.axis="grey30",main=cat("Gene ", expr2[i,1]," SNP", snp[j,1]),ylab="Expression", frame=T)
    if(length(box$stats[3,])>1){
      if(sd(box$stats[3, ])>1){
        jpeg(file=paste("Boxplot",i,".jpg",sep=""))
        boxplot(as.numeric(expr2[i,-1])~unlist(snp[j,-1]),medcol="red",col.axis="grey30",main=paste("Gene ", expr2[i,1]," SNP", snp[j,1]),ylab="Expression", frame=T)
        mtext("Genotype", side=1)
        dev.off() 
      }
    }
  }
}


jpeg(file=paste("Boxplot",1,".jpg",sep=""))
boxplot(as.numeric(expr2[1,-1])~unlist(snp[1,-1]),medcol="red",col.axis="grey30",main=cat("Gene ", expr2[i,1]," SNP", snp[j,1]),ylab="Expression", frame=T)
dev.off()

box<-boxplot(as.numeric(expr2[1,-1])~unlist(snp[1,-1]),medcol="red",col.axis="grey30",main=cat("Gene ", expr2[i,1]," SNP", snp[j,1]),ylab="Expression", frame=T)

expr2=expr[1,]
length(box$stats[3,])


expr2[1,]=expr[11583,]
expr2[2,]=expr[6760,]
expr2[3,]=expr[12508,]
expr2[4,]=expr[4414,]
expr2[5,]=expr[599,]
expr2[6,]=expr[6698,]

row.names(expr2)<-c(1,2,3,4,5,6)
