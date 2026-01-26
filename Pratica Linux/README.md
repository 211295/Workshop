# Workshop de Bioinformática do IV Curso de Genética no Verão (USP)
Criado por Felipe S. Salles | Linkedin | Lattes

Assitents: Sophia Pereira Saraiva e Bruno J. Teixeira de Melo
***
###### Bem vindo ao mini tutorial do Workshop
Após a breve explicação sobre tipo de arquivos e abordagens de tipos de estudos, vamos iniciar o aprendizado do "terminal"


Para começar iremos introduzir o terminal e a linguagem Bash/Linux. O terminal de um computador é a área onde conversamos com o computador sem a interface gráfica (portanto não utilizamos mouse para mover os arquivos, ou clicar neles), permitindo usar scripts e comandos básicos para realizar as tarefas computacionais.

Para quem possiu o sistema Linux basta apertar Ctrl + Alt + 'T' . E para outros sistemas operacionais há aplicativos ou outras interfaces:
Windows: WSL, Ubunto e Xmobe
Android: Andronix ou Termux
IOS: iSH ou a-Shell

Iniciaremos com a visalização da tela e os primeiros comandos mais simples. Agora chamaremos todos os arquivos seguintes dependendo do conteundo dele. E cada um terá uma `terminação` especifica. E tambem toda pasta agora será chamada de `diretório`. 

Procure o aplicativo chamado Ubunto
Ubunto2.09.1 ![alt text](https://www.shoplinuxonline.com/ubuntu1804-usb.html)

Depois vamos iniciar com o comando que lista os arquivos e diretórios de um determinado local
``` $ ls
programas tutorial_workshop
```

Veja a diferença utilizando as opções `-l`, `-a`, `-h`, `-s`
``` $ ls -l
$ ls -lh
$ ls -lash
```

Interessante notar que as opções dos comandos não tem ordem correta, somente em alguns poucos casos onde uma opção tem que obrigatóriamente vir antes de outra.

Encontrou o diretório chamado `tutorial_workshop`? Vamos utilizar então agora um PADRÃO de comando que irá se repetir
``` [_comando_] -[_opção_] [_objeto_]
```
Portanto iremos usar o comando `ls` no diretório `tutorial_workshop`
``` $ ls tutorial_workshop
catch_genes.sh eukaria_protein.fasta transform_single_line_fasta.sh 
```

> Se quiser pode usar o mesmo comando no outro diretório para ver qual o conteudo.,

Agora entramemos no `diretório` chamado `tutorial_workshop`. Se fosse um computador com interface gráfica você clicaria duas vezes na pasta para entrar nela mas no nosso caso será em linha de comando, ao mesmo tempo que já mostraremos o conteudo dela. So é possivel por conta do `;`, que entende que isso seria uma linha nova:
``` $ cd tutorial_workshop ; ls -lh
``` 

Percebe-se que há dois script (verde) de final ".sh" e um fasta. Utilizaremos um `catch_genes.sh` para recuperarmos as sequências do arquivo fasta das proteinas de Eukariotos.

Agora vamos inspecionar os arquivos. O tamanho já nos foi dado ( ), precisamos ver o conteudo. Para inspecionar os arquivos temos diversos comandos: `head`, `tail`, `more`, `less`, `cat`, `tac` ... Cada um com suas especificidades. :warning: Procure não usar o `cat` ou `tac` para arquivos muito grandes. 
