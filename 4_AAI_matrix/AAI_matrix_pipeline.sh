mkdir tmp/ # Make directory
cp ../3_ANI_matrix/Input_files/genomeList.txt .
cp -r ../3_ANI_matrix/Genome_files/ Genome_files/
comparem aai_wf -e 1e-12 -p 40.0 -a 70.0 --sensitive --tmp_dir tmp/ --file_ext fna -c 24 Genome_files/ Output/ # Run comparem
perl prepareAAImatrix.pl > Output/AAI_matrix.txt # Make a two-way AAI matrix from the comparem output
