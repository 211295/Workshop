# Tutorial do Primeiro dia
### Baixar arquivos - Alinhamento Local - Alinhamento Global - Construção Filogenética
***
&emsp; Ao final deste tutorial o aluno entenderá como são utilizados os alinhamentos e como são de construídos as filogenias através de similaridades das bases.
> [!WARNING]
> Neste tutorial as citações de códigos estão com o sinal de dolar `$` e com o _output_, pois no **Terminal** do Linux o _PROMPT_ tem uma configuração e os comandos serão inseridos após o sinal de dolar.
>
> Portanto não funcionará copiar e colar o código todo do quadrado de citação.
```
fesalles@Br-SP95:~$
<user> @ <remote computer adress> : ~/<working directory> $ 
```

#### Abra no computador o aplicativo chamado Ubunto (icone laranja). Este será seu ambiente de pesquisa.
> Caso o sistema operacional for Linux :registered:, basta apertar `CRTL` + `T` 

&emsp; Iniciando a exploração dos dados presentes na pasta [Workshop/STBio26/PrimeiroDia](https://github.com/211295/Workshop/tree/main/STBio26/PrimeiroDia) e adquiridas no banco de dados [UniProt](https://www.uniprot.org/), e [NCBI/proteins](https://www.ncbi.nlm.nih.gov/home/proteins/).

&emsp; Utilize o comando wget para baixar diretamente no seu computador ou servidor remoto os dados dos bancos de dados públicos. Os dados estão disponíveis no [uniprotkb](https://www.uniprot.org/uniprotkb). 

Baixe o arquivo `.fasta`, clicando com botão direito e copiando o _link_ (se clicar no botão do arquivo, será baixado no computador diretamente). Em seguida insira no terminal junto do comando `wget`:

<img width="1244" height="676" alt="image" src="https://github.com/user-attachments/assets/40cba966-a9a8-46d0-b1a7-dc04f56b09c9" />

```
$ wget https://ftp.uniprot.org/pub/databases/uniprot/knowledgebase/complete/uniprot_sprot.fasta.gz ; gunzip *.gz ; echo "Dezipado"
```

&emsp; Após "dezipar" o arquivo pode inspeciona-lo, visualizando-o de maneiras diversas.

Comandos `head`, `tail`, `more`, `less`, `cat`, `tac`.
> Para o comando `less`, deve-se sair apertando a tecla `Q`, de "_quit_"
```
$ head -n <N> uniprot_sprot.fasta
$ tail -n <N> uniprot_sprot.fasta
$ more uniprot_sprot.fasta
$ less -S uniprot_sprot.fasta
```
>[!WARNING]
> Não recomenda-se utilizar o `cat` com intuito de visualizar arquivos muito grandes

Inspecione o arquivo um pouco mais: contagem de linhas e contagem de cabeçalhos ...
```
# contar a quantidade de linhas de 3 maneiras distintas (a última nem um pouco usual e com muito exagero)
$ wc -l uniprot_sprot.fasta
4347145 uniprot_sprot.fasta
$ cat uniprot_sprot.fasta | wc -l
4347145
# Print o arquivo completo com o número total de linhas 
$ cat -n uniprot_sprot.fasta | tail -n 1
4347145 LTLMLRRSDYCGICGEVLPKKLVFENSPSAPPYEA
```
Quantos cabeçalhos há neste arquivo? Porque o número de cabeçalhos é muito menor que o número de linhas totais? Lembre-se que os cabeçalhos iniciam sempre com um caractere específico por isso utiliza-se a contagem "pegando" o caractere e o contando.
```
$ grep -c ">" uniprot_sprot.fasta 
575748
```

Baixe o arquivo de proteína (hemoglobina neste caso)
> [!TIP]
> Qualquer proteína ou gene pode ser escolhido para fazer os passos seguintes
```
$ wget  ; gunzip *.gz
```
***
### Alinhamento Local ([BLAST](https://www.ncbi.nlm.nih.gov/books/NBK279690/))
#### Inicie com o programa BLAST para adquirir as proteínas com maior similaridade.
Dentro do [manual](https://www.ncbi.nlm.nih.gov/books/NBK279690/) procure pela instalação em `Exectables`. [Baixe](https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/) pelo index correspondente ao sistema operacional. Neste caso usa-se `x64-linux`. 
```
$ wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.17.0+-x64-linux.tar.gz
$ tar zxvpf ncbi-blast-2.17.0+-x64-linux.tar.gz
$ ls
# OU
$ gunzip ncbi-blast-2.17.0+-x64-linux.tar.gz
$ tar zvpf ncbi-blast-2.17.0+-x64-linux.tar.gz
```
> A opção `-x` do comando `tar` é o equivalente ao comando `gunzip`

Construa o banco de dados a partir do grupo de proteínas disponibilizadas. Neste caso todos as proteínas revisadas pelo [UniProt](https://www.uniprot.org/uniprotkb)
```
$ ./ncbi-blast-2.17.0+/bin/makeblastdb -in uniprot_sport.fasta -dbtype prot -out database/uniprot

Building a new DB, current time: 09/25/2026 22:47:26
New DB name:   /home/<user>/<directory>/database/uniprot
New DB title:  uniprot_sprot.fasta
Sequence type: Protein
Keep MBits: T
Maximum file size: 3000000000B
Adding sequences from FASTA; added 575748 sequences in 10.8187 seconds.

$ ls database/
uniprot.pdb  uniprot.pin  uniprot.pot  uniprot.ptf
uniprot.phr  uniprot.pjs  uniprot.psq  uniprot.pto
```
Alinhe os arquivos da proteína elegida com todas as proteínas do fasta.
***
### Alinhamento Global (MAFFT)

***
### Construção Filogenética ([IQTree](https://iqtree.github.io/doc/Home#why-iq-tree))
#### Análise de similaridade de sequências e construção filogenética 

Inicie 
<img width="1162" height="630" alt="image" src="https://github.com/user-attachments/assets/12c10f95-2a69-45dc-b832-dcb1c661f62d" />
```
$ wget https://github.com/iqtree/iqtree3/releases/download/v3.1.4/iqtree-3.1.4-Linux.tar.gz
$ tar zxvpf iqtree-3.1.4-Linux.tar.gz
$ ls iqtree-3.1.4-Linux/*
iqtree-3.1.4-Linux/example.cf   iqtree-3.1.4-Linux/example.phy
iqtree-3.1.4-Linux/example.nex  iqtree-3.1.4-Linux/models.nex

iqtree-3.1.4-Linux/bin:
iqtree3  iqtree3_arm  iqtree3_intel
```
Usa-se o comando `iqtree3` para 
***
### Visualização da árvore (iTol)
&emsp; Esta etapa pode ser feita da maneira que preferir. 

&emsp; Nós recomendamos uma visualização através de uma plataforma _on-line_ chamada [iTOL](https://itol.embl.de/). 

&emsp; Após verificar se a árvore foi gerada, pode dar um "print" nela com `cat` (arquivo pequeno) e copiar para área de `Visualize support values. Explore clade distances.` no site. Entre no "Upload a tree" e cole no espaço adqueado. Após colar o código da árvore basta clicar em `Upload`.
>[!TIP]
> Pode-se verificar que o site aceita carregar arquivos direto pelo computador. Mas devo lembrar que será apenas nos formatos _Newick_, _Nexus_ ou _PhyloXML_



