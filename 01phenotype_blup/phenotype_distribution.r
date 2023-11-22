library(data.table)
d=fread("data_blup_HN_result.txt",head=T,data.table=F)
cols=colours()[c(136,257,91)]
cols=adjustcolor(cols,alpha.f = 0.6)
par(mar=c(3,4,2,1),mfrow=c(1,2))
hist(d[,2],breaks = 30,xlab="g",main=colnames(d)[2],col="skyblue")

va=na.omit(d[,2])
plot(0,0,xlab="",ylab="",xlim=range(va),ylim=range(density(va)$y),
                                            axes=F,pch=16,col="white",main=colnames(d)[2],cex.lab=1)
axis(1,cex.axis=1.1)
axis(2,cex.axis=1.1,las=1)
lines(density(va),lty=1,col="skyblue",lwd=2.5)
m=mean(va)
abline(v=m,col="red",lty=2,lwd=2)

