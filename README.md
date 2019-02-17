Antes de instalar, instale as dependencias 'pkpgcounter' e 'hplip' localizados na pasta 'dependencies'.

Para instalar, basta executar o arquivo 'install.sh'

O Tea4Cups chama o ifsup-capture-job.
É preciso deixar rodando o daemon "ifsup-daemon".
Após isso, se houver impressão o ifsup-daemon chama o "ifsup_printer".
Adicionar as impressoras virtuais com o nome de "ifsupprinter##".
Todos os arquivo do diretório desse sistema deverão possuir a permissão 775 para o usuário LP e grupo LP.

