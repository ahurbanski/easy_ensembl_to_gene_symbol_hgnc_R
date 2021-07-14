# easy_ensembl_to_gene_symbol_hgnc_R
Converts a list of genes in ensembl format to HGNC gene symbol format using biomaRt

You can start from (see example files in this repository):

  a) an expression matrix file (where the ENSEMBL genes are in the FIRST column);

  b) a simple list of ENSEMBL genes (ONE gene per line).
  
IMPORTANT: Note that a gene will be removed from the final list if the given ENSEMBL gene id (ensembl_gene_id) does not have a corresponding HGCN symbol (hgnc_symbol).
  

