# PRIMEIRA PARTE: TRANSCRIPTÔMICA COMPARATIVA
### Desenvolvido por Leandro de Brito Gonçalves
### Revisado por Felipe Simionato Salles
***

&emsp; Nesta parte do curso, pretendemos comparar duas amostras de RNA-seq, uma controle e uma condição, quantificando a abundância relativa de transcritos, medida em TPM (*transcripts per million*), e identificar genes que são mais transcritos em cada situação.

&emsp; O trabalho de referência é um esforço contra a pandemia de COVID-19 e fez um *screening* de transcrição em diversos tipos celulares infectados por diversos vírus respiratórios. Usaremos duas corridas específicas: **SRR11517744** (controle, células CALU-3, tipo de adenocarcinoma de pulmão) e **SRR11517748** (doença, infecção por SARS-CoV-2).

>  [Blanco-Melo et al., Cell 2020](http://www.cell.com/pb-assets/products/coronavirus/CELL_CELL-D-20-00985.pdf) :page_facing_up:

## MAPA DE PROCESSOS

> [!TIP]
> **Parte 1**
>
> FASTQ → [Controle de qualidade: **fastp**] → FASTQ limpo + Genoma_viral.fasta + GENCODE.fasta → [Quantificação: **salmon**] → `quant.sf` → [script Python] → tabela comparativa → [**Enrichr**] → termos GO

> [!TIP]
> **Parte 2**
>
> Genoma_viral.fasta + FASTQ → [Alinhamento: **BWA**] → BAM → [Filtragem: **samtools**] → BAM viral → Visualização no **IGV**

## OS MATERIAIS QUE VAMOS USAR

| Arquivo: | O que é |
| :--- | :--- |
| `SRR11517744.subsample.fastq` | sequenciamento bruto depositado, controle |
| `SRR11517748.subsample.fastq` | sequenciamento bruto depositado, infectado |
| `gencode.v50.transcripts.fa` | referência de transcriptoma humano |
| `NC_045512.2.fa` | genoma do SARS-CoV-2 |

---

## 0. Ativando o ambiente conda

> [!IMPORTANT]
> Antes de tudo, ative o ambiente Conda. Esquecer este passo é a causa número um de erros do tipo `command not found`.

```sh
conda activate curso_toolbox
```

> [!TIP]
> Se quiser ou precisar desativar o ambiente conda: `$ conda deactivate`

---

## 1. Baixando e preparando os dados

&emsp; Primeiro, vamos baixar o genoma viral:

```bash
wget -O NC_045512.2.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_045512.2&rettype=fasta&retmode=text"
```

&emsp; Em seguida, a referência para o transcriptoma:

```bash
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz
```

&emsp; O arquivo do GENCODE vem comprimido e com cabeçalhos muito longos, cheios de campos separados por `|`. O comando abaixo descomprime e simplifica o cabeçalho:

```bash
zcat gencode.v50.transcripts.fa.gz | awk -F'|' '/^>/{print ">"substr($1,2)"_"$6; next}{print}' > gencode.v50.transcripts.fa
```

> [!TIP]
> **O que significa o comando?**
>
> * **`zcat`**: descomprime o arquivo enviando o conteúdo para a saída padrão, sem criar arquivo intermediário (no macOS, use `gzcat`);
> * **`|` (pipe)**: entrega a saída do `zcat` direto para o `awk`;
> * **`awk -F'|'`**: define a barra vertical como separador de campos;
> * **`/^>/`**: aplica a regra apenas às linhas que começam com `>`, ou seja, os cabeçalhos;
> * **`substr($1,2)`**: pega o primeiro campo sem o caractere `>`;
> * **`$6`**: é o símbolo do gene;
> * **`next`**: pula para a próxima linha sem aplicar as demais regras;
> * **`{print}`**: imprime todas as outras linhas (as sequências) sem alteração.

&emsp; Os arquivos SRR são razoavelmente pesados. Para agilizar, deixamos previamente baixados.

 -----------------------SRR***

> [!NOTE]
> Estes arquivos são sub-amostras do sequenciamento completo. Optamos por fazer isso para reduzir o tamanho do SRR e também o tempo de processamento.

&emsp; O programa que vamos usar aceita apenas uma entrada, não tem problema. Vamos concatenar (juntar em um único arquivo) os arquivos FASTA:

```bash
cat gencode.v50.transcripts.fa NC_045512.2.fa > ref.fa
```

&emsp; Para Conferir quantas sequências entraram na referência:

```bash
grep -c '>' gencode.v50.transcripts.fa
```
```bash
grep -c '>' ref.fa
```
O total de _reads_ em `ref.fa` deve ser igual a do `gencode.v50.transcripts.fa` + 1, que é o `NC_045512.2.fa`
> [!TIP]
> **O que significa o comando?**
> * **`grep`**: Comando que busca termos num arquivo de texto
> * **`-c`**: Aciona a função contar
> * **`'>'`**: Conta quantas ">" tem
---

## 2. Controle de qualidade

&emsp; É necessário remover os adaptadores de sequenciamento. Como boa prática, é importante conferir o controle de qualidade do sequenciamento. Lembra que essa informação fica armazenada no FASTQ? O melhor jeito e mais rápido hoje é o **fastp**, que faz as duas coisas:

```sh
fastp -i SRR11517744.subsample.fastq -o SRR11517744.clean.fastq  -j controle_report.json  -h controle_report.html
```

```sh
fastp -i SRR11517748.subsample.fastq -o SRR11517748.clean.fastq -j infectado_report.json -h infectado_report.html
```

&emsp; Abra os arquivos `.html` no navegador.

-------------Leitura do controle de qualidade

---

## 3. Preparando o índice

&emsp; O que é um índice? Uma estrutura de busca pré-processada. Sem ela, para cada read o software precisaria varrer centenas de milhares de transcritos. É o mesmo princípio do índice remissivo no fim de um livro. Isso ajuda muito no processamento!

&emsp; Existem muitos quantificadores de transcriptoma. Usaremos o **Salmon**, pois é ultrarrápido, não usa um alinhador externo e é bastante eficiente.

Para criar um índice para o Salmon:

```bash
salmon index -t ref.fa -i index_dir -k 31 -p 4
```

> [!TIP]
> **O que significa o comando?**
>
> * **`-t`**: o arquivo FASTA de referência;
> * **`-i`**: o **diretório** de saída do índice (são vários arquivos, não um só);
> * **`-k 31`**: tamanho do k-mer, ou seja, o comprimento dos pedaços em que a referência é fatiada. 31 é o padrão e funciona bem para reads de 75 bases ou mais;
> * **`-p 4`**: número de *threads*.

> [!CAUTION]
> Este passo leva alguns minutos (Comigo durou 6min).

---

## 4. Quantificando com o Salmon  ><(((°>

&emsp; Vamos estimar a expressão quantificando os transcritos de cada um dos arquivos. Rode um, quando terminar, rode o outro. Isso deve demorar cerca de 5 min cada.

```bash
salmon quant -i index_dir -l A -r SRR11517744.clean.fastq  -p 4 -o quantificação_controle
```

```bash
salmon quant -i index_dir -l A -r SRR11517748.clean.fastq -p 4 -o quantificação_infectado
```

> [!TIP]
> **O que significa o comando?**
>
> * **`-i`**: o índice criado no passo anterior;
> * **`-l A`**: tipo de biblioteca. O `A` deixa o Salmon **detectar automaticamente** a partir dos próprios dados. Errar essa opção manualmente arruína a quantificação sem gerar mensagem de erro;
> * **`-r`**: arquivo de reads *single-end* (se fosse *paired-end*, seria `-1` e `-2`);
> * **`-p 4`**: *threads*;
> * **`-o`**: diretório de saída.

> [!CAUTION]
> Este passo pode levar alguns minutos mas usa bastante memória RAM.

> [!IMPORTANT]
> **Vamos checar** Confira a taxa de mapeamento de cada amostra:
>
> ```bash
> grep percent_mapped quantificação_*/aux_info/meta_info.json
> ```
>
> Espere algo próximo 90%, no mínimo, 70%. Valores muito abaixo disso indicam "incompatibilidade" na referência ou no arquivo de entrada, por exemplo, quando usamos um genoma de uma espécie muito distante.

---

## 5. Visualização dos dados

&emsp; O Salmon entrega os seguintes arquivos de saída que nos importam:

- `aux_info/meta_info.json`, que é o arquivo de metadados;
- `quant.sf`, um TSV com os dados de quantificação.

Use o `head` em um dos arquivos `quant.sf` e veja que tem as seguintes colunas, que significam:

| Coluna | Descrição |
| :--- | :--- |
| Name | *Header* do transcrito ou nome do gene/transcrito/proteína |
| Length | Tamanho, em nucleotídeos |
| EffectiveLength | Número de posições em que um fragmento médio pode se alinhar ao transcrito |
| TPM | Métrica normalizada de expressão (*transcripts per million*) |
| NumReads | Valor estimado de leituras que mapearam em cima do transcrito |

> [!NOTE]
> A coluna `NumReads` pode vir com casas decimais. Não é erro. Quando uma _read_ é alinhavel com várias referências (normalmente isoformas ou parálogos) ele reparte a _read_ proporcionalmente à abundância estimada de cada uma. Ou seja, não é uma contagem literal.

Vamos ver as 30 primeiras linhas em colunas alinhadas e fáceis de ler:

```bash
head -30 quant_controle/quant.sf | column -t
```

Mas nós queremos ver aqueles com maior TPM, que é a **coluna 4**:

```bash
sort -nrk4 quant_controle/quant.sf | head -30 | column -t
```

> [!TIP]
> **O que significa o comando?**
>
> * **`sort -nrk4`**: ordena pela coluna 4 (`n` = numérico, `r` = decrescente, `k4` = coluna 4).;
> * **`head`**: lista as 30 primeiras linhas  
> * **`column -t`**: alinha as colunas na tela.

Temos um script escrito em Python que vai nos ajudar a comparar as duas quantificações que fizemos:

```bash
python3 comparar_salmon.py quant_A/quant.sf quant_B/quant.sf --nome-a NOME --nome-b NOME --saida ARQUIVO
```

Por exemplo:

```bash
python3 comparar_salmon.py quant_controle/quant.sf quant_infectado/quant.sf \
    --nome-a Controle --nome-b SARS_CoV_2 --saida comparacao.tsv
```

------- Leitura do arquivo de saída

> [!WARNING]
> Temos **uma amostra por condição**. Isso permite comparar valores de TPM e ordenar genes por variação, mas **não permite fazer estatística** O que faremos aqui é análise exploratória.

---

## 6. Enriquecimento funcional

&emsp; Beleza. Sabemos quais os transcritos que são mais expressos em cada situação, e ainda temos os valores de *fold change*, que permitem comparar o perfil de transcrição em cada contexto. Mas qual o significado biológico disso?

&emsp; Enriquecimento funcional é uma análise estatística que associa uma lista de genes a termos do Gene Ontology (Processos Biológicos, Funções Moleculares e Componente Celular). Ou seja, podemos relacionar quais funções biológicas a literatura associa a cada gene.

&emsp; Primeiro, vamos extrair uma lista dos 150 genes com maior aumento em COVID:

```bash
awk -F'\t' '$7=="sim" && $6>1 {print $1}' comparacao.tsv | head -n 150
```

> [!TIP]
> **O que significa o comando?**
>
> * **`$7=="sim"`**: mantém apenas genes que passaram no filtro de expressão mínima;
> * **`$6>1`**: mantém apenas genes com log2FC maior que 1, ou seja, que pelo menos dobraram;
> * **`$1`**: imprime o nome do gene.

&emsp; Para isso, existem plataformas web como KEGG (Kyoto Encyclopaedia of Genes and Genomes) e o Gene Ontology. Vamos usar o Enrichr que usa o GO mas gera gráficos.
Acesse o [Enrichr](https://maayanlab.cloud/Enrichr/). 

1. Cole a lista de genes no quadro e clique em **Submit**
2. No topo da página que abrir, clique em **Ontologies**
3. Clique no quadro **GO Biological Process**

--------- Leitura do Enricher

Podemos navegar também nos quadros **GO Cellular Component** e **GO Molecular Function**.

Podemos ver os arquivos sem comparação também (os quant.sf), apenas os mais expressos em cada contexto:

```bash
sort -nrk4 quant_controle/quant.sf  | cut -f1 | head -150 | cut -d'_' -f2-
```

```bash
sort -nrk4 quant_infectado/quant.sf | cut -f1 | head -150 | cut -d'_' -f2-
```

&emsp; O `cut -d'_' -f2-` pega apenas o símbolo do gene, que é o que o Enrichr reconhece.

---

# SEGUNDA PARTE: ALINHAMENTO GENOMA-TRANSCRIPTOMA

## 7. Alinhamento com o BWA

&emsp; Para essa parte, vamos usar o mesmo genoma de SARS-CoV-2 que usamos, `NC_045512.2.fa`, e vamos alinhar as *reads* do arquivo SRR infectado contra esse genoma, pois neste sabemos que há leituras virais. Mas antes, vamos ver como está escrito o cabeçalho do arquivo FASTA:

```bash
head -1 NC_045512.2.fa
```

Será necessário que o *header* do arquivo FASTA seja igual ao nome do "cromossomo" no genoma que o IGV vai carregar (passo 10):

```bash
sed -i '1s/.*/>NC_045512.2/' NC_045512.2.fa
```

> [!TIP]
> **O que significa o comando?**
>
> * **`sed`**: é um programa Linux para edição de texto;
> * **`-i`**: é a opção de editar diretamente o arquivo original (*in-place*);
> * **`'1s/.*/>NC_045512.2/'`**: instrução para substituir todo o conteúdo da primeira linha por `>NC_045512.2`.

&emsp; Por que isso importa? Esse nome vai ser copiado para dentro do arquivo de alinhamento e usado como identificador do "cromossomo". Lá na frente, o IGV vai comparar esse nome com o do genoma que carregamos. Se os dois não baterem, o IGV carrega tudo sem dar erro nenhum — e mostra uma tela vazia. É um dos problemas mais difíceis de diagnosticar justamente porque não é considerado uma falha, mas, a abertura de projetos diferentes.

&emsp; Existe uma diversidade de alinhadores (Bowtie2, STAR, HISAT...), e cada um tem especificidades e objetivos diferentes (Anexo Tabela_Alinhadores.md). Para essa prática, vamos usar o BWA por estas razões:

- Primeiro, porque o SARS-CoV-2 **não tem íntrons**. O genoma dele é RNA contínuo, sem *splicing*. Alinhadores como STAR e HISAT2 existem exatamente para lidar com esse salto, e resolver esse problema custa memória e tempo.
- Segundo, temos um RNA-seq de Illumina, com *short reads*. Outros alinhadores lidam melhor com *long reads*

> *Reflexão*: o que importa não é o nome do alinhador, e sim saber qual problema temos e qual ferramenta o resolve. O Bowtie2 faria exatamente o mesmo trabalho.

Vamos criar o índice para o BWA:

```bash
bwa index NC_045512.2.fa
```

&emsp; Repare que surgiram cinco arquivos novos: `.amb`, `.ann`, `.bwt`, `.pac` e `.sa`. Você nunca vai abri-los. São de uso interno do programa (lembra que o índex é para o computador ler o arquivo?).

&emsp; Com o índice em mãos, poderemos usar o alinhador. O comando abaixo alinha o RNA-seq contra o genoma viral e o Samtools ordena o resultado:

```bash
bwa mem -t 2 NC_045512.2.fa SRR11517748.clean.fastq | samtools sort -@ 2 -o infectado.bam -
```

> [!TIP]
> **O que significa o comando?**
>
> * **`bwa`**: é o programa alinhador;
> * **`mem`**: é o algoritmo de alinhamento (*Maximal Exact Matches*);
> * **`-t 2`**: define o uso de 2 *threads* (processamento em paralelo);
> * **`NC_045512.2.fa`**: é o genoma de referência em FASTA (o BWA busca automaticamente os 5 arquivos de índice na mesma pasta);
> * **`SRR11517748.subsample.fastq`**: é o arquivo FASTQ com as *reads*;
> * **`|` (pipe)**: redireciona a saída do BWA diretamente para a entrada do `samtools`;
> * **`sort`**: subcomando do `samtools` que reordena os alinhamentos por coordenada genômica;
> * **`-@ 2`**: define 2 *threads* para o `samtools sort`;
> * **`-o infectado.bam`**: especifica o nome do arquivo BAM de saída;
> * **`-` (traço final)**: indica que a entrada de dados vem do *pipe*.

> [!NOTE]
> Lembra do *pipe* ? Com o *pipe*, os dados saem do BWA direto para a do samtools, usando apenas memória RAM sem nunca tocar o disco (Chama-se STDIN (Standard Input). Pulamos uma etapa!

> [!CAUTION]
> Este passo pode demorar alguns minutos.

> [!NOTE]
> Reparou que tanto o BWA quanto o Samtools usam uma opção para definir o número de _threads_, mas, o BWA usa `-t` e o Samtools `-@`?
> Infelizmente não existe um padrão universal e cada desenvolvedor escolhe um símbolo para essa função

Vamos precisar criar outro índice, agora para a leitura novo arquivo BAM que acabamos de criar:

```bash
samtools index infectado.bam
```

&emsp; Surge um arquivo `infectado.bam.bai`. Ele permite pular para qualquer região do alinhamento sem ler o arquivo inteiro, e é o que fará a navegação no IGV ser "instantânea".

Vamos ver algumas informações?

```bash
samtools flagstat infectado.bam
```
> [!IMPORTANT]
> **O que a saída mostra, linha a linha:**
>
> * **`in total`** — o número de reads processados. Deve bater com o número de reads do FASTQ;
> * **`mapped`** — quantos encontraram posição no genoma viral, em número absoluto e em porcentagem. **É a linha que interessa**;
> * **`primary`, `secondary`, `supplementary`** — categorias de alinhamento. Um mesmo read pode ter mais de um registro; os secundários são alinhamentos alternativos;
> * **`duplicates`** — zero aqui, porque não rodamos marcação de duplicatas.

> [!IMPORTANT]
> **Ponto de checagem.** A porcentagem de _reads_ mapeados deve ficar em torno de **17%**. Os outros ~83% são _reads_ humanos.
>
> Note que esse número já apareceu na primeira parte, quando o Salmon quantificou o genoma viral dentro do transcriptoma humano. Dois métodos independentes chegando ao mesmo valor, ótimo, é o tipo de concordância que dá confiança num resultado.

---

## 8. Criação de um alinhamento apenas viral

&emsp; Usamos um arquivo SRR com transcritos viral. Vamos filtrar as _reads_ alinhadas e criar seu índice. Vamos chamá-lo de `viral.bam`:

```bash
samtools view -b -F 4 infectado.bam > viral.bam
```

> [!TIP]
> **O que significa o comando?**
>
> * **`samtools`**: é o programa;
> * **`view`**: é o subcomando utilizado para ler, converter e filtrar os dados contidos nos arquivos;
> * **`-b`**: indica o formato de saída BAM;
> * **`-F 4`**: descarta as reads cujo **bit 4** do campo FLAG está ligado, ou seja, as não mapeadas. O `-F` maiúsculo exclui; o `-f` minúsculo faria o contrário, mantendo apenas essas;
> * **`infectado.bam`**: é o arquivo BAM de entrada;
> * **`viral.bam`**: é o arquivo BAM de saída.

Como sempre, montaremos um índice:

```bash
samtools index viral.bam
```

&emsp; O arquivo resultante tem cerca de 17% do tamanho do original.

---

## 9. Análise de cobertura

```bash
samtools coverage viral.bam
```

> [!IMPORTANT]
> **O que significa cada coluna?**
>
> | Coluna | Descrição |
> | :--- | :--- |
> | **#rname** | Nome da sequência de referência (cromossomo/contig) |
> | **startpos** | Posição inicial |
> | **endpos** | Posição final |
> | **numreads** | Número de leituras mapeadas |
> | **covbases** | Número de bases cobertas ao menos uma vez |
> | **coverage** | Proporção de bases cobertas (%) |
> | **meandepth** | Média de profundidade (reads por posição/nucleotídeo) |
> | **meanbaseq** | Qualidade média das bases (escore Phred, $Q$) |
> | **meanmapq** | Qualidade média do alinhamento (escore Phred de confiança na posição) |

&emsp; Agora usse a função de histograma que desenha um histograma da cobertura ao longo do genoma, direto no terminal.
```bash
samtools coverage viral.bam --histogram
```

&emsp; **O que nós fizemos aqui:** alinhamos os transcritos sequenciados contra um genoma de referência. Depois, filtramos aqueles transcritos que alinham com a referência — no caso, o vírus.

---

## 10. Visualização no IGV

&emsp; Para ver de forma gráfica o alinhamento BAM, vamos usar o IGV — *Integrative Genomics Viewer*. Primeiro, acesse <https://igv.org/app/>.

&emsp; No IGV já temos o genoma de SARS-CoV-2 disponível. Vá em **Genome → SARS-CoV-2 (Jan 2020 COVID-19)**.

&emsp; Veja que o genoma de SARS-CoV-2 tem cerca de 30 kb e apenas 10 ORFs (quadros azuis).

&emsp; Agora procure a pasta onde está seu arquivo de alinhamento. No IGV, clique em **Tracks → Local File** e selecione `viral.bam` **e** `viral.bam.bai` **juntos, na mesma seleção**.

> [!WARNING]
> São dois menus diferentes. Carregar o BAM pelo menu **Genome** produz o erro `Genome did not load: did not detect index file (expected extension .fai)` — o carregador de genoma foi procurar um índice de FASTA dentro de um BAM.
>
> E o `.bai` precisa ir junto explicitamente.

&emsp; Comigo, demorou cerca de 3 min para carregar os arquivos.

&emsp; Agora nós estamos vendo as reads alinhadas no genoma. Mova a barra lateral para ver o número de _reads_ alinhadas ao longo do genoma.

&emsp; **O que aquela "colina" representa?** Ela mostra o número de reads que alinham em cada posição. O comando `samtools coverage viral.bam` nos mostrou que 99,6% do genoma alinhou com alguma read — mas essa cobertura **não é uniforme**. A grande maioria das reads (aprox. 76,7%) alinha no final do genoma, nas ORFs **[N]([url](https://www.ncbi.nlm.nih.gov/gene/?term=YP_009724397.2))** (*nucleocapsid phosphoprotein*) e **[ORF10]([url](https://www.ncbi.nlm.nih.gov/gene/?term=YP_009725255.1))**.

&emsp; Isso significa que a maior parte do que está sendo transcrito pela célula hospedeira corresponde à região final do genoma viral.

> [!NOTE]
> **Por que a cobertura sobe em degraus?** Coronavírus não transcrevem genes independentes. Eles produzem um conjunto **aninhado de mRNAs subgenômicos**: todos começam com a mesma sequência líder na ponta 5' e **todos terminam no mesmo ponto 3'**. A região do gene N está fisicamente presente em quase todos esses mRNAs, enquanto a região de ORF1ab só existe no RNA genômico completo, que é uma fração pequena do total.
>
> Cada degrau da colina marca o início de uma unidade de transcrição. Ou seja: a cobertura está mostrando **onde estão os genes**.

> [!WARNING]
> A faixa de _reads_ vai parecer cheia de bases coloridas, como se a amostra tivesse mutações por toda parte. Não tem. São 30 mil bases espremidas em poucos pixels, e cada traço colorido é uma discordância em *algum* dos centenas de _reads_ empilhados naquele ponto, que pode ser erro de sequenciamento, por exemplo.
>
> A comprovação está na **cobertura**, que permanece cinza: o IGV só a coloriria se alguma posição tivesse mais de 20% de discordância.

---

## Cobertura vs. profundidade

&emsp; Em português, os dois conceitos costumam ser chamados de "cobertura", e é daí que vem a confusão. Em inglês há distinção: *breadth of coverage* e *depth of coverage*.

| | Pergunta que responde | Unidade |
| :--- | :--- | :--- |
| **Profundidade** | Quantas vezes eu li **esta base**? | Número de vezes |
| **Amplitude** | Que **fração da referência** eu consegui ler? | porcentagem |

&emsp; Profundidade é uma propriedade **de cada posição**. Amplitude é uma propriedade **do conjunto**. Amplitude baixa é um **limite absoluto**: onde não há read, não há resposta possível, e nenhuma estatística resolve. Profundidade baixa ainda dá uma resposta, só que com pouca confiança.

&emsp; A conta básica da profundidade média:

$$\text{profundidade} = \frac{\text{n}^\circ \text{ de reads} \times \text{tamanho do read}}{\text{tamanho da referência}}$$

---


## Solução de problemas

| Mensagem | Causa provável |
| :--- | :--- |
| `command not found` | esqueceu o `conda activate curso_toolbox` |
| Nomes com `\|` na tabela do Salmon | pulou a limpeza dos cabeçalhos do GENCODE |
| Taxa de mapeamento do Salmon muito baixa | referência errada ou arquivo de entrada trocado |
| Topo da lista cheio de `SNORD`, `RNVU1`, `ENSG00000...` | é esperado com o GENCODE completo — veja a nota do passo 1 |
| `Genome did not load: did not detect index file (.fai)` | carregou o BAM pelo menu **Genome** em vez de **Tracks** |
| IGV recusa carregar o BAM | faltou selecionar o `.bai` junto |
| IGV mostra o genoma mas nenhuma read | o nome do cromossomo no BAM não bate com o do genoma |
| `column: command not found` | ferramenta ausente; remova o `\| column -t` do comando |
