# Workshop de Bioinformática da Semana Temática de Biologia 2026
## Toolbox de Bioinformática: ferramentas para análises ômicas
Criado por Felipe S. Salles || [LinkedIn](https://br.linkedin.com/in/felipe-simionato-salles-b3640120b) || [Lattes](http://lattes.cnpq.br/3781167913621025)

Criado por Leandro Gonçalves || [LinkedIn](https://www.linkedin.com/in/leandro-gon45/) || [Lattes](http://lattes.cnpq.br/3096958278950054)

Monitores: [Sophia Pereira Saraiva](http://lattes.cnpq.br/5576461458658817) e [Bruno J. Teixeira de Melo](http://lattes.cnpq.br/0513855441372488)
***

&emsp; Na biologia pós-NGS, análises computacionais são indispensáveis ao profissional biólogo. Contudo, o primeiro contato com dados NGS é muitas vezes intimidador devido à barreira da linha de comando. Este minicurso propõe-se a desmistificar a bioinformática, focando na introdução ao tema e no uso de ferramentas de alto padrão na literatura científica. A proposta está em conferir ao aluno um contato inicial para metodologias de bioinformáticas, preparando-o para os desafios reais da pós-graduação e do mercado biotecnológico. O objetivo é fornecer uma introdução teórico-prática às ferramentas essenciais de bioinformática. Faremos um apanhado dos softwares mais importantes de bioinfo para análises evolutivas e de NGS, de forma que os alunos saibam: Compreender, revisar e saber manipular arquivos (.fasta, .fastq, .sam/bam, .newick, etc); 
1. Navegar no NCBI, executar alinhamentos de sequências e inferências filogenéticas (BLAST, MAFFT, IQTree)
2. Compreender conceitos básicos de Genômica (Qualidade e Anotação)
3. Compreender conceitos básicos de transcriptômica: alinhamento contra genoma de referência e quantificação de expressão
> [!NOTE]
> [Slides](https://canva.link/1uvpn017843xvc6) compartilhado 🔓
***

### Primeiros passos
&emsp; Veremos primeiro mencionar nos bancos de dados mais conhecidos e utilizados na bioinformática: [STEBio26/Banco de dados.md](https://github.com/211295/Workshop/blob/main/STBio26/Banco%20de%20dados.md).

### Inicialização na bioinformática:
#### A estrutura lógica da linha de comando será basicamente esta:
## `COMANDO` + `-OPÇÃO` + `OBJETO`

#### Principais comandos para manuzeio e manipulação de dados biológicos com a linguagem BASH. 
> [Curso referência](https://cursosextensao.usp.br/enrol/index.php?id=2285) e Disciplina [IBI5765](https://uspdigital.usp.br/janus/componente/disciplinasOferecidasInicial.jsf?action=3&sgldis=IBI5765) (realizada no Instituto de Ciências Biomédias), ministrado pelo Professor Dr. [João Marcelo Pareira Alves](https://scholar.google.com/citations?hl=pt-BR&user=kUPJajcAAAAJ).

| COMANDO | DESCRIÇÃO | OPÇÕES | Utilidades |
|:----------:|:----------------|:-----------------------------------------------:|:-----------------------------------------------------|
| _[ls](https://man7.org/linux/man-pages/man1/ls.1.html)_ | **L**ist **S**how = Mostra os arquivos presentes no _Diretório_/_Pasta_ | `-e` `-a` `-l` `-h` `-s` | Jeito rápido de ver os arquivos presentes, bem como seu tamanho (opções `-l` e `-h` juntas) |
| _[cd](https://man7.org/linux/man-pages/man1/cd.1p.html)_ | **C**hange **D**irectory = muda o _Diretório_/_Pasta_ atual de trabalho |  | É utilizado para transitar entre os diretórios de trabalho |
| _[mv](https://man7.org/linux/man-pages/man1/mv.1.html)_ | **M**o**V**e = Move arquivo ou _Diretório_/_Pasta_, OU modifica o nome | `-t` `-v` `-f` | Utilizado para modificar nome (move um arquivo para um "novo arquivo"), subscreve arquivos que estão em outros diretórios (opção `-f`), move arquivos entre _Diretórios_/_Pastas_ |
| _[mkdir](https://man7.org/linux/man-pages/man1/mkdir.1.html)_ | **M**a**K** a **DIR**ectory = cria um _Diretório_/_Pasta_ de trabalho |  | É utilizado para transitar entre os diretórios de trabalho |
| _[pwd](https://man7.org/linux/man-pages/man1/pwd.1.html)_ | **P**rint **W**ork **D**irectory = Mostra qual o _Diretório_/_Pasta_ atual de trabalho |  | Garante o nome correto do _Diretório_/_Pasta_ e do o caminho atual de trabalho |
| _[cp](https://man7.org/linux/man-pages/man1/mkdir.1.html)_ | **C**o**P**y = copia arquivos ou _Diretório_/_Pasta_ | `-t` | Importante lembrar que a cópia deve haver um nome diferente caso esteja presente no mesmo _Diretório_/_Pasta_ |
| _[cat](https://man7.org/linux/man-pages/man1/cat.1.html)_ | **C**onc**AT**enate = printa o conteuto de todos os arquivos concatenando seus conteudos | `-A` `-n` | Geralmente utilizado para verificar o conteúdo de arquivos pequenos. O inverso dele é o comando `TAC` |
| _[less](https://man7.org/linux/man-pages/man1/less.1.html)_ | Mostra o conteúdo na tela do terminal em uma "tela a parte" | `-S` | Como outros comandos, utiliza-se para visualizar o arquivo mas neste caso este não printa, mostra somente o conteudo que cabe na tela. Geralmente utilizado para verificar tabelas de maneira organizada (opção `-S`) |
| _[more](https://man7.org/linux/man-pages/man1/more.1.html)_ | Mostra o conteudo do arquivo em uma tela a parte |  | Garante o nome correto do _Diretório_/_Pasta_ e do o caminho atual de trabalho |
| _[head](https://man7.org/linux/man-pages/man1/head.1.html)_ | Mostra as primeiras linhas | `-n` | Importante lembrar que a cópia deve haver um nome diferente caso esteja presente no mesmo _Diretório_/_Pasta_ |
| _[tail](https://man7.org/linux/man-pages/man1/tail.1.html)_ | Mostra as últimas linhas | `-n` | Utilizado para modificar nome (move um arquivo para um "novo arquivo"), subscreve arquivos que estão em outros diretórios (opção `-f`), move arquivos entre _Diretórios_/_Pastas_ |
| _[touch](https://man7.org/linux/man-pages/man1/touch.1.html)_ | **M**a**K** a **DIR**ectory = cria um _Diretório_/_Pasta_ de trabalho |  | É utilizado para transitar entre os diretórios de trabalho |
| _nano_ | **P**rint **W**ork **D**irectory = Mostra qual o _Diretório_/_Pasta_ atual de trabalho |  | Garante o nome correto do _Diretório_/_Pasta_ e do o caminho atual de trabalho |
| _[grep](https://man7.org/linux/man-pages/man1/grep.1.html)_ | **GREP** = arquivos ou _Diretório_/_Pasta_ | `-t` | Importante lembrar que a cópia deve haver um nome diferente caso esteja presente no mesmo _Diretório_/_Pasta_ |
| _[sed](https://man7.org/linux/man-pages/man1/sed.1.html)_ | ** | `-t` `-v` `-f` | Utilizado para modificar nome (move um arquivo para um "novo arquivo"), subscreve arquivos que estão em outros diretórios (opção `-f`), move arquivos entre _Diretórios_/_Pastas_ |
| _[awk](https://man7.org/linux/man-pages/man1/awk.1p.html)_ | **A** **W** **K** = cria um _Diretório_/_Pasta_ de trabalho |  | É utilizado para transitar entre os diretórios de trabalho |
| _[wc](https://man7.org/linux/man-pages/man1/wc.1.html)_ | **W**orld **C**ount = Conta o número de elementos de um arquivo, ou | `-l` | Garante o nome correto do _Diretório_/_Pasta_ e do o caminho atual de trabalho |
| _[colrm](https://man7.org/linux/man-pages/man1/colrm.1.html)_ | **COL**umn **R**e**M**ove = Remove a coluna de strings selecioanda |  | Importante lembrar que a cópia deve haver um nome diferente caso esteja presente no mesmo _Diretório_/_Pasta_ |
| _[column](https://man7.org/linux/man-pages/man1/column.1.html)_ | **W**orld **C**ount = Conta o número de elementos de um arquivo, ou | `-l` | Garante o nome correto do _Diretório_/_Pasta_ e do o caminho atual de trabalho |
| _[sort](https://man7.org/linux/man-pages/man1/sort.1.html)_ | **SORT** = Organiza o arquivo, ordenando de diversas formas diferentes | `-n` `-r` `-k` `-d` `-h` | Utiliza-se junto a outros comandos para organizar o _output_ |
 
>[!WARNING]
> Outro comando básico porem fatal, é o [rm](https://man7.org/linux/man-pages/man1/rm.1.html) (**R**e**M**ove), uma vez usado, não há mais volta

***
# Softwares de bioinformática
#### Programas utilizados no tutorial

| PROGRAMA/link | DESCRIÇÃO |
|:----------:|:----------------|

BLAST MAFFT iqtree fastp seqtk BWA Samtools SRATools salmon

# websites para mexer com bioinformática
## Lição de casa
Tutorial disponibilizado no [Canva.com]() para recriar as análises feitas durante a aula em uma plataforma online

https://galaxy-main.usegalaxy.org/ 
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#alt-h1
## https://toolkit.tuebingen.mpg.de/tools/mafft
