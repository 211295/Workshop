##
Este arquivo é um guia para instalação de alguns programas atraves de um [ambiente](https://www.anaconda.com/docs/anaconda-desktop/environments#environments) muito utilizado em Informática.
É um espaço virtual isolado que armazena uma versão específica do Python (ou de outra linguagem) junto com suas próprias bibliotecas e dependências de software
Ambientes são usados para isolar instalações, assim, impedido que um programa sobreponha as dependências de outros. Para a prática científica, é uma forma de presar pela replicabilidade, pois, é possível recriar ou disponibilizar um ambiente usado na pesquisa para que outras pessoas possam fazer nas mesmas condições

# INSTALAÇÃO
O gerenciador de ambientes mais conhecidos é o [ANACONDA](https://www.anaconda.com/docs/main) e suas versões reduzida **CONDA** e **MINICONDA**. Também é muito popular o **MAMBA**, um _Drop-in replacement_ do **ANACONDA**, ou seja, o mesmo programa mas escrito com C++ com maior integração com _multithreading_ (uso mais de um processador/core/thread simultâneamente) o que o torna muito mais rápido. Em tese, o **MAMBA** lida mellhor com conflitos de dependências usando uma biblioyeca própria `libmamba`, mas, a versão mais recente do **ANACONDA** usa o `libmamba`

Para baixar o **MINICONDA**
```bash 
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
```
```bash 
bash Miniforge3-Linux-x86_64.sh -b -p $HOME/miniforge3
```
```bash 
$HOME/miniforge3/bin/conda init bash
```
```bash
exec bash
```

Para criar um ambiente com os programas do curso, use o comando: 
```bash
$ mamba create --name curso_toolbok -c conda-forge -c bioconda -y python=3.11 firefox wget fastp salmon bwa samtools seqkit 
```
Para ativar o ambiente, use
```bash
Conda activate curso_toolbox
```

Caso queira desativar
```bash
Conda deactivate
```
