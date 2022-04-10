# Get genomes
cp -r ../6_Core_gene_phylogeny/Genome_files/ .

# Construct pangenomes with varying identity thresholds
roary -p 2 -f Roary_output_90 -i 90 -g 500000 Genome_files/*.gff &
roary -p 2 -f Roary_output_80 -i 80 -g 500000 Genome_files/*.gff &
roary -p 2 -f Roary_output_70 -i 70 -g 500000 Genome_files/*.gff &
roary -p 2 -f Roary_output_60 -i 60 -g 500000 Genome_files/*.gff &
roary -p 2 -f Roary_output_50 -i 50 -g 500000 Genome_files/*.gff &
roary -p 2 -f Roary_output_40 -i 40 -g 500000 Genome_files/*.gff &
wait

# Run Scoary to identify genes associated with adaptation for growth/survival/nodulation in low temperatures
scoary -t Input_files/traits.csv -g Roary_output_90/gene_presence_absence.csv -p 0.01 -c BH -o Roary_output_90 &
scoary -t Input_files/traits.csv -g Roary_output_80/gene_presence_absence.csv -p 0.01 -c BH -o Roary_output_80 &
scoary -t Input_files/traits.csv -g Roary_output_70/gene_presence_absence.csv -p 0.01 -c BH -o Roary_output_70 &
scoary -t Input_files/traits.csv -g Roary_output_60/gene_presence_absence.csv -p 0.01 -c BH -o Roary_output_60 &
scoary -t Input_files/traits.csv -g Roary_output_50/gene_presence_absence.csv -p 0.01 -c BH -o Roary_output_50 &
scoary -t Input_files/traits.csv -g Roary_output_40/gene_presence_absence.csv -p 0.01 -c BH -o Roary_output_40 &
wait

# Calculate numbers of unique genes
head -2 Roary_output_90/gene_presence_absence.csv | sed 's/\"//g' | cut -f15-200 -d',' > Input_files/Species_gene_names.csv
cd Roary_output_90
perl ../getUniqueCounts.pl > unique_counts.txt
grep -v 'R7A' unique_counts.txt > temp.txt
grep -v 'zhangyense' temp.txt > unique_counts.txt
rm temp.txt
grep 'IHJELGJM' gene_presence_absence.csv | grep 'DEPKEEAP' | grep 'OGMKMICI' | grep 'NEOBKMK' | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_japonicum_R7A' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
grep 'KALGMILO' gene_presence_absence.csv | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_zhangyense_CGMCC_1.15528' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
cd ../Roary_output_80
perl ../getUniqueCounts.pl > unique_counts.txt
grep -v 'R7A' unique_counts.txt > temp.txt
grep -v 'zhangyense' temp.txt > unique_counts.txt
rm temp.txt
grep 'IHJELGJM' gene_presence_absence.csv | grep 'DEPKEEAP' | grep 'OGMKMICI' | grep 'NEOBKMK' | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_japonicum_R7A' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
grep 'KALGMILO' gene_presence_absence.csv | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_zhangyense_CGMCC_1.15528' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
cd ../Roary_output_70
perl ../getUniqueCounts.pl > unique_counts.txt
grep -v 'R7A' unique_counts.txt > temp.txt
grep -v 'zhangyense' temp.txt > unique_counts.txt
rm temp.txt
grep 'IHJELGJM' gene_presence_absence.csv | grep 'DEPKEEAP' | grep 'OGMKMICI' | grep 'NEOBKMK' | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_japonicum_R7A' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
grep 'KALGMILO' gene_presence_absence.csv | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_zhangyense_CGMCC_1.15528' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
cd ../Roary_output_60
perl ../getUniqueCounts.pl > unique_counts.txt
grep -v 'R7A' unique_counts.txt > temp.txt
grep -v 'zhangyense' temp.txt > unique_counts.txt
rm temp.txt
grep 'IHJELGJM' gene_presence_absence.csv | grep 'DEPKEEAP' | grep 'OGMKMICI' | grep 'NEOBKMK' | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_japonicum_R7A' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
grep 'KALGMILO' gene_presence_absence.csv | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_zhangyense_CGMCC_1.15528' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
cd ../Roary_output_50
perl ../getUniqueCounts.pl > unique_counts.txt
grep -v 'R7A' unique_counts.txt > temp.txt
grep -v 'zhangyense' temp.txt > unique_counts.txt
rm temp.txt
grep 'IHJELGJM' gene_presence_absence.csv | grep 'DEPKEEAP' | grep 'OGMKMICI' | grep 'NEOBKMK' | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_japonicum_R7A' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
grep 'KALGMILO' gene_presence_absence.csv | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_zhangyense_CGMCC_1.15528' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
cd ../Roary_output_40
perl ../getUniqueCounts.pl > unique_counts.txt
grep -v 'R7A' unique_counts.txt > temp.txt
grep -v 'zhangyense' temp.txt > unique_counts.txt
rm temp.txt
grep 'IHJELGJM' gene_presence_absence.csv | grep 'DEPKEEAP' | grep 'OGMKMICI' | grep 'NEOBKMK' | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_japonicum_R7A' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
grep 'KALGMILO' gene_presence_absence.csv | cut -f4 -d',' | grep '"4"' | wc -l >> temp.txt
echo 'Mesorhizobium_zhangyense_CGMCC_1.15528' > temp2.txt
paste temp2.txt temp.txt >> unique_counts.txt
rm temp.txt
rm temp2.txt
cd ..
