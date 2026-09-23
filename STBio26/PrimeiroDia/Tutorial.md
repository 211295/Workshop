# Tutorial do Primeiro dia
### Baixar arquivos - Alinhamento Local - Alinhamento Global - Construção Filogenética
***
&emsp; Ao final deste tutorial o aluno entenderá como são utilizados os alinhamentos e como são de construídos as filogenias através de similaridades das bases.

&emsp; Primeiro iniciaremos com a exploração dos dados iniciais. Os dados estão presentes na pasta [Workshop/STBio26/PrimeiroDia](https://github.com/211295/Workshop/tree/main/STBio26/PrimeiroDia) e adquiridas no banco de dados [UniProt](https://www.uniprot.org/).

&emps; Utilize o comando wget para baixar diretamente no seu computador ou servidor remoto os os dados dos bancos de dados públicos. Neste caso, os dados já estão disponibilizados para vocês na página do GitHub.
```
$ wget ; gunzip *.gz
```
&emps; Após "dezipar" o arquivo pode inspeciona-lo, visualizando-o de maneiras diversas.
```
$ head -n <N> *.fa
$ tail -n <N> *.fa
$ more *.fa
$ less -S *.fa
# contar a quantidade de linhas de 3 maneiras distintas (a última nem um pouco usual e com muito exagero)
$ wc -l *.fa
$ cat *.fa | wc -l
# Contar o número de sequências presente nos arquivos
$ grep -c ">" *.fa
```
>[!WARNING]
> Não recomenda-se utilizar o `cat` com intuito de visualizar arquivos muito grandes
