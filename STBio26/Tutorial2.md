# TRANSCRIPTÔMICA COMPARATIVA
### Desenvolvido por 
### Revisado por 
***
&emsp; Nesta parte do curso, pretendemos comparar duas amostras de RNA-seq, uma controle e uma condição, quantificando a abundância relativa de transcritos, medida em TPM (transcripts per million), e identificar genes que são mais transcritos em cada situação.

&emsp; O aluno deve sair capaz de fazer o processamento básico de arquivos FASTQ até a obtenção de uma tabela de abundância (.tsv) e, adicionalmente, uma interpretação funcional. 

&emsp; Pela questão de tempo e complexidade da aula, minha intenção é a apresentar o seguinte

&emsp; Este trabalho foi feito no esforço contra a pandemia de COVID-19 e fez um screening de transcrição em diversos tipos celulares infectados por diversos vírus respiratórios. Usaremos duas corridas específicas. **SRR11517744** (controle, células CALU-3, tipo de adenocarcinoma de pulmão) e **SRR11517748** (doença, para SARS-CoV2). 
> Para a prática foram escolhidos os dados [Blanco-Melo et al., Cell 2020](http://www.cell.com/pb-assets/products/coronavirus/CELL_CELL-D-20-00985.pdf) :page_facing_up:. 

&emsp; Os autores relatam que os genes induzidos por SARS-CoV são
- ISGs efetores: IFIT1, IFIT2, IFIT3, ISG15, IFI6, IFI27, MX1, MX2, OAS1, OAS2, OAS3, OASL, RSAD2, IFITM1, IFITM3, HERC5, USP18, BST2, XAF1
- Sensores e fatores de transcrição: DDX58 (RIG-I), IFIH1 (MDA5), STAT1, STAT2, IRF7, IRF9
- Quimiocinas: CXCL10, CXCL11, CCL5, IL6
- Interferons: IFNB1, IFNL1, IFNL2, IFNL3

&emsp; Deveríamos achá-los no final do curso, mas, a análise é meio simplista, então, esse não pode ser um objetivo. 
