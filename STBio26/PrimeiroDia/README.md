# Tutorial do Primeiro dia
### Baixar arquivos - Alinhamento Local - Alinhamento Global - Construção Filogenética
***
&emsp; Ao final deste tutorial o aluno entenderá como são utilizados os alinhamentos e como são de construídos as filogenias através de similaridades das bases.
> [!WARNING]
> Neste tutorial as citações de códigos estão com o sinal de dolar `$` e com o _intput_, pois no **Terminal** do Linux o _PROMPT_ tem uma configuração e os comandos serão inseridos após o sinal de dolar.
>
> Portanto não funcionará copiar e colar o código todo do quadrado de citação.
```
fesalles@Br-SP95:~$
<user> @ <remote computer adress> : ~/<working directory> $ 
```

#### Abra no computador o aplicativo chamado Ubunto (icone laranja). Este será seu ambiente de pesquisa.
> Caso o sistema operacional for Linux :registered:, basta apertar `CRTL` + `T`

## 1. Baixar arquivos
- Iniciando a exploração dos dados presentes na pasta [Workshop/STBio26/PrimeiroDia](https://github.com/211295/Workshop/tree/main/STBio26/PrimeiroDia) e adquiridas no banco de dados [UniProt](https://www.uniprot.org/), e [NCBI/proteins](https://www.ncbi.nlm.nih.gov/home/proteins/).

- Utilize o comando wget para baixar diretamente no seu computador ou servidor remoto os dados dos bancos de dados públicos. Os dados estão disponíveis no [uniprotkb](https://www.uniprot.org/uniprotkb). 

- Baixe o arquivo `.fasta`, clicando com botão direito e copiando o _link_ (se clicar no botão do arquivo, será baixado no computador diretamente). Em seguida insira no terminal junto do comando `wget`:

<img width="1244" height="676" alt="image" src="https://github.com/user-attachments/assets/40cba966-a9a8-46d0-b1a7-dc04f56b09c9" />

```
$ wget https://ftp.uniprot.org/pub/databases/uniprot/knowledgebase/complete/uniprot_sprot.fasta.gz ; gunzip *.gz ; echo "Dezipado"
$ ls 
programas/ uniprot_sport.fasta
```

Após "dezipar" o arquivo pode inspeciona-lo, visualizando-o de maneiras diversas.

- Comandos `head`, `tail`, `more`, `less`, `cat`, `tac`.
> Para o comando `less`, deve-se sair apertando a tecla `Q`, de "_quit_"
```
# Teste cada um separadamente
$ head -n <N> uniprot_sprot.fasta
$ tail -n <N> uniprot_sprot.fasta
$ more uniprot_sprot.fasta
$ less -S uniprot_sprot.fasta
```
>[!WARNING]
> Não recomenda-se utilizar o `cat` com intuito de visualizar arquivos muito grandes

- Inspecione o arquivo um pouco mais: contagem de linhas e contagem de cabeçalhos ...
```
# contar a quantidade de linhas de 3 maneiras distintas (a última nem um pouco usual e com muito exagero)
$ wc -l uniprot_sprot.fasta
4347145 uniprot_sprot.fasta
$ cat uniprot_sprot.fasta | wc -l
4347145
# Print o arquivo completo com o número total de linhas 
$ cat -n uniprot_sprot.fasta | tail -n 1
4347145 LTLMLRRSDYCGICGEVLPKKLVFENSPSAPPYEA
# Contagem de linhas com o ícone ">"
$ grep -c ">" uniprot_sprot.fasta 
575748
```
:grey_question: Quantos cabeçalhos há neste arquivo :grey_question: Porque o número de cabeçalhos é muito menor que o número de linhas totais :grey_question: Lembre-se que os cabeçalhos iniciam sempre com um caractere específico por isso utiliza-se a contagem "pegando" o caractere e o contando.


- Construa o arquivo fasta da proteína (hemoglobina neste caso). Conseguimos construir tanto utilizando o banco de dados no [NCBI]() quanto [Uniprot]()
> [!TIP]
> Qualquer proteína ou gene pode ser escolhido para fazer os passos seguintes
<img width="952" height="338" alt="image" src="https://github.com/user-attachments/assets/393897f8-1906-41ef-bf17-6fff215b1736" />

Encontre para baixar o tipo de arquivo _FASTA_
<img width="864" height="359" alt="image" src="https://github.com/user-attachments/assets/f648a62e-6314-4f21-b01b-69b9ce63fad0" />
- Construa os arquivos de proteínas com esses 2 comandos
```
$ touch hemoglobina.fasta ; nano hemoglobina.fasta
```
Copie e cole o arquivo [hemoglobin.fasta](https://github.com/211295/Workshop/blob/main/STBio26/PrimeiroDia/hemoglobin.fasta) no **terminal**

> [!NOTE]
> Para sair do arquivo editor: `CRTL` + `X`, digite `Y` (_yes_), para salvar o arquivo.

- Verifique os programas baixados
```
$ ls /programas/
ncbi-blast-2.17.0+/  mafft-7.526-linux/  iqtree-3.0.1-Linux/
```
***
## 2. Alinhamento Local ([BLAST](https://www.ncbi.nlm.nih.gov/books/NBK279690/))
#### Inicie com o programa BLAST para adquirir as proteínas com maior similaridade.
- Dentro do [manual](https://www.ncbi.nlm.nih.gov/books/NBK279690/) procure pela instalação em `Exectables`. [Baixe](https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/) pelo index correspondente ao sistema operacional. Neste caso usa-se `x64-linux`. 
```
$ wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.17.0+-x64-linux.tar.gz
$ tar zxvpf ncbi-blast-2.17.0+-x64-linux.tar.gz
$ ls
# OU
$ gunzip ncbi-blast-2.17.0+-x64-linux.tar.gz
$ tar zvpf ncbi-blast-2.17.0+-x64-linux.tar.gz
```
> A opção `-x` do comando `tar` é o equivalente ao comando `gunzip`

- Construa o banco de dados a partir do grupo de proteínas disponibilizadas. Neste caso todos as proteínas revisadas pelo [UniProt](https://www.uniprot.org/uniprotkb)
```
$ ./programas/ncbi-blast-2.17.0+/bin/makeblastdb -in uniprot_sport.fasta -dbtype prot -out database/uniprot

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
- Alinhe os arquivos da proteína elegida com todas as proteínas do fasta.
  
- Utilize o `blastp` com as opções: `-out`, `-query`, `-db`, `-outfmt`, `-num_alignments`
   1. o "objeto" esta definido na opção `-query`;
   2. o database construido é obrigatório para o comando `-db`;
   3. o formato `6` de _output_ é uma tabela com algumas informações;
   4. pode-se definir um número limite de alinhamentos individuais a serem processados.

```
$ ./programas/ncbi-blast-2.17.0+/bin/blastp -query hemoglobina.fasta -db database/uniprot -outfmt 6 -num_alignments 10000 -evalue 1e-90 -out BLAST-hemoglobina.output.tsv
```
>[!TIP]
> Pode-se utilizar uma opção que limita para ter o número máximo de sequencias: `-max_target_seqs` - intuito não ter uma tabela gigante.

Inspecione o arquivo gerado: `BLAST-[protein].output.tsv`
> Como ele é grande não utilize o comando `cat`
```
$ ls -lh BLAST-hemoglobina.output.tsv

$ wc -l BLAST-hemoglobina.output.tsv

$ head BLAST-[protein].out ## tipo de arquivo .tsv
1    2        3 4           5             6     7      8   9      10  11     12
prot sequence % comprimento incongruencia Nº'-' inicio fim inicio fim evalue pontuação
```

&emsp; Veja o significado das 12 colunas dessa [tabela](https://www.metagenomics.wiki/tools/blast/blastn-output-format-6) (leia sobre ela). 

- Selecione as sequências que são similares a aquela proteína de interesse e separe esses códigos em um novo .
```
# Inspecione
$ cut -f 2 BLAST-hemoglobina.output.tsv | sort -u | head -n 50
# Salve os códigos da tabela 
$ cut -f 2 BLAST-hemoglobina.output.tsv | sort -u | grep "HBA" > list_hemoglobinA.txt
$ cut -f 2 BLAST-hemoglobina.output.tsv | sort -u | grep "HBB" > list_hemoglobinB.txt
```
- Crie um novo arquivo copiando e colando o conteúdo do script presente em [Workshop/STBio26/PrimeiroDia/catch_genes.sh](https://github.com/211295/Workshop/blob/main/Curso%20do%20Departamento%20de%20Gen%C3%A9tica/catch_genes.sh). Edite o nome de dentro do arquivo `catch_genes.sh` para os arquivos presente no **Diretório**
  1. **list_of_sequences.txt** = **list_hemoglobinA.out** ou **list_hemoglobinB.out**
  2. **all_proteins.fasta** = **uniprot_sprot.fa**
  3. **[output].fasta** = **sequencies_of_hemoglobinA.fasta** ou **sequencies_of_hemoglobinB.fasta**
```
$ nano catch_genes.sh ; chmod +x catch_genes.sh
# há outras formas de utilizar o chmod
$ chmod 755 catch_genes.sh
```

- Cole este script no editor (nano) 

```
#!/bin/bash
perl -e '
($id,$fasta)=@ARGV;
open(ID,$id);
while (<ID>) {
    s/\r?\n//;
    /^>?(\S+)/;
    $ids{$1}++;
}
$num_ids = keys %ids;
open(F, $fasta);
$s_read = $s_wrote = $print_it = 0;
while (<F>) {
    if (/^>(\S+)/) {
	$s_read++;
	if ($ids{$1}) {
	    $s_wrote++;
	    $print_it = 1;
	    delete $ids{$1}
	}
	else {
	    $print_it = 0
	}

    };
    if ($print_it) {
	print $_
    }
};
END {
    warn "Searched $s_read FASTA records.\nFound $s_wrote IDs out of $num_ids in the ID list.\n"
}
' list_of_sequences.txt all_proteins.fasta > [output].fasta;
```

- Edite o arquivo de proteínas do UniProt para o script `catch_genes.sh` funcionar sem algum problema. Neste caso, o script a baixo limpa o cabeçalho do arquivo `fasta` das proteínas. 
```
$ awk '{print $1}' uniprot_sprot.fasta > uniprot_sprot.fa ; rm uniprot_sprot.fasta
```
- Execute o arquivo utilizando o `./` (significa, executar neste diretório, caso queira executar um script/código no diretório anterior deve-se utilizar `../`. 
> Geralmente arquivos com `.sh` são referente a palavra `Shell` - o coração do sistema operacional.
```
$ ./catch_genes.sh
Searched 575748 FASTA records.
Found 36 IDs out of 36 in the ID list
# Edite para um novo nome de lista e novo nome de output
$ ./catch_genes.sh
Searched 575748 FASTA records.
Found 85 IDs out of 85 in the ID list

$ ll -h sequencies_of_hemoglobin[AB].fasta; grep -c '>' sequencies_of_hemoglobin[AB].fasta; grep -c '^M' sequencies_of_hemoglobin[AB].fasta; wc -l sequencies_of_hemoglobin[AB].fasta; head sequencies_of_hemoglobin[AB].fasta
```

***
## 3. Alinhamento Global ([MAFFT](https://pmc.ncbi.nlm.nih.gov/articles/PMC3603318/))
#### Nesta etapa iremos alinhar as sequências obtidas pelo BLASTP. Utilizaremos o programa [MAFFT](https://mafft.cbrc.jp/alignment/software/windows.html), podendo ser baixado seguindo o [tutorial do programa](https://mafft.cbrc.jp/alignment/software/linuxportable.html)
> Outros programas de alinhamento estão indicadas em [github/Teorica/README.md](https://github.com/211295/Workshop/tree/main/Teorica)

- Este programa também pode ser baixado pelo comando `wget`.
```
$ wget https://mafft.cbrc.jp/alignment/software/mafft-7.526-linux.tgz
$ tar xfzv mafft-7.526-linux.tgz

## abriu um monte de coisa

$ ls -F
mafft.bat*  mafftdir/
```
&emsp; Nesta etapa, o alinhamento será feito entre todos os aminoácidos. 
- E o que isso significa?
> Aminoácidos iguais irão ser associados à uma "posição" na sequência. Por exemplo se na posição 4 há um **V** (valina) para a maioria das sequências, as sequências sem **V** serão adocionados um traço "-" nesta posição, e isso será lido posteriormente como uma variação da proteína.

- Alinhe as proteínas utilizando o comando:
```
$ ./programas/mafft-linux64/mafft.bat --thread 4 --reorder --localpair sequencies_of_hemoglobinA.fasta > alignment_of_hemoglobinA.fasta
$ ./programas/mafft-linux64/mafft.bat --thread 4 --reorder --localpair sequencies_of_hemoglobinB.fasta > alignment_of_hemoglobinB.fasta
```
> [!TIP]
> É possível verificar os comandos do `mafft` tentando acioná-lo sem os devidos parâmetros `./programas/mafft-linux64/mafft.bat`

- Inspecione o arquivo final, e procure entender se faz sentido o resultado.
> Observe as proteínas que iniciam `M` (Metionina) e as que não iniciam.

> Se quiserem podem inspecionar um outro alinhamento de outra proteína ([muc1 - mucina 1 de tetrapode](https://github.com/211295/Workshop/blob/main/STBio26/PrimeiroDia/Muc1_tree.fasta))

***
## 4. Construção Filogenética ([IQTree](https://iqtree.github.io/doc/Home#why-iq-tree)) :iraq::tr::estonia:
#### Análise de similaridade de sequências e construção filogenética 

- Inicie procurando o programa para se baixar em 64-linux, e clique com o botão direito do mouse para copiar o link. Cole no **terminal** junto ao comando `wget` , como feito no `BLAST`.

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
Usa-se o comando `iqtree3` para criar o 
```
$ ./iqtree-3.1.4-Linux/bin/iqtree3 -s alignment_of_hemoglobina.fasta -nt 4
```
> Se não se especificar o modelo de substituição na opção `-m`, o programa define automaticamente
```
IQ-TREE version 3.1.4 for Linux x86 64-bit built Sep 10 2026
Developed by Bui Quang Minh, Thomas Wong, Nhan Ly-Trong, Huaiyan Ren
Contributed by Lam-Tung Nguyen, Dominik Schrempf, Chris Bielow,
Olga Chernomor, Michael Woodhams, Diep Thi Hoang, Heiko Schmidt

Host:    Br-SP95 (AVX512, FMA3, 3 GB RAM)
Command: /home/<user>/iqtree-3.1.4-Linux/bin/iqtree3_intel -s <alinhamento_prot>.fa -nt 4
Seed:    441864 (Using SPRNG - Scalable Parallel Random Number Generator)
Time:    Thu Sep 24 21:17:55 2026
Kernel:  AVX+FMA - 4 threads (8 CPU cores detected)
```
[...]
```
Create initial parsimony tree by phylogenetic likelihood library (PLL)... 0.002 seconds
Perform fast likelihood tree search using LG+I+G model...
Estimate model parameters (epsilon = 5.000)
Perform nearest neighbor interchange...
Estimate model parameters (epsilon = 1.000)
1. Initial log-likelihood: -4107.569
Optimal log-likelihood: -4107.529
Proportion of invariable sites: 0.070
Gamma shape alpha: 2.066
Parameters optimization took 1 rounds (0.016 sec)
Time for fast ML tree search: 0.134 seconds

NOTE: ModelFinder requires 6 MB RAM!
ModelFinder will test up to 1232 protein models (sample size: 151 epsilon: 0.100) ...
Akaike Information Criterion:           Q.YEAST+F+I+G4
Corrected Akaike Information Criterion: LG+I+G4
Bayesian Information Criterion:         LG+I+G4
Best-fit model: LG+I+G4 chosen according to BIC

All model information printed to <alinhamento_prot>.fa.model.gz
CPU time for ModelFinder: 18.711 seconds (0h:0m:18s)
Wall-clock time for ModelFinder: 4.720 seconds (0h:0m:4s)
```
[...]
```
--------------------------------------------------------------------
|                    FINALIZING TREE SEARCH                        |
--------------------------------------------------------------------
Performs final model parameters optimization
Estimate model parameters (epsilon = 0.010)
1. Initial log-likelihood: -4105.685
Optimal log-likelihood: -4105.684
Proportion of invariable sites: 0.072
Gamma shape alpha: 1.995
Parameters optimization took 1 rounds (0.015 sec)
BEST SCORE FOUND : -4105.684
Total tree length: 9.559

Total number of iterations: 124
CPU time used for tree search: 33.067 sec (0h:0m:33s)
Wall-clock time used for tree search: 8.273 sec (0h:0m:8s)
Total CPU time used: 54.078 sec (0h:0m:54s)
Total wall-clock time used: 13.570 sec (0h:0m:13s)

Analysis results written to:
  IQ-TREE report:                <alinhamento>.fa.iqtree
  Maximum-likelihood tree:       <alinhamento>.fa.treefile
  Likelihood distances:          <alinhamento>.fa.mldist
  Screen log file:               <alinhamento>.fa.log

Date and Time: Thu Sep 24 21:18:09 2026
```
- Verifique e inspesione o arquivo `*.iqtree` e `*.log`
  1. Identifique a linha onde esta a informação do Modelo selecionado. 
  2. Pesquise sobre os [tipos de modelo](https://iqtree.github.io/doc/Substitution-Models): Discuta sobre o modelo selecionado e [por quê](https://academic.oup.com/mbe/article/37/2/549/5613171). 

### Visualização da árvore (iTol)
#### Esta etapa pode ser feita da maneira que preferir. 

&emsp; Nós recomendamos uma visualização através de uma plataforma _on-line_ chamada [iTOL](https://itol.embl.de/). 

- Após verificar se a árvore foi gerada, pode dar um "print" nela com `cat` (arquivo pequeno) e copiar para área de `Visualize support values. Explore clade distances.` no site. Entre no "Upload a tree" e cole no espaço adqueado. Após colar o código da árvore basta clicar em `Upload`.
>[!TIP]
> Pode-se verificar que o site aceita carregar arquivos direto pelo computador. Mas devo lembrar que será apenas nos formatos _Newick_, _Nexus_ ou _PhyloXML_

- Outra opção é utilizar o código em [R](https://github.com/211295/Workshop/blob/main/STBio26/PrimeiroDia/Arvore.R) disponibilizado no tutorial. Para isto deve abrir o RStudio e rodar o script.
