library("data.table")
library("qqman")
plot_man_Q=function(file)##mesocotyl_ctl-salt.assoc.txt
{na=gsub(".assoc.txt","",file)
d=fread(file,header = T,sep="\t",data.table=F)
sig=d[d[,13]<=3.378e-6,]
d1=d[,c(1,2,3,13)]
png(paste(na,".man.png",sep=""),width = 210, height =120,res=600,units="mm" )
par(mfrow=c(1,1),mar=c(4,4,1,1))
manhattan(d1, chr = "chr", bp = "ps", p = "p_wald", snp = "rs",
          col = c("slateblue", "cyan4"), chrlabs = NULL,
          suggestiveline = -log10(3.378e-6), genomewideline = F)
dev.off()

##get significant site
outf=paste(na,".sig.txt",sep="")
write.table(sig,outf,sep="\t",col.names = T,row.names = F,quote=F)

###plot QQ
p=d1[,4]
p=p[!is.na(p)]
y=-log10(p)

y=sort(y,T)
x=-log10( ppoints(length(y)))

png(paste(na,".qq.png",sep=""),width = 120, height =120,res=600,units="mm" )
par(mar=c(3,3,0.5,0.5),mgp=c(1.5,0.4,0),tck=-0.005)
plot(x,y,pch=20,col="blue",axes = F,
     xlab=expression(-log[10]~~(P[expected])),
     ylab=expression(-log[10]~~(P[observed]))
)
abline(a = 0, b = 1, col = 2,lwd=1.5)
axis(1, tick =T,cex.axis=0.8,mgp=c(1.5,0.3,0))
axis(2,las=2,cex.axis=0.8)
box()
dev.off()

}

