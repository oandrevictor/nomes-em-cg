# Vias e vens de Campina Grande

Em abril de 2018, solicitei à Prefeitura de Campina Grande - PB os nomes de todas as ruas da cidade. O pessoal da Secretaria de Planejamento gentilmente me enviou não só a lista de nomes, mas também uma série de outras informações sobre as ruas. Os dados brutos são um shapefile em `data/vias_cg.rar`, e são resultado de um levantamento da cidade realizado entre 2010 e 2013.  

A partir desses dados, extrai o csv `data/vias_cg.csv` usando o [mapshaper](http://mapshaper.org/) e derivei um conjunto de variáveis que achei interessantes sobre as ruas em `data/vias-tidy.csv`. O script para essa segunda parte é `code/import_data`


