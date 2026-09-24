# Workshop de Bioinformática do IV Curso de Genética no Verão (USP)
Criado por Felipe S. Salles || [LinkedIn](https://br.linkedin.com/in/felipe-simionato-salles-b3640120b) || [Lattes](http://lattes.cnpq.br/3781167913621025)

Revisado por Leandro Gonçalves || [LinkedIn](https://www.linkedin.com/in/leandro-gon45/) || [Lattes](http://lattes.cnpq.br/3096958278950054)

Assitentes: [Sophia Pereira Saraiva](http://lattes.cnpq.br/5576461458658817) e [Bruno J. Teixeira de Melo](http://lattes.cnpq.br/0513855441372488)
***
### Bem vindo ao mini tutorial do Workshop
###### Após a breve explicação sobre tipo de arquivos e abordagens de tipos de estudos, vamos iniciar o aprendizado do "terminal"


&emsp; Para começar iremos introduzir o terminal e a linguagem Bash/Linux. O terminal de um computador é a área onde conversamos com o computador sem a interface gráfica (portanto não utilizamos mouse para mover os arquivos ou clicar neles), permitindo usar scripts e comandos básicos para realizar as tarefas computacionais.

&emsp; Para quem possiu o sistema Linux basta apertar `Ctrl` + `Alt` + `T` . E para outros sistemas operacionais há aplicativos ou outras interfaces:

**Windows:** WSL, Ubuntu e Xmobe

**Android:** Andronix ou Termux

**IOS:** iSH ou a-Shell

&emsp; Iniciaremos com a visualização da tela e os primeiros comandos mais simples. Agora chamaremos todos os arquivos seguintes dependendo do conteundo dele. E cada um terá uma `terminação` especifica. E também toda pasta agora será chamada de `diretório`. 

&emsp; Procure o aplicativo chamado `Ubuntu`

**Ubuntu 24.04** :o:

Depois vamos iniciar com o comando que lista os arquivos e diretórios de um determinado local
```
$ ls
programas tutorial_workshop
```

Veja a diferença utilizando as opções `-l`, `-a`, `-h`, `-s`. Pode fazer combinação entre todas elas.
```
$ ls -l
$ ls -lh
$ ls -lash
```

&emsp; Interessante notar que as opções dos comandos não tem ordem correta, somente em alguns poucos casos onde uma opção tem que obrigatóriamente vir antes de outra.

Encontrou o diretório chamado `tutorial_workshop`? Vamos utilizar então agora um PADRÃO de comando que irá se repetir
```
[comando] -[opção] [objeto]
``` 

Portanto iremos usar o comando `ls` no diretório `tutorial_workshop`
```
$ ls tutorial_workshop
catch_genes.sh all_proteins.fasta transform_single_line_fasta.sh 
```

> Se quiser, pode usar o mesmo comando no outro diretório para ver qual o conteudo.

&emsp; Agora entramemos no `diretório` chamado `tutorial_workshop`. Se fosse um computador com interface gráfica você clicaria duas vezes na pasta para entrar nela, mas no nosso caso será em linha de comando, ao mesmo tempo que já mostraremos o conteudo dela. So é possivel por conta do `;`, pois o computador entende que isso seria uma linha nova:
``` 
$ cd tutorial_workshop ; ls -lh
```

&emsp; Percebe-se que há dois script (verde) de final ".sh" e um fasta. Utilizaremos um `catch_genes.sh` para recuperarmos as sequências do arquivo fasta das proteinas de Eukariotos.
***
### Inspecionar os arquivos
&emsp; Agora vamos inspecionar os arquivos. O tamanho já nos foi dado, precisamos ver o conteudo. Para inspecionar os arquivos temos diversos comandos: `head`, `tail`, `more`, `less`, `cat`, `tac` ... Cada um com suas especificidades. 

&emsp; Este arquivo de proteinas foi baixada do site [UniProt](https://www.uniprot.org/uniprotkb). São as proteínas de todos os organismos vivos. Vamos trabalhar com um fasta com muitas sequências, todas proteínas, porém poderia ser um genoma, um trasncriptoma, sequencias codificadoras, etc...

> [!WARNING]
>:warning: Procure não usar o `cat` ou `tac` para arquivos muito grandes :warning:

``` 
$ head all_proteins.fasta
>sp|Q6GZX4|001R_FRG3G Putative transcription factor 001R OS=Frog virus 3 (isolate Goorha) OX=654924 GN=FV3-001R PE=4 SV=1
MAFSAEDVLKEYDRRRRMEALLLSLYYPNDRKLLDYKEWSPPRVQVECPKAPVEWNNPPSEKGLIVGHFSGIKYKGEKAQASEVDVNKMCCWVSKFKDAMRRYQGIQTCKIPGKVLSDLDAKIKAYNLTVEGVEGFVRYSRVTKQHVAAFLKELRHSKQYENVNLIHYILTDKRVDIQHLEKDLVKDFKALVESAHRMRQGHMINVKYILYQLLKKHGHGPDGPDILTVKTGSKGVLYDDSFRKIYTDLGWKFTPL
>sp|Q6GZX3|002L_FRG3G Uncharacterized protein 002L OS=Frog virus 3 (isolate Goorha) OX=654924 GN=FV3-002L PE=4 SV=1
MSIIGATRLQNDKSDTYSAGPCYAGGCSAFTPRGTCGKDWDLGEQTCASGFCTSQPLCARIKKTQVCGLRYSSKGKDPLVSAEWDSRGAPYVRCTYDADLIDTQAQVDQFVSMFGESPSLAERYCMRGVKNTAGELVSRVSSDADPAGGWCRKWYSAHRGPDQDAALGSFCIKNPGAADCKCINRASDPVYQKVKTLHAYPDQCWYVPCAADVGELKMGTQRDTPTNCPTQVCQIVFNMLDDGSVTMDDVKNTINCDFSKYVPPPPPPKPTPPTPPTPPTPPTPPTPPTPPTPRPVHNRKVMFFVAGAVLVAILISTVRW
>sp|Q197F8|002R_IIV3 Uncharacterized protein 002R OS=Invertebrate iridescent virus 3 OX=345201 GN=IIV3-002R PE=4 SV=1
MASNTVSAQGGSNRPVRDFSNIQDVAQFLLFDPIWNEQPGSIVPWKMNREQALAERYPELQTSEPSEDYSGPVESLELLPLEIKLDIMQYLSWEQISWCKHPWLWTRWYKDNVVRVSAITFEDFQREYAFPEKIQEIHFTDTRAEEIKAILETTPNVTRLVIRRIDDMNYNTHGDLGLDDLEFLTHLMVEDACGFTDFWAPSLTHLTIKNLDMHPRWFGPVMDGIKSMQSTLKYLYIFETYGVNKPFVQWCTDNIETFYCTNSYRYENVPRPIYVWVLFQEDEWHGYRVEDNKFHRRYMYSTILHKRDTDWVENNPLKTPAQVEMYKFLLRISQLNRDGTGYESDSDPENEHFDDESFSSGEEDSSDEDDPTWAPDSDDSDWETETEEEPSVAARILEKGKLTITNLMKSLGFKPKPKKIQSIDRYFCSLDSNYNSEDEDFEYDSDSEDDDSDSEDDC
>sp|Q197F7|003L_IIV3 Uncharacterized protein 003L OS=Invertebrate iridescent virus 3 OX=345201 GN=IIV3-003L PE=4 SV=1
MYQAINPCPQSWYGSPQLEREIVCKMSGAPHYPNYYPVHPNALGGAWFDTSLNARSLTTTPSLTTCTPPSLAACTPPTSLGMVDSPPHINPPRRIGTLCFDFGSAKSPQRCECVASDRPSTTSNTAPDTYRLLITNSKTRKNNYGTCRLEPLTYGI
>sp|Q6GZX2|003R_FRG3G Uncharacterized protein 3R OS=Frog virus 3 (isolate Goorha) OX=654924 GN=FV3-003R PE=3 SV=1
MARPLLGKTSSVRRRLESLSACSIFFFLRKFCQKMASLVFLNSPVYQMSNILLTERRQVDRAMGGSDDDGVMVVALSPSDFKTVLGSALLAVERDMVHVVPKYLQTPGILHDMLVLLTPIFGEALSVDMSGATDVMVQQIATAGFVDVDPLHSSVSWKDNVSCPVALLAVSNAVRTMMGQPCQVTLIIDVGTQNILRDLVNLPVEMSGDLQVMAYTKDPLGKVPAVGVSVFDSGSVQKGDAHSVGAPDGLVSFHTHPVSSAVELNYHAGWPSNVDMSSLLTMKNLMHVVVAEEGLWTMARTLSMQRLTKVLTDAEKDVMRAAAFNLFLPLNELRVMGTKDSNNKSLKTYFEVFETFTIGALMKHSGVTPTAFVDRRWLDNTIYHMGFIPWGRDMRFVVEYDLDGTNPFLNTVPTLMSVKRKAKIQEMFDNMVSRMVTS
```
> Caso queira pode verificar a [tabela de proteínas](https://www.hgmd.cf.ac.uk/docs/cd_amino.html) e suas siglas.

OU

``` 
$ more all_proteins.fasta
```
>  Para sair da página do comando 'more' aperte a tecla 'Q', de quit

Caso queira entender o que cada comando faz, você pode:
1. Testar com "tentativa e erro", utilizando o padrão `[comando]` `-[opção]` `[objeto]`
2. Utilizar o comando manual `man`, information`info` ou a opção `--help` para os comandos.

``` 
$ man [comando]
$ info [comando]
$ [comando] --help
```
> Para sair do manual basta clicar na tecla 'Q', de quit

&emsp; Agora inspecionaremos o arquivo fasta com um pouco mais de detalhes. Contaremos quantas sequencias há no arquivo `fasta`. Cada início de sequência tem seu cabeçalho iniciado por `>___` e na linha de baixo o conteudo da sequência. Iremos tambem calcular quantas linhas INICIAM com o aminoacido `Metionina` e a quantidade de linhas totais no arquivo. E ai qual o resultado? Discuta o por quê disso.

```
$ grep -c ">" eukaria_protein.fasta
574627
$ grep -c "^M" eukaria_protein.fasta
559763
$ wc -l eukaria_protein.fasta
1149254 all_proteins.fasta
```

OU

```
$ grep ">" eukaria_protein.fasta | wc -l
574627
$ grep "^M" eukaria_protein.fasta | wc -l
559763
$ wc -l eukaria_protein.fasta
1149254 all_proteins.fasta
```

&emsp; O primeiro comando conta automaticamente o numero de linhas que apresentam o sinal '>' e o segundo comando seleciona as linhas que apresentam '>' - ou seja, ele seleciona os 'headers', e DEPOIS conta o número de linhas total do comando anterior. Só é possivel isso pois utilizamos o 'pipe' `|` - significa 'tubo'  ou 'cano' - portanto o resultado (output) do `grep` entra em um cano e segue automaticametne para o proximo comando.

&emsp; Agora inspecione com `cat` os arquivos `*.sh` (**Shell**). Pode observar que ambos tem um cabeçalho único: `#!/bin/bash`.
Esta linha exige que o arquivo seja lido pelo computador de um jeito especial. E isso trasnforma os arquivos textos em "scripts".

***
### Baixar os arquivos
##### Vamos iniciar e baixar nossa proteina de interesse no site do NCBI.

⚠️ Agora importante se certificar que a proteina a ser baixada está no diretório que será trabalhado e com algum nome que seja útil e informativo para você. Portanto vamos renomear, caso necessário, e mover o arquivo até o diretório `tutorial-workshop`

&emsp; Vá até o site do [NCBI](https://www.ncbi.nlm.nih.gov/protein/), e procure na aba de pesquisa pela proteina "Histone [nome_de_uma_espécie]", ou qualquer outra proteina que você conheça, de preferença uma proteina bem estudada. Clique no botão `FASTA` abaixo e então copie o conteudo e vamos colar em um arquivo.

Para criar um arquivo usamos o comando `touch`. E para edita-lo usamos o comando `nano`
> Obs1: geralmente usamos o nano diretamente em um arquivo não existente, pois ele já cria automaticamente, pulando o comando touch

> Obs2: para sair do `nano` utilize `Ctrl` + `X` => y + `ENTER`
```
$ touch [proteina_espécie].fasta
$ nano [proteina_espécie].fasta
```

Caso você consiga o link do arquivo que apresenta a sequência, pode baixar com comando `wget`
```
$ wget [link]
```

Mudando o nome  ou mova o arquivo para o diretório que você quer trabalhar
```
$ mv [nome_antigo] [nome_novo]
$ mv [arquivo] -t [diretório]
```
***
### Alinhamento local (BLAST)
&emsp; Agora iremos rodar o primeiro programa, o BLAST ([baixado](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/) diretamente no computador com o comando `wget`), para alinhar as proteínas que queremos adquirir com a proteína alvo. Nesta etapa vale a pena e pesquisar e [ler um pouco sobre](https://pmc.ncbi.nlm.nih.gov/articles/PMC441573/). Utilizaremos o comando `blastp` para alinhar proteína com todas as outras proteínas.

&emsp; Primeiramente, devemos criar um banco com o comando `makeblastdb` do programa BLAST. Para isso vamos criar um novo diretório (`mkdir`), copiar o arquivo fasta de proteinas neste diretório criado, e depois utilizar o comando no arquivo clonado.

```
$ mkdir database/ ; cp all_proteins.fasta database/
$ ../programas/ncbi-blast-2.17.0+/bin/makeblastdb -in database/all_proteins.fasta -out database/database_all_proteins -dbtype prot
$ ../programas/ncbi-blast-2.17.0+/bin/blastp -query [proteina_espécie].fasta -db database/database_all_proteins -outfmt 6 -evalue 1e-15 -out BLAST-[protein].out
```

Pode obsverar que o "comando" é `blastp`, as "-opções" são  `-out`, `-query`, `db`, `outfmt` e o "objeto" esta definido na "-opção" `-query`.

Podemos utilizar uma opção que limita para ter 30 sequencias no máximo `max_target_seqs`, para não ter uma tabela gigante.

Inspecione o arquivo gerado: `BLAST-[protein].out`
> Como ele não é grande vamos usar o `cat`
```
$ ls -lh BLAST-[protein].out ; wc -l BLAST-[protein].out ; head BLAST-[protein].out ## tipo de arquivo tsv
1    2        3 4           5             6     7      8   9      10  11     12
prot sequence % comprimento incongruencia Nº'-' inicio fim inicio fim evalue pontuação
```

&emsp; Veja que temos 12 colunas dessa [tabela](https://www.metagenomics.wiki/tools/blast/blastn-output-format-6) (leia sobre ela). E precisamos pegar então as sequências que são similares a aquela proteína que foi escolhida. Usaremos um outro comando, e após isso usaremos um script já pronto `catch_genes.sh`:
```
$ awk '{print $2}' BLAST-[protein].out | uniq > list_of_sequences.txt
$ wc -l list_of_sequences.txt
```
Então, precisamos editar o `catch_genes.sh`: precisa substituir o `[input].txt` pela sua lista `list_of_sequences.txt` e o `[output].fasta` por `sequencies_of_[protein].fasta`. E depois rodar o script. Para rodar o tem que se utilizar `./`.

🕯️ Relembre que para sair do `nano` utilize `Ctrl` + `X` => y 
```
$ nano catch_genes.sh
$ ./catch_genes.sh
Searched 574627 FASTA records.
Found 30 IDs out of 30 in the ID list
$ ls -h sequencies_of_[protein].fasta; grep -c '>' sequencies_of_[protein].fasta; grep -c '^M' sequencies_of_[protein].fasta; wc -l sequencies_of_[protein].fasta; head sequencies_of_[protein].fasta
```

***
### Alinhamento global (MAFFT)
&emsp; Após a seleção dessas sequências, vamos fazer o alinhamento de todas elas aminoácido por aminoácido. E o que isso significa? Significa que aminoácidos iguais irão ser associados à uma posição na sequência. Por exemplo se na posição 4 há um **V** (valina) para a maioria das sequências, as sequências sem **V** serão adcionados um traço "-" , e isso será lido posteriormente como uma variação da proteína.

Para isso usaremos o programa [MAFFT](https://pmc.ncbi.nlm.nih.gov/articles/PMC3603318/). Este programa ja foi [baixado](https://mafft.cbrc.jp/alignment/software/linuxportable.html). Pode verificar no diretório de programas.
```
$ ls ../programas/
ncbi-blast-2.17.0+/  mafft-7.526-linux/  iqtree-3.0.1-Linux/
```
Agora vamos rodar o `mafft`:
```
$ mkdir output
$ mafft --maxiterate 1000 --globalpair --reorder sequencies_of_[protein].fasta > output/sequencies_of_[protein].aligned.fasta
```

Podemos agora analisar esse alinhamento (pode entrar no `diretório` `out` ou continuar no seu `diretório`)
```
$ cd output # este passo é opcional, você pode checar todas essas informações do diretório anterior
$ ls -h sequencies_of_[protein].aligned.fasta; grep -c '>' sequencies_of_[protein].aligned.fasta; grep -c '^M' sequencies_of_[protein].aligned.fasta; wc -l sequencies_of_[protein].aligned.fasta; head sequencies_of_[protein].aligned.fasta
```
***
### Checagem do alinhamento (ESTE PASSO É EXTRA, FAÇA SOMENTE SE HOUVER TEMPO)
&emsp; Após o alinhamento, podemos checar de vários jeitos se deu certo ou nâo. Um dos jeitos que eu gosto de checar é contando se o número de cabeçalhos bate com com o número do tamanho das sequências. Ou seja, construiremos um novo arquivo com o cabeçalho da sequencie o comprimento da sequencia substituindo o conteudo.
Por exemplo:
```
input.fasta           | length.fasta
>Gsera|XP_033779291.1 | >Gsera|XP_033779291.1
ATGCGATAGCGATCG...    | 2754
>Munic|XP_030043466.1 | >Munic|XP_030043466.1
ATGGAGAGTGAGGAA...    | 1653
>Munic|XP_030043465.1 | >Munic|XP_030043465.1
ATGAGCCGATCGAGC...    | 1998
>Munic|XP_030043464.1 | >Munic|XP_030043464.1
ATGGAGGAGATTCTA...    | 2034
>Xlaev|XP_041429787.1 | >Xlaev|XP_041429787.1
ATGGAGTGACCACGA...    | 1935
```
**No caso de um fasta alinhado, todos esses comprimentos são iguais**. Portanto iremos contar o número de comprimentos que sejam iguais.

Vamos utilizar outro script que pode-se encontrar aqui no [github]([https://github.com/211295/Workshop](https://github.com/211295/Workshop/blob/main/Pratica%20Linux/fasta_length.sh)) chamado "fasta_length.sh"
```
$ nano fasta_lenght.sh ; chmod +x fasta_lenght.sh
$ ./fasta_lenght.sh
$ head -n 2 length_of_*.fasta
>Gsera|XP_033779291.1
2754 ## este é o comprimento
$ grep -c '>' length_of_*.fasta ; grep -c '[comprimento]' lentgh_of_*.fasta
91
91
```
Se os números forem iguais, significa que deu certo.

***
### Construção de uma árvore por similaridade (IQTree)
&emsp; Próximo passo iremos ver o quão relacionada estão essas sequências através da similaridade que eles apresentam . O programa novamente esta [baixado](https://iqtree.github.io/) e só deveremos rodar a linha de comando. Este programa necessita um arquivo fasta alinhado globalmente, gerado pelo `mafft`. Poderiam ter usado outros programas para alinhamento, mas alguns não gerão o arquivo fasta.

| Programas que alinham | Tipo de arquivo gerado | website |
|:-----------------------|:-------------------------:|:---------------------------------------------------------------:|
| HyPhy | fasta | [https://hyphy.org/](https://hyphy.org/)|
| MEGA | fasta | [https://megasoftware.net/docs](https://megasoftware.net/web_help_12/index.htm#t=Part_I_Getting_Started%2FA_Walk_Through_MEGA%2FAligning_Sequences.htm%23bc-1&rhtocid=_7_3_1)|
| MACSE | fasta | [https://www.agap-ge2pop.org/macse/](https://www.agap-ge2pop.org/alignsequences/)|
| ClustalW | fasta | [https://www.genome.jp/tools-bin/clustalw](https://www.genome.jp/tools-bin/clustalw)|
| MUSCLE | clustal | [https://www.drive5.com/muscle/](https://www.drive5.com/muscle5/manual/getting_started.html)|
| MINIMAP2 | sam | [https://github.com/lh3/minimap2](https://github.com/lh3/minimap2)|

```
$ ../programas/ncbi-blast-2.17.0+/bin/iqtree3 -s sequencies_of_[protein].aligned.fasta -mem 60G --threads-max 12 -m MFP -B 1000
```
Agora verifique os outputs , utilize os comandos que você ja aprendeu `ls`, `cat`, `head`, `more`, `wc`...

***
### Visualização da árvore (iTol)
Após verificar a árvore, pode dar um "print" nela com `cat` e copiar e colar em algum software pare visualização.
Entre no site [iTol](https://itol.embl.de/)
Entre no "Upload a tree" e cole no espaço adqueado.
