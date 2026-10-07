### Visualização de árvores pelo Phytools
packageVersion('phytools')
if(!require(phytools)){install.packages("phytools");library(phytools)}
if(!require(ape)){install.packages("ape");library(ape)}
if(!require(evolqg)){install.packages("evolqg"); library(evolqg)}

### Pode carregar seu pacote direto do computador
### Defina o "Diretório de trabalho" (SET Work Directory) caso queira baixar a arvore diretamente no seu computador
setwd("C:/Users/Documents/Workshop/")
tree <- data("[sua_arvore].tree")
print(tree)
summary(tree)

# Se preferir, copie e cole a arvore no objeto "tree_teste"
tree_teste <- read.tree(text = "('INSIRA SUA ARVORE AQUI';)")

plotTree(tree_teste, ftype="i",fsize=0.7)
