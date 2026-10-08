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
$ conda create --name curso_toolbox -c conda-forge -c bioconda -y python=3.11 firefox wget fastp salmon bwa samtools seqkit 
```
Para ativar o ambiente, use
```bash
Conda activate curso_toolbox
```

Caso queira desativar
```bash
Conda deactivate
```


Ai se não der, vamo sem CONDA
````bash
mkdir programas ;
cd programas ;
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.17.0+-x64-linux.tar.gz ;
tar zxvpf ncbi-blast-2.17.0+-x64-linux.tar.gz ;
wget https://mafft.cbrc.jp/alignment/software/mafft-7.526-linux.tgz ;
tar xfzv mafft-7.526-linux.tgz ;  
wget https://github.com/iqtree/iqtree3/releases/download/v3.1.4/iqtree-3.1.4-Linux.tar.gz ;
tar zxvpf iqtree-3.1.4-Linux.tar.gz ;
wget http://opengene.org/fastp/fastp ;
chmod a+x ./fastp ;
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/COMBINE-lab/salmon/releases/latest/download/salmon-cli-installer.sh | sh ;
mv /home/lbrito/.cargo/bin/salmon . ;
https://github.com/shenwei356/seqkit/releases/download/v2.14.0/seqkit_linux_amd64.tar.gz ;
tar zxvpf seqkit_linux_amd64.tar.gz ;
git clone https://github.com/lh3/bwa.git ;
cd bwa; make ;
cd .. ;
wget https://github.com/samtools/samtools/releases/download/1.24/samtools-1.24.tar.bz2 ;
tar -xjf samtools-1.24.tar.bz2 ;
cd samtools-1.24/ ;
./configure --prefix=$PWD/ ;
make ;
make install ;
cd .. ;
ls
```
