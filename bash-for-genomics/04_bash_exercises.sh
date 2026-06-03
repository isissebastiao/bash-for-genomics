# Crete folders and subfolders to pangenome project using bash comands
mkdir -p project/data/genomes/data/reads/results/busco/results/graphs/logs/
# navegate till root folder
cd ..
# check if the structure was created using ls comand
cd project
ls

##
# Você tem 4 amostras de RNA-seq: ctrl_1, ctrl_2, treat_1, treat_2. Escreva um loop que crie uma pasta de resultados para cada amostra dentro de results/rnaseq/, e imprima uma mensagem confirmando a criação de cada uma.

#!/bin/bash
# criar uma lista com as amostras
RNA-seq=("ctrl_1", "ctrl_2", "treat_1", "treat_2")
# escrever os comando de loop
for in RNA-Seq do mkdir -p results/ranseq/1 echo "Folder ... was created"