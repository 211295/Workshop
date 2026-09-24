### Visualização de árvores pelo Phytools
packageVersion('phytools')
if(!require(phytools)){install.packages("phytools");library(phytools)}
if(!require(ape)){install.packages("ape");library(ape)}
if(!require(phytools)){install.packages("phytools");library(phytools)}

### Pode carregar seu pacote direto do computador
### Defina o "Diretório de trabalho" (SET Work Directory)
setwd("C:/Users/Documents/Workshop/")
tree <- data("[sua_arvore].tree")
print(tree)
summary(tree)

plotTree(tree, ftype="i",fsize=0.7)
phenogram(tree, eel_log_ln_TL,fsize=0.5)

par(mac=c(5.1,5.1,5,2.1,1.1))

### complete
phenogram(eel.tree, eel_log_ln_TL,fsize=0.5,
          ylab="log(maximum total length)", las=1, spread.cost=c(1,0),ftype="i")
eel_cMap = contMap(eel.tree,eel_log_ln_TL, plot=FALSE)
print(eel_cMap)
