open(T,"traits.txt")||die "Can't open your file!";
while(<T>)
{
	chomp;
@aa=split;
$hash{$aa[0]}=$aa[1];	
	}
close(T,R);
open(E,">run.txt");
for($i=1;$i<=$aa[0];$i++)
{
	$t=$hash{$i};
	$slurm="$t\_gemma\.slurm";
		print E "sbatch $slurm\n";
	open(R,">$slurm");
print R "#!/bin/sh
#SBATCH --job-name=$t
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=120:00:00
#SBATCH --mem=50G
#SBATCH --error=$t\.err
#SBATCH --output=$t\.out
#SBATCH --licenses=common
GEMMA -bfile ../293BGEM_V5_dp3.imputed.nohet.miss05.maf001 -k ../2Centered_IBS_kinship.txt -c ../BGEM_293samples_GEMMA_PCA.txt -p phenotype.txt -lmm 4 -n $i -o $t -miss 0.7 -r2 1 -hwe 0 -maf 0.05
";
}
