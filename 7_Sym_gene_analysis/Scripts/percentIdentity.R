library(phytools)

# NodA
proteinAlignment = file.path("SymbioticProteins/NodA_mafft.faa")
protAln = as.matrix(read.FASTA(proteinAlignment, type='AA'))
aai = 100 * (1 - as.matrix(dist.aa(protAln, scaled=TRUE)))
write.table(aai, file = 'SymbioticProteins/NodA_percent_identity.txt', sep="\t")

# NodB
proteinAlignment = file.path("SymbioticProteins/NodB_mafft.faa")
protAln = as.matrix(read.FASTA(proteinAlignment, type='AA'))
aai = 100 * (1 - as.matrix(dist.aa(protAln, scaled=TRUE)))
write.table(aai, file = 'SymbioticProteins/NodB_percent_identity.txt', sep="\t")

# NodC
proteinAlignment = file.path("SymbioticProteins/NodC_mafft.faa")
protAln = as.matrix(read.FASTA(proteinAlignment, type='AA'))
aai = 100 * (1 - as.matrix(dist.aa(protAln, scaled=TRUE)))
write.table(aai, file = 'SymbioticProteins/NodC_percent_identity.txt', sep="\t")

# NifH
proteinAlignment = file.path("SymbioticProteins/NifH_mafft.faa")
protAln = as.matrix(read.FASTA(proteinAlignment, type='AA'))
aai = 100 * (1 - as.matrix(dist.aa(protAln, scaled=TRUE)))
write.table(aai, file = 'SymbioticProteins/NifH_percent_identity.txt', sep="\t")

# NifD
proteinAlignment = file.path("SymbioticProteins/NifD_mafft.faa")
protAln = as.matrix(read.FASTA(proteinAlignment, type='AA'))
aai = 100 * (1 - as.matrix(dist.aa(protAln, scaled=TRUE)))
write.table(aai, file = 'SymbioticProteins/NifD_percent_identity.txt', sep="\t")

# NifK
proteinAlignment = file.path("SymbioticProteins/NifK_mafft.faa")
protAln = as.matrix(read.FASTA(proteinAlignment, type='AA'))
aai = 100 * (1 - as.matrix(dist.aa(protAln, scaled=TRUE)))
write.table(aai, file = 'SymbioticProteins/NifK_percent_identity.txt', sep="\t")

