# TRANSCRIPTÔMICA COMPARATIVA
### Desenvolvido por Leandro de Brito Gonçalves
### Revisado por Felipe Simionato Salles
***
&emsp; Nesta parte do curso, pretendemos comparar duas amostras de RNA-seq, uma controle e uma condição, quantificando a abundância relativa de transcritos, medida em TPM (transcripts per million), e identificar genes que são mais transcritos em cada situação.

&emsp; O trabalho de referência é um esforço contra a pandemia de COVID-19 e fez um screening de transcrição em diversos tipos celulares infectados por diversos vírus respiratórios. Usaremos duas corridas específicas. **SRR11517744** (controle, células CALU-3, tipo de adenocarcinoma de pulmão) e **SRR11517748** (doença, para SARS-CoV2). 
> Para a prática foram escolhidos os dados [Blanco-Melo et al., Cell 2020](http://www.cell.com/pb-assets/products/coronavirus/CELL_CELL-D-20-00985.pdf) :page_facing_up:.

&emsp; Os materiais que vamos usar são:
> Referência para transcriptoma humano GENCODE
> Genoma de SARS-CoV2
> Arquivos de RNA-seq (SRR/SRA) depositados

1.**Baixando e preparando os dados**
Primeiro, vamos baixar o Genoma viral:
```bash
wget -O NC_045512.2.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi 
```
Em seguida, a referência para o transcriptoma:
```bash
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz
```
Os arquivos SRR são razoavelmente pesados. Para agilizar, deixamos previamente baixados.
SRR***
> [!NOTE]
> Estes arquivos são sub-amostras do sequenciamento completo. Optamos por fazer isso para reduzir o tamanho do SRR e também o tempo de processamento.

O programa que vamos usar aceita apenas uma entrada, não tem problema. Vamos concatenar (juntar em um único arquivo) os arquivos fasta:
```bash
cat NC_045512.2.fa gencode.v50.transcripts.fa > ref.fa
```
2.**Controle de qualidade**
```sh
fastp -i SRR11517744.subsample.fastq -o SRR11517744.quality.fastq -j report.json -h report.html
```
3.**Preparando o ìndice**
salmon index -t ref.fa -i index_dir -k 31 -p 4

4.**Quantificanfo**
salmon quant -i index_dir -l A -r SRR11517744.fastq -p 4 -o quantificação_controle
salmon quant -i index_dir -l A -r SRR11517748.fastq -p 4 -o quantificação_doença

5.**Visualização dos dados**
printar as 30 primeiras linhas em colunas alinhadas e fáceis de ler
head -30 quant.sf | column -t 
python compara_salmon.py quant_1 quant_2 --nome-a --nome-b --saida
    python3 comparar_salmon.py quantificação_controle/quant.sf  quantificação_doença/quant.sf --nome-a Controle --nome-b SARS_CoV_2 --      saida salmon_compare.tsv
    
6.**Enriquecimento funcional**
awk '$7=="sim" && $6>1 {print $1}' tabela_comparacao.tsv | head -n150
sort -nrk4 quantificação_controle/quant.sf | cut -f1 | head -15 | cut -d'_' -f2-
sort -nrk4 quantificação_doença/quant.sf | cut -f1 | head -15 | cut -d'_' -f2-
