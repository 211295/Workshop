# Tutorial do Primeiro dia
### Baixar arquivos - Alinhamento Local - Alinhamento Global - Construção Filogenética
***
&emsp; Ao final deste tutorial o aluno entenderá como são utilizados os alinhamentos e como são de construídos as filogenias através de similaridades das bases.

&emsp; Primeiro iniciaremos com a exploração dos dados iniciais. Os dados estão presentes na pasta [Workshop/STBio26/PrimeiroDia](https://github.com/211295/Workshop/tree/main/STBio26/PrimeiroDia) e adquiridas no banco de dados [UniProt](https://www.uniprot.org/).

&emsp; Utilize o comando wget para baixar diretamente no seu computador ou servidor remoto os os dados dos bancos de dados públicos. Os dados estão disponíveis no [uniprotkb](https://www.uniprot.org/uniprotkb). 

Baixe o arquivo fasta, clicando com botão direito e copiando o _link_ (se clicar no botão fasta, será baixado no computador o arquivo). Em seguida insira no terminal junto do comando `wget`:

<img width="1244" height="676" alt="image" src="https://github.com/user-attachments/assets/40cba966-a9a8-46d0-b1a7-dc04f56b09c9" />


```
$ wget https://ftp.uniprot.org/pub/databases/uniprot/knowledgebase/complete/uniprot_sprot.fasta.gz ; gunzip *.gz
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

Inspecione o arquivo um pouco mais: Contagem de linhas, contagem de cabeçalhos, contagem de 
```
# contar a quantidade de linhas de 3 maneiras distintas (a última nem um pouco usual e com muito exagero)
$ wc -l uniprot_sprot.fasta
4347145 uniprot_sprot.fasta
$ cat uniprot_sprot.fasta | wc -l
4347145
# Print o arquivo completo com o numero total de linhas 
$ cat -n uniprot_sprot.fasta | tail -n 1
4347145 LTLMLRRSDYCGICGEVLPKKLVFENSPSAPPYEA
```
Inspecione mais um pouco. Qual o tipo de molécula está presente neste arquivo fasta? Quantos cabeçalhos há neste arquivo?
```
$ head uniprot_sprot.fasta
>sp|Q6GZX4|001R_FRG3G Putative transcription factor 001R OS=Frog virus 3 (isolate Goorha) OX=654924 GN=FV3-001R PE=4 SV=1
MAFSAEDVLKEYDRRRRMEALLLSLYYPNDRKLLDYKEWSPPRVQVECPKAPVEWNNPPS
EKGLIVGHFSGIKYKGEKAQASEVDVNKMCCWVSKFKDAMRRYQGIQTCKIPGKVLSDLD
AKIKAYNLTVEGVEGFVRYSRVTKQHVAAFLKELRHSKQYENVNLIHYILTDKRVDIQHL
EKDLVKDFKALVESAHRMRQGHMINVKYILYQLLKKHGHGPDGPDILTVKTGSKGVLYDD
SFRKIYTDLGWKFTPL
>sp|Q6GZX3|002L_FRG3G Uncharacterized protein 002L OS=Frog virus 3 (isolate Goorha) OX=654924 GN=FV3-002L PE=4 SV=1
MSIIGATRLQNDKSDTYSAGPCYAGGCSAFTPRGTCGKDWDLGEQTCASGFCTSQPLCAR
IKKTQVCGLRYSSKGKDPLVSAEWDSRGAPYVRCTYDADLIDTQAQVDQFVSMFGESPSL
AERYCMRGVKNTAGELVSRVSSDADPAGGWCRKWYSAHRGPDQDAALGSFCIKNPGAADC
$ grep -c ">" uniprot_sprot.fasta 
575748
```


***
### Visualização da árvore (iTol)
&emsp; Esta etapa pode ser feita da maneira que preferir. 

&emsp; Nós recomendamos uma visualização através de uma plataforma _on-line_ chamada [iTOL](https://itol.embl.de/). 

&emsp; Após verificar se a árvore foi gerada, pode dar um "print" nela com `cat` (arquivo pequeno) e copiar para área de `Visualize support values. Explore clade distances.` no site. Entre no "Upload a tree" e cole no espaço adqueado. Após colar o código da árvore basta clicar em `Upload`.
>[!TIP]
> Pode-se verificar que o site aceita carregar arquivos direto pelo computador. Mas devo lembrar que será apenas nos formatos _Newick_, _Nexus_ ou _PhyloXML_



