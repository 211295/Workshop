# TRANSCRIPTÔMICA COMPARATIVA
### Desenvolvido por Leandro de Brito Gonçalves
### Revisado por Felipe Simionato Salles
***
&emsp; Nesta parte do curso, pretendemos comparar duas amostras de RNA-seq, uma controle e uma condição, quantificando a abundância relativa de transcritos, medida em TPM (transcripts per million), e identificar genes que são mais transcritos em cada situação.

&emsp; O trabalho de referência é um esforço contra a pandemia de COVID-19 e fez um screening de transcrição em diversos tipos celulares infectados por diversos vírus respiratórios. Usaremos duas corridas específicas. **SRR11517744** (controle, células CALU-3, tipo de adenocarcinoma de pulmão) e **SRR11517748** (doença, para SARS-CoV2). 
> Para a prática foram escolhidos os dados [Blanco-Melo et al., Cell 2020](http://www.cell.com/pb-assets/products/coronavirus/CELL_CELL-D-20-00985.pdf) :page_facing_up:.

&emsp; Os materiais que vamos usar são:
- Referência para transcriptoma humano GENCODE
- Genoma de SARS-CoV2
- Arquivos de RNA-seq (SRR/SRA) depositados

1.**Baixando e preparando os dados**

&emsp; Primeiro, vamos baixar o Genoma viral:
```bash
wget -O NC_045512.2.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi 
```
&emsp; Em seguida, a referência para o transcriptoma:
```bash
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz
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
fastp -i SRR11517744.subsample.fastq -o SRR11517744.quality.fastq -j report.json -h report.html
```
-------------Leitura do controle de qualidade

3.**Preparando o ìndice**

&emsp; O que é um índice? Uma estrutura de busca pré-processada. Sem ela, para cada read o software precisaria que varrer 110 mil transcritos. É o mesmo princípio do índice remissivo no fim de um livro. Isso ajuda muito no processamento!

&emsp; Existem muitos quantificadores de transcriptoma. Usaremos o Salmon pois é ultra rápido, não usa um alinhador externo e bastante eficiente.
Para criar um índex para o Salmon:
```bash
salmon index -t ref.fa -i index_dir -k 31 -p 4
```
4.**Quantificanfo**

&emsp; Vamos estimar a expressão quantificando os transcritos de cada um dos arquivos SRR. Rode um, quando terminar, rode o outro. Isso deve demorar cerca de 5 min. 
```bash
salmon quant -i index_dir -l A -r SRR11517744.fastq -p 4 -o quantificação_controle
salmon quant -i index_dir -l A -r SRR11517748.fastq -p 4 -o quantificação_doença
```
5.**Visualização dos dados**
&emsp;  O salmon entrega os seguintes arquivos de saída que nos importam:
-aux_info/meta_info.json, que é o arquivo de metadados e
- quant.sf, um tsv com os dados de quantificação;
  
Use um ```bash cat quant.sf ``` e veja que tem as seguintes colunas, que significam:

|Name |Header do transcrito ou nome do gene/transcrito/proteína|
|Length |Tamanho, em nucleotídeos|
|EffectiveLength		|Número de posições que um fragmento médio pode se alinhar ao transcrito |
|TPM |Métrica normalizada de expressão (reas per million)|
|NumReads|Valor absoluto de leituras que mapearam em cima do transcrito|

printar as 30 primeiras linhas em colunas alinhadas e fáceis de ler
head -30 quant.sf | column -t 
python compara_salmon.py quant_1 quant_2 --nome-a --nome-b --saida
    python3 comparar_salmon.py quantificação_controle/quant.sf  quantificação_doença/quant.sf --nome-a Controle --nome-b SARS_CoV_2 --      saida salmon_compare.tsv
    
6.**Enriquecimento funcional**
awk '$7=="sim" && $6>1 {print $1}' tabela_comparacao.tsv | head -n150
sort -nrk4 quantificação_controle/quant.sf | cut -f1 | head -15 | cut -d'_' -f2-
sort -nrk4 quantificação_doença/quant.sf | cut -f1 | head -15 | cut -d'_' -f2-
