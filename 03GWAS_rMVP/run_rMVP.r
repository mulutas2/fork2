library(rMVP)
# Full-featured function (Recommended)
MVP.Data(fileVCF="../02Genotype/278Sweet_corn_V5.miss05.maf001.recode.vcf",
         #filePhe="Phenotype.txt",
         fileKin=F,
         filePC=F,
         out="mvp.vcf"
         )

# Only convert genotypes
#MVP.Data.VCF2MVP("mvp.vcf", out='mvp') 

# calculate from mvp_geno_file
MVP.Data.PC(TRUE, mvp_prefix='mvp.vcf', pcs.keep=5)
# calculate from mvp_geno_file
MVP.Data.Kin(TRUE, mvp_prefix='mvp.vcf', out='mvp.vcf')

Kinship <- attach.big.matrix("mvp.vcf.kin.desc")
genotype <- attach.big.matrix("mvp.vcf.geno.desc")
phenotype <- read.table("phenotype.txt",head=TRUE,sep="\t")
map <- read.table("mvp.vcf.geno.map" , head = TRUE)

for(i in 2:ncol(phenotype)){
  imMVP <- MVP(
    phe=phenotype[, c(1, i)],
    geno=genotype,
    map=map,
    K=Kinship,
    #CV.GLM=Covariates,
    #CV.MLM=Covariates,
    #CV.FarmCPU=Covariates,
    nPC.GLM=3,
    nPC.MLM=3,
    nPC.FarmCPU=3,
    priority="speed",
    #ncpus=10,
    vc.method="BRENT",
    maxLoop=10,
    method.bin="static",
    #permutation.threshold=TRUE,
    #permutation.rep=100,
    threshold=0.05, ##0.05/marker size, a cutoff line on manhattan plot
    method=c("GLM", "MLM", "FarmCPU"),
    p.threshold=0.00001
    
  )
  gc()
}

#########Phenotype distribution
MVP.Hist(phe=phenotype, file.type="jpg", breakNum=18, dpi=300)

#######GWAS OUT
data("Plant.Height")

##plot PCA
pca <- attach.big.matrix("mvp.vcf.pc.desc")[, 1:3]
#pca <- prcomp(t(as.matrix(genotype)))$x[, 1:3]
MVP.PCAplot(PCA=pca, Ncluster=3, class=NULL, col=c("red", "green", "yellow"), file.type="jpg")
##manhattan
 MVP.Report(imMVP, plot.type="m", col=c("dodgerblue4","deepskyblue"), LOG10=TRUE, ylim=NULL,
             threshold=c(1e-6,1e-4), threshold.lty=c(1,2), threshold.lwd=c(1,1), threshold.col=c("black",
                                                                                                 "grey"), amplify=TRUE,chr.den.col=NULL, signal.col=c("red","green"), signal.cex=c(1,1),
             signal.pch=c(19,19),file.type="jpg",memo="",dpi=300)
##QQ
 MVP.Report(imMVP,plot.type="q",col=c("dodgerblue1", "olivedrab3", "darkgoldenrod1"),threshold=1e6,
              signal.pch=19,signal.cex=1.5,signal.col="red",conf.int.col="grey",box=FALSE,multracks=
                TRUE,file.type="jpg",memo="",dpi=300)