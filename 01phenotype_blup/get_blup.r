library(data.table)
library(Ropt)
library(lme4)
d=read.table("infile_for_BLUP.txt",header = T,sep="\t",as.is=T)
d=d[d[,4]=="HN",]
#d=d[d[,4]=="LN",]
he=NULL
bl=as.data.frame(unique(d[,2]))
colnames(bl)="id"
for(i in 7:10)
{
  na=colnames(d)[i]
data=d[,c(1:3,5:6,i)]
data$Genotype=factor(data$Genotype)
data$year=factor(data$year)
data$block=factor(data$block)
data$sb=factor(data$sb)
data$spb=factor(data$spb)
colnames(data)[6]="y"
blp=lmer(y~year+ (1|Genotype)+(1 | block%in%year)+ (1|sb) + (1|spb)+(1|year:Genotype),data=data, 
         control=lmerControl(check.nobs.vs.nlev = "ignore",
                             check.nobs.vs.rankZ = "ignore",
                             check.nlev.gtr.1 = "ignore",
                             check.nobs.vs.nRE="ignore"))
x=summary(blp)
##H=Vg/(Vg+Vge/y+Ve/yb)  #y:year  b: block Ve:Residual
##reference: Hallauer, A.R. and Miranda, J.B. (1988) Quantitative Genetics in Maize Breeding. Ames, IA: Iowa State University, 283.
v=as.data.frame(x$varcor)
vg=v[2,4]
vge=v[1,4]
ve=v[6,4]
H=vg/(vg+vge/2+ve/2/2)
hee=c(na,H)
he=rbind(he,hee)
blups= ranef(blp)
names(blups)
lines=blups$Genotype+blp@beta[1]
blp.out=data.frame(id=rownames(lines),blp=lines)
colnames(blp.out)[2]=na
bl=merge(bl,blp.out,by=1,all=T)
}
#test
#test2
colnames(he)=c("Trait","Heritability")
write.table(bl,file="data_blup_HN_result.txt",row.names = F,quote = F,sep="\t")
write.table(he,file="Heritability_HN_result.txt",row.names = F,quote = F,sep="\t")

