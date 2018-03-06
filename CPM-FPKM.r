setwd('/Users/Carol/Desktop/RNA_pro/')
library(edgeR)

fns <- system2('ls', args = '/Users/Carol/Desktop/RNA_pro/featureCount_output_no_outliers/*.txt', stdout = T)
counts.df <- NULL
lengths.df <- NULL
for (fn in fns) {
  
  
  df <- read.table(fn, check.names=F, sep='\t', header=T)
  df <- subset(df, select=-c(Chr, Start, End, Strand)) # drop unwanted columns
  colnames(df)[3] <- strsplit(basename(fn), '\\.')[[1]][1] # beautify sample name
  if (is.null(counts.df)) {
    lengths.df <- subset(df, select=c(Geneid, Length))
    df <- subset(df, select=-c(Length))
    counts.df <- df
  } else {
    df <- subset(df, select=-c(Length))
    counts.df <- merge(counts.df, df, by="Geneid", all.x=T, sort=F)
  }
}

write.csv(counts.df, file='featureCounts_matrix_condition.csv', row.names=F)
write.csv(lengths.df, file='featureCounts_gene_lengths_condition.csv', row.names=F)

genes <- as.vector(counts.df[[1]])
gene.lengths <- lengths.df[[2]]
# make a matrix of counts
count.mat <- as.matrix(counts.df[2:length(counts.df)])

## Calculate RPKM
d <- DGEList(counts=count.mat)
d$genes$Length <- gene.lengths
rpkm.mat <- rpkm(d)
rownames(rpkm.mat) <- genes
write.csv(rpkm.mat, file="repRpkmMatrix_featureCounts_condition.csv", row.names=T)

## Calculate CPM
cpm.mat <- cpm(d)
rownames(cpm.mat) <- genes
write.csv(cpm.mat, file="repCpmMatrix_featureCounts.csv_condition", row.names=T)

