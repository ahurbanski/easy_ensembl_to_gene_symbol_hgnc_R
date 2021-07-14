
# 1. Install (if necessary) and load packages -----------------------------

# data.table and dplyr
install.packages("data.table", "dplyr")

#biomaRt
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("biomaRt")

#load packages
library(data.table)
library(biomaRt)
library(dplyr)


# 2. Choose your starting file -----------------------------------------------


# You can start from a expression matrix file with ENSEMBL gene ids on the FIRST COLUMN
PATH.TO.MATRIX.FILE = "example_files/expression_matrix.txt"
counts <- fread(PATH.TO.MATRIX.FILE)

# Or you can start from a single txt file, with a list of ENSEMBL gene ids, ONE PER LINE
PATH.TO.LIST.FILE = "example_files/gene_list.txt"
counts <- fread(PATH.TO.LIST.FILE, header = F)


# 3. Define the organism -----------------------------------------------------

# get the human genes from ensembl (see below for other organisms)
ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl") 

# if you are working with human genes, go straight to section 4. Other organisms see below.
# remove the comments in the following code lines in order to proper run

# ensembl <- useEnsembl(biomart = "genes")
# datasets <- listDatasets(ensembl)
# head(datasets) # here you can see ALL available organisms (~200)
# searchDatasets(mart = ensembl, pattern = "musculus") #or search an organism, changing the pattern
# datasetToUse <- "mmusculus_gene_ensembl" #now that you know what dataset to use, paste it here
# ensembl <- useDataset(dataset = datasetToUse, mart = ensembl) #define the ensembl object with your organism dataset

# 4. Merge your data with hgnc_symbols  --------------------------------------------------

#get gene list from ensembl
genes <- biomaRt::getBM(attributes = c("ensembl_gene_id", "hgnc_symbol"),
                        values = counts[,1], 
                        mart = ensembl)

#merge your data with the ensembl database
names(counts)[1] <- "ensembl_gene_id"
counts <- inner_join(genes, counts)  %>% select(-ensembl_gene_id)

#keeps only valid hgnc_symbol names (not empty)
counts <- as.data.frame(counts[counts$hgnc_symbol != "",])
names(counts)[1] <- "hgnc_symbol"


# save your list or expression matrix -------------------------------------------------------------------------

PATH.TO.SAVE <-  "example_files/output_hgnc_symbol.tsv"
fwrite(counts, file = PATH.TO.SAVE, row.names = F, sep = "\t")
