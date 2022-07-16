my ($val, $i, $j, $length, $num, $err);
my @KK = ( () );
my @KK_r = ( () );
my ($val_1, $val_2, $val_3, $val_4, $length1, $length2, $score_min, $numb_peptide_min, $rev);
my @peptide1 = ();
my @peptide2 = ();
my @peptide_score = ();
my @peptide_score_rev = ();
my @KK_seq = ();
my @KK_potential_test = ();
my @eir = ();

my $KK_potential_seq = shift;
my $KK_potential = shift;
my $KK_eir = shift;
my $analysis_data1 = shift; 
my $analysis_data2 = shift; 

printf("%s %s\n", "potential = ", $KK_potential);
printf("%s %s\n", "p53-c-terminal = ", $analysis_data1);
printf("%s %s\n", "analized peptide = ", $analysis_data2);

#Reading of KK potential sequence
open(FH, "<$KK_potential_seq") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   $line =~ s/A/1/g;
   $line =~ s/R/2/g;
   $line =~ s/N/3/g;
   $line =~ s/D/4/g;
   $line =~ s/C/5/g;
   $line =~ s/Q/6/g;
   $line =~ s/E/7/g;
   $line =~ s/G/8/g;
   $line =~ s/H/9/g;
   $line =~ s/I/10/g;
   $line =~ s/L/11/g;
   $line =~ s/K/12/g;
   $line =~ s/M/13/g;
   $line =~ s/F/14/g;
   $line =~ s/P/15/g;
   $line =~ s/S/16/g;
   $line =~ s/T/17/g;
   $line =~ s/W/18/g;
   $line =~ s/Y/19/g;
   $line =~ s/V/20/g;
   push(@KK_potential_seq, split(/ /, $line));
 #  foreach $val (@KK_potential_seq) {
 #     printf("%s\n",$val);
 #  }
}

$num = 0;
#Reading of KK potential �Ίp���̏㑤
open(FH, "<$KK_potential") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   @KK_potential_test = ();
   push(@KK_potential_test, split(/ /, $line));
   $i = 0;
   foreach $val (@KK_potential_test) {
      if ($num > $i){
         $KK[$KK_potential_seq[$num]][$KK_potential_seq[$i]] = $KK[$KK_potential_seq[$i]][$KK_potential_seq[$num]];
      }else{
         $KK[$KK_potential_seq[$num]][$KK_potential_seq[$i]] = $val;
      }
     # printf("%s %s %s %s %s\n", $num, $i, $KK_potential_seq[$num], $KK_potential_seq[$i], $KK[$KK_potential_seq[$num]][$KK_potential_seq[$i]]);
      $i++;
   }
   $num++;
}

#Reading of eir
open(FH, "<$KK_eir") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   @KK_potential_test = ();
   push(@KK_potential_test, split(/ /, $line));
   $i = 0;
   foreach $val (@KK_potential_test) {
      $eir[$KK_potential_seq[$i]] =  $val;
      $i++;
   }
}

# eij + err -eir -ejr �̌v�Z
for ($i=1; $i < 21; $i++){
   for ($j=1; $j < 21; $j++){
   	$KK_r[$i][$j] = $KK[$i][$j] -2.40233185 - $eir[$i] -  $eir[$j]; 
      #  printf("%s %s %s %s\n", $i, $j, $KK[$i][$j], $KK_r[$i][$j]);
   }
}

for ($i=1; $i < 21; $i++){
  # printf("%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n", $KK_r[$i][1], $KK_r[$i][2], $KK_r[$i][3], $KK_r[$i][4], $KK_r[$i][5], $KK_r[$i][6], $KK_r[$i][7], $KK_r[$i][8], $KK_r[$i][9], $KK_r[$i][10], $KK_r[$i][11], $KK_r[$i][12], $KK_r[$i][13], $KK_r[$i][14], $KK_r[$i][15], $KK_r[$i][16], $KK_r[$i][17], $KK_r[$i][18], $KK_r[$i][19], $KK_r[$i][20]);
  # printf("%s %s %s %s %s %s %s %s %s %s %s\n", $i, $KK[$i][1], $KK[$i][2], $KK[$i][3], $KK[$i][4], $KK[$i][5], $KK[$i][6], $KK[$i][7], $KK[$i][8], $KK[$i][9], $KK[$i][10]);
  # printf("%s %s %s %s %s %s %s %s %s %s %s\n", $i, $KK[$i][11], $KK[$i][12], $KK[$i][13], $KK[$i][14], $KK[$i][15], $KK[$i][16], $KK[$i][17], $KK[$i][18], $KK[$i][19], $KK[$i][20]);

  # printf("%s %s %s %s %s %s %s %s %s %s %s\n", $i, $KK_r[$i][1], $KK_r[$i][2], $KK_r[$i][3], $KK_r[$i][4], $KK_r[$i][5], $KK_r[$i][6], $KK_r[$i][7], $KK_r[$i][8], $KK_r[$i][9], $KK_r[$i][10]);
  # printf("%s %s %s %s %s %s %s %s %s %s %s\n", $i, $KK_r[$i][11], $KK_r[$i][12], $KK_r[$i][13], $KK_r[$i][14], $KK_r[$i][15], $KK_r[$i][16], $KK_r[$i][17], $KK_r[$i][18], $KK_r[$i][19], $KK_r[$i][20]);
}

#printf("\n");

#Reading of sequence_peptide_1
open(FH, "<$analysis_data1") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   $line =~ s/A/1 /g;
   $line =~ s/R/2 /g;
   $line =~ s/N/3 /g;
   $line =~ s/D/4 /g;
   $line =~ s/C/5 /g;
   $line =~ s/Q/6 /g;
   $line =~ s/E/7 /g;
   $line =~ s/G/8 /g;
   $line =~ s/H/9 /g;
   $line =~ s/I/10 /g;
   $line =~ s/L/11 /g;
   $line =~ s/K/12 /g;
   $line =~ s/M/13 /g;
   $line =~ s/F/14 /g;
   $line =~ s/P/15 /g;
   $line =~ s/S/16 /g;
   $line =~ s/T/17 /g;
   $line =~ s/W/18 /g;
   $line =~ s/Y/19 /g;
   $line =~ s/V/20 /g;
   push(@peptide1, split(/ /, $line));

#   foreach $val (@peptide1) {
#      printf("%s\n",$val);
#   }
}

#Reading of sequence_peptide_2
open(FH, "<$analysis_data2") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   $line =~ s/A/1 /g;
   $line =~ s/R/2 /g;
   $line =~ s/N/3 /g;
   $line =~ s/D/4 /g;
   $line =~ s/C/5 /g;
   $line =~ s/Q/6 /g;
   $line =~ s/E/7 /g;
   $line =~ s/G/8 /g;
   $line =~ s/H/9 /g;
   $line =~ s/I/10 /g;
   $line =~ s/L/11 /g;
   $line =~ s/K/12 /g;
   $line =~ s/M/13 /g;
   $line =~ s/F/14 /g;
   $line =~ s/P/15 /g;
   $line =~ s/S/16 /g;
   $line =~ s/T/17 /g;
   $line =~ s/W/18 /g;
   $line =~ s/Y/19 /g;
   $line =~ s/V/20 /g;
   push(@peptide2, split(/ /, $line));

#   foreach $val (@peptide2) {
#      printf("%s\n",$val);
#   }
}

$length1 = @peptide1;
$length2 = @peptide2;
$score_min = 1000;
$numb_peptide_min = 0;
$rev = 0;

for ($i=1; $i < ($length1-$length2+1-1); $i++){
   for ($j=0; $j < $length2; $j++){
      $peptide_score[$i] += ($KK_r[$peptide1[$j+$i]][$peptide2[$j]]+$KK_r[$peptide1[$j+$i+1]][$peptide2[$j]]+$KK_r[$peptide1[$j+$i-1]][$peptide2[$j]]);
      $peptide_score_rev[$i] += ($KK_r[$peptide1[$j+$i]][$peptide2[$length2-$j-1]]+$KK_r[$peptide1[$j+$i-1]][$peptide2[$length2-$j-1]]+$KK_r[$peptide1[$j+$i+1]][$peptide2[$length2-$j-1]]);
     # printf("%s %s %s %s %s\n", $i, $j, $peptide1[$j+$i], $peptide2[$j], $KK[$peptide1[$j+$i]][$peptide2[$j]]);
   }
   printf("%s %s %s %s %s\n", $i+1, $length2, $peptide_score[$i], $peptide_score[$i]/$length2, 0);
   #printf("%s %s %s %s %s\n", $i+1, $length2, $peptide_score_rev[$i], $peptide_score_rev[$i]/$length2, 1);
   if ($peptide_score[$i] <  $score_min){
      $numb_peptide_min = $i;
      $score_min = $peptide_score[$i];
      $rev = 0;
     # printf("%s %s %s\n", $i+1, $score_min, 0);
   }
   if ($peptide_score_rev[$i] <  $score_min){
      $numb_peptide_min = $i;
      $score_min = $peptide_score_rev[$i];
      $rev = 1;
    #  printf("%s %s %s\n", $i+1, $score_min, 1);
   }
}
printf("\n");
 printf("%s %s %s %s\n", $numb_peptide_min+1,  $score_min, $score_min/$length2, $rev);


exit(0);
