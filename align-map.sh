#!/bin/bash

### Location to genome files in Minerva
WORDIR='/home/maayanlab/cdm/'
GENOME_FA='/home/maayanlab/cdm/mouse/Mus_musculus/UCSC/mm9/Sequence/WholeGenomeFasta/genome.fa'
GENOME_GTF='/home/maayanlab/cdm/mouse/Mus_musculus/UCSC/mm9/Annotation/Genes/genes.gtf'
STAR_INDEX='/home/maayanlab/cdm/STAR/source/STAR'
featureCounts='/home/maayanlab/cdm/subread-1.5.0-p2-Linux-x86_64/bin/featureCounts'
fastqs = '/home/maayanlab/cdm/samplesProject1'

### Create output directories
mkdir star_output
mkdir featureCount_output

# ## make star index
# STAR \
#  	--runThreadN 16 \
#  	--runMode genomeGenerate \
#  	--genomeDir $STAR_INDEX \
#  	--genomeFastaFiles $GENOME_FA \
#  	--sjdbGTFfile $GENOME_GTF \
#  	--sjdbOverhang 100

cd fastqs
for fq in $(ls);do
	basename=$(echo $fq | cut -f1 -d '_' | sort | uniq)
	echo $basename
	fq1="_1.fastq"
	fq2="_2.fastq"
	fq3="_3.fastq"
	fq1=$basename$fq1
	fq2=$basename$fq2
	fq3=$basename$fq3

	STAR \
		--genomeDir $STAR_INDEX \
		--sjdbGTFfile $GENOME_GTF \
		--runThreadN 16 \
		--outSAMstrandField intronMotif \
		--outFilterIntronMotifs RemoveNoncanonical \
		--outFileNamePrefix $WORDIR/star_output/$basename \
		--readFilesIn $fq1,$fq2,$fq3 \
		--outSAMtype BAM SortedByCoordinate \
		--outReadsUnmapped Fastx \
		--outSAMmode Full

	suffix="Aligned.sortedByCoord.out.bam"
	outname="$basename.count.txt"
	bam="/home/maayanlab/cdm/star_output/$basename$suffix"
	eatureCounts \
		-T 16 \
		-t exon \
		-g gene_id \
		-a $GENOME_GTF \
		-o $WORDIR/featureCount_output/$outname \
		$bam
done
