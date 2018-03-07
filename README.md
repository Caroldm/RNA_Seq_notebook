# RNA_Seq_notebook

_________________________________________________________________________________________________________

**RNAseq tutorial.ipynb:** RNA-seq tutorial pipeline from fastq files to differential expression.


## Pipeline Overview
1. Generate genome Index file. 
2. Read Alignment *(STAR)*. 
3. Assign reads to genes *(featureCounts)*.
4. Compute CPM and RPKM *(EdgeR Bioconductor package)*.
5. Filter non expressed genes.
6. Filter lowly expressed genes.
7. PCA.
8. Visualization *(Clustergrammer)*.
9. Identify differentially expressed genes *(Characteristic Direction)*.
10. Enrichment Analysis *(Enrichr)*. 
11. Characteristic Direction Signature Search *(L1000CDS2)*.
