# Trim and polish the assemblies, and detect variants
cd 1_Genome_assembly/
sh genome_assembly_workflow.sh
cd ..

# Annotate the genomes
cd 2_Genome_annotation/
sh genome_annotation_workflow.sh
cd ..

# Make an ANI matrix
cd 3_ANI_matrix/
sh ANI_matrix_pipeline.sh
cd ..

# Make an AAI matrix
cd 4_AAI_matrix/
sh AAI_matrix_pipeline.sh
cd ..

# Make a MLSA phylogeny
cd 5_MLSA_phylogeny/1_16S_rRNA_ph
sh MLSA_phylogeny_pipeline.sh
cd ..

# Make a core gene phylogeny
cd 6_Core_gene_phylogeny/
sh core_gene_phylogeny_pipeline.sh
cd ..

# Examine nod and nif genes
cd 7_Sym_gene_analysis
sh sym_gene_pipeline.sh
cd ..

# Calculate pangenome
cd 8_Pangenome_analysis
sh pangenome_analysis_pipeline.sh
cd ..
