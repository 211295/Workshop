# PRIEMIRA PARTE: TRANSCRIPTÔMICA COMPARATIVA
### Desenvolvido por Leandro de Brito Gonçalves
### Revisado por Felipe Simionato Salles
***
&emsp; Nesta parte do curso, pretendemos comparar duas amostras de RNA-seq, uma controle e uma condição, quantificando a abundância relativa de transcritos, medida em TPM (transcripts per million), e identificar genes que são mais transcritos em cada situação.

&emsp; O trabalho de referência é um esforço contra a pandemia de COVID-19 e fez um screening de transcrição em diversos tipos celulares infectados por diversos vírus respiratórios. Usaremos duas corridas específicas. **SRR11517744** (controle, células CALU-3, tipo de adenocarcinoma de pulmão) e **SRR11517748** (doença, para SARS-CoV2). 
> Para a prática foram escolhidos os dados [Blanco-Melo et al., Cell 2020](http://www.cell.com/pb-assets/products/coronavirus/CELL_CELL-D-20-00985.pdf) :page_facing_up:.

## MAPA DE PROCESSOs
> [!TIP]
> **FASTQ → [Controel de qualidade: fastp] → FASTQ limpo + Genoma_viral.fasta + GENCODE.fasta → [Quantificação: salmon] → quant.sf → [script] → tabela → [Enrichr] → termos GO**
> **Genoma_viral.fasta + FASTQ → [Alinhamento: BWA] → BAM → [Filtragem: Samtools] → BAM Viral → Visualização IGV**

&emsp; Os materiais que vamos usar são:
- Referência para transcriptoma humano GENCODE
- Genoma de SARS-CoV2
- Arquivos de RNA-seq (SRR/SRA) depositados

00.**Ativando o ambiente conda**
>[!IMPORTANT]
>Antes de tudo, vamos ativar o ambiente Conda

```sh
conda activate curso_toolbox
```

1.**Baixando e preparando os dados**

&emsp; Primeiro, vamos baixar o Genoma viral:
```bash
wget -O NC_045512.2.fa "wget -O NC_045512.2.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_045512.2&rettype=fasta&retmode=text" 
```
&emsp; Em seguida, a referência para o transcriptoma:
```bash
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz
```
Para descomprimir o arquivo do GENCODE
```bash
zcat gencode.v50.transcripts.fa.gz \
  | awk -F'|' '/^>/{print ">"substr($1,2)"_"$6; next}{print}' > gencode_limpo.fa
```
&emsp; Os arquivos SRR são razoavelmente pesados. Para agilizar, deixamos previamente baixados.
SRR***
> [!NOTE]
> Estes arquivos são sub-amostras do sequenciamento completo. Optamos por fazer isso para reduzir o tamanho do SRR e também o tempo de processamento.

&emsp; O programa que vamos usar aceita apenas uma entrada, não tem problema. Vamos concatenar (juntar em um único arquivo) os arquivos fasta:
```bash
cat NC_045512.2.fa gencode.v50.transcripts.fa > ref.fa
```
2.**Controle de qualidade**

&emsp; É necessário remover os adaptadores de sequênciamneto. Como boa prática, é necessário conferir o controle de qualidade do sequenciamento. O melhor e mais rápido hoje é o fastp que faz as duas coisas:
```sh
fastp -i SRR11517744.subsample.fastq -o SRR11517744.quality.fastq -j controle_report.json -h controle_report.html
```
```sh
fastp -i SRR11517748.subsample.fastq -o SRR11517748.quality.fastq -j doença_report.json -h doença_report.html
```
-------------Leitura do controle de qualidade

3.**Preparando o ìndice**

&emsp; O que é um índice? Uma estrutura de busca pré-processada. Sem ela, para cada read o software precisaria que varrer 110 mil transcritos. É o mesmo princípio do índice remissivo no fim de um livro. Isso ajuda muito no processamento!

&emsp; Existem muitos quantificadores de transcriptoma. Usaremos o Salmon pois é ultra rápido, não usa um alinhador externo e bastante eficiente.
Para criar um índex para o Salmon:
```bash
salmon index -t ref.fa -i index_dir -k 31 -p 4
```
4.**Quantificando**

&emsp; Vamos estimar a expressão quantificando os transcritos de cada um dos arquivos SRR. Rode um, quando terminar, rode o outro. Isso deve demorar cerca de 5 min. 
```bash
salmon quant -i index_dir -l A -r SRR11517744.fastq -p 4 -o quantificação_controle
```
```bash
salmon quant -i index_dir -l A -r SRR11517748.fastq -p 4 -o quantificação_doença
```
5.**Visualização dos dados**

&emsp;  O salmon entrega os seguintes arquivos de saída que nos importam:
-aux_info/meta_info.json, que é o arquivo de metadados e
- quant.sf, um tsv com os dados de quantificação;
  
Use um ```bash cat quant.sf ``` e veja que tem as seguintes colunas, que significam:

| Coluna | Descrição |
| :--- | :--- |
| Name | Header do transcrito ou nome do gene/transcrito/proteína |
| Length | Tamanho, em nucleotídeos |
| EffectiveLength | Número de posições que um fragmento médio pode se alinhar ao transcrito |
| TPM | Métrica normalizada de expressão (_transcripts per million_) |
| NumReads | Valor absoluto de leituras que mapearam em cima do transcrito |

Vamos ver as 30 primeiras linhas em colunas alinhadas e fáceis de ler:
```bash
head -30 quant.sf | column -t 
```
Mas nós queremos ver aqueles com maior TPM
```bash
sort -nrk6 quant.sf | head -30 | column -t
```

Temos esse script escrito na linguagem python que vai nos ajudar a comaprar as duas quantificaçãoes que fizemos:

```python
python compara_salmon.py quant_1 quant_2 --nome-a --nome-b --saida
````
por exemplo:
    python3 comparar_salmon.py quantificação_controle/quant.sf  quantificação_doença/quant.sf --nome-a Controle --nome-b SARS_CoV_2 --saida salmon_compare.tsv

    ------- Leitura do arquivo de saída
    
6.**Enriquecimento funcional**
&emsp;  Beleza. Sabemos quais os transcritos que são mais expressos em cada situação e ainda temos os valores de _fold change_ que permite comparar o perfil de transcrição em cada contexto. Mas qual o significado biológico disso?
  Enriquecimento funcional é uma análise estatística que associa uma lista de genes a termos Gene Onthology (Processos Biológicos, Funções Moleculares e Compartimento Celular). 
  Priemiro, vamos extrair uma lista dos 150 mais expressos com maior aumento em COVID
```bash
awk '$7=="sim" && $6>1 {print $1}' tabela_comparacao.tsv | head -n150
```
Acesse o [Enrichr]([url](https://maayanlab.cloud/Enrichr/)) que é um tipo de "Google" 
Cole a lista de genes no quadro e depois clique em "submit"
No topo da pagina que abrir, clique em "Ontologies"
E depois clique no quadro "GO Biological processes 2026"

-------LEITURA DO ENRICHR

Podemos navegar nos quadros "GO Cellular Component 2026" e "GO Molecular Function 2026"

Podemos ver os arquivos sem comparação, apenas, os mais expressos em cada contexto
```bash
sort -nrk4 quantificação_controle/quant.sf | cut -f1 | head -150 | cut -d'_' -f2-
```
```bash
sort -nrk4 quantificação_doença/quant.sf | cut -f1 | head -150 | cut -d'_' -f2-
```

# SEGUNDA PARTE: ALINHAMENTO GENOMA-TRANSCRIPTOMA
7.**Alinhamento com o BWA**
&emsp;  Para essa parte, vamos usar o mesmo genoma de SARS-CoV que usamos NC_045512.2.fa e vamos alinhas as _reads_ do arquivo SRR infectado contra o genoma, pois, neste sabemos que há leituras virais. Mas antes, vamos ver como está escrito o cabeçalho do arquivo fasta.
```bash
head -1 NC_045512.2.fa
```
Será necessário que o _header_ do arquivo fasta seja igual ao nome do "cromossomo" no genoma que o IGV vai carregar. 

```bash
sed -i '1s/.*/>NC_045512.2/' NC_045512.2.fa
```
> [!TIP]
> **O que significa o comando?**
>
> * **`sed`**: é um programa Linux para edição de texto;
> * **`-i`**: é a opção de editar diretamente o arquivo original (*in-place*);
> * **`'1s/.*/>NC_045512.2/'`**: instrução para substituir todo o conteúdo da primeira linha por `>NC_045512.2`.

Por que isso importa? Esse nome vai ser copiado para dentro do arquivo de alinhamento e usado como identificador do "cromossomo". Lá na frente, o IGV vai comparar esse nome com o do genoma que carregamos. Se os dois não baterem, o IGV carrega tudo sem dar erro nenhum — e mostra uma tela vazia. É um dos problemas mais difíceis de diagnosticar justamente porque nada falha. 

&emsp;  Existe uma diversidade de alinhadores e cada um tem uma especificidade e objetivas diferentes (Slides). Para essa prática, vamos usar o BWA por estas razões:
Primeiro, porque o SARS-CoV-2 não tem íntrons. O genoma dele é RNA contínuo, sem splicing. Alinhadores como STAR e HISAT2 existem exatamente para lidar com esse salto, e resolver esse problema custa memória e tempo. Segundo, temos um RNA-seq de Illumina short reads. 
_Reflexão_: O que importa não é o nome do alinhador, é saber em qual problema temos e qual ferramenta usar para resolver. O Bowtie2 faria exatamente o mesmo trabalho.

Vamos criar o index para o BWA
```bash
bwa index NC_045512.2.fa
```
Repare que surgiram cinco arquivos novos: .amb, .ann, .bwt, .pac e .sa. Você nunca vai abri-los, são de uso interno do programa. 

Com o índex na mãos, poderemos usar o alinhador. O comando que vamos usar alinha o RNA-seq contra o genoma viral e ordena com o Samtools:
```bash
bwa mem -t 4 NC_045512.2.fa infectado.fq.gz | samtools sort -@ 2 -o SRR11517744.fastq - 
```
> [!TIP]
> **O que significa o comando?**
>
> * **`bwa`**: é o programa alinhador;
> * **`mem`**: é o algoritmo de alinhamento (*Maximal Exact Matches*);
> * **`-t 4`**: define o uso de 4 *threads* (processamento em paralelo);
> * **`NC_045512.2.fa`**: é o genoma de referência em FASTA (o BWA busca automaticamente os 5 arquivos de índice na mesma pasta);
> * **`infectado.fq.gz`**: é o arquivo FASTQ comprimido com as *reads*;
> * **`|` (pipe)**: redireciona a saída do BWA diretamente para a entrada do `samtools`;
> * **`sort`**: subcomando do `samtools` que reordena os alinhamentos por coordenada genômica;
> * **`-@ 2`**: define 2 *threads* para o `samtools sort`;
> * **`-o SRR11517744.fastq`**: especifica o nome do arquivo BAM de saída;
> * **`-` (traço final)**: indica que a entrada de dados vem do *pipe* (STDIN).

Vamos precisar criar outro índex, agora, do novo arquivo BAM que criamos
```bash
samtools index SRR11517744.fastq
```

Vamos ver algumas informações?
```bash
samtools flagstat SRR11517744.fastq
```
    O que a saída mostra, linha a linha:
      in total — o número de reads processados. Deve bater com o número de reads do FASTQ
      mapped — quantos encontraram posição no genoma viral, em número absoluto e em porcentagem. É a linha que interessa
      primary, secondary, supplementary — categorias de alinhamento. Um mesmo read pode ter mais de um registro; os secundários são           alinhamentos alternativos
      duplicates — zero aqui, porque não rodamos marcação de duplicatas

8.**Criação de um Alinhamento apenas viral**
&emsp;  Usamos um arquivo SRR com transcritos de origem humana e viral. Vamos filtrar as reads alinhadas e criar seu índex. Vamos chamar viral.bam
```bash
samtools view -b -F 4 SRR11517744.fastq > viral.bam
```

> [!TIP]
> **O que significa o comando?**
>
> * **`samtools`**: é o programa;
> * **`view`**: é o subcomando utilizado para ler, converter e filtrar os dados contidos nos arquivos;
> * **`-b`**: indica o formato de saída BAM;
> * **`-F 4`**: é a regra de filtragem (a regra nº 4 descarta reads não mapeadas, mantendo apenas as que mapearam);
> * **`SRR11517744.fastq`**: é o arquivo BAM de entrada;
> * **`viral.bam`**: é o arquivo BAM de saída.

Como sempre, montaremos um index
```bash
samtools index viral.bam 
```

9. **Análise de cobertura**
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
> | **covbases** | Número de bases cobertas |
> | **coverage** | Proporção de bases cobertas (%) |
> | **meandepth** | Média de profundidade (reads por posição/nucleotídeo) |
> | **meanbaseq** | Qualidade média das bases (Phred quality score, $Q$) |
> | **meanmapq** | Qualidade média do alinhamento (probabilidade de mapeamento correto) |

```bash
samtools coverage viral.bam -m
```
O que nós fizemos aqui: Alinhamos os transcritos sequenciados em um genoma de referência. Depois, filtramos aqueles transcritos que alinham com a referência, no caso, o virus.

10.**Visualização no IGV**
Para ver de forma gráfico o alinhamento BAM, vamos usar IGV - Integrative Genome Viewer 
	Primeiro, clique no link para acessar o site https://igv.org/app/. 

No IGV, já temos o genoma de SARS-CoV baixado. Vá em Genome > SARS-CoV-2 (Jan 2020 COVID-19)

Veja que o genoma de SARS-COV tem cerca de 30Kb e com apenas 10 ORFs (quadros azuis)

Agora procure a pasta onde está seu arquivo de alinhamento.
No IGV, clique em “Tracks” > “Local file”. 
Comigo, demorou cerca de 3 min para carregar o alinhamentos

Agora nós estamos vendo as reads alinhadas no genoma. Mova a barra lateral para ver o número de reads alinhadas ao longo do genoma.

O que aquela “colina” representa? Ela mostra o número de reads que alinham em cada posição. Ou seja, o comando “samtools coverage viral.bam” nos mostrou que 99,6% do genoma alinhou com alguma read, mas, não é uniforme. A grande maioria das reads (aprox. 76,7%) alinham no final no genoma, nas ORF “N” (N nucleocapsid phosphoprotein) e na ORF10. 
Isso significa que a maior parte do genoma viral que está sendo transcrito pela célula hospedeiro são as proteínas dessas duas ORFs

Cobertura vs profundidade

Extra - Como encontrar éxons?



