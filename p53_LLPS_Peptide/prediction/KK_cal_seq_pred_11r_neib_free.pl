my ($val, $i, $j, $length, $num, $err);
my @MJ = ( () );
my @MJ_r = ( () );
my ($val_1, $val_2, $val_3, $val_4, $length1, $length2, $score_min, $numb_peptide_min, $rev);
my @peptide1 = ();
my @peptide2 = ();
my @peptide_score = ();
my @peptide_score_rev = ();
my @MJ_seq = ();
my @MJ_potential_test = ();
my @eir = ();

my $MJ_potential_seq = shift;
my $MJ_potential = shift;
my $MJ_eir = shift;
my $analysis_data1 = shift; 
my $pred_length = shift; 

printf("%s %s\n", "potential = ", $MJ_potential);
printf("%s %s\n", "original sequence = ", $analysis_data1);
#printf("%s %s\n", "analized peptide = ", $analysis_data2);

#Reading of MJ potential sequence
open(FH, "<$MJ_potential_seq") or die;
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
   push(@MJ_potential_seq, split(/ /, $line));
#   foreach $val (@MJ_potential_seq) {
#      printf("%s\n",$val);
#   }
}

$num = 0;
#Reading of MJ potential �Ίp���̏㑤
open(FH, "<$MJ_potential") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   @MJ_potential_test = ();
   push(@MJ_potential_test, split(/ /, $line));
   $i = 0;
   foreach $val (@MJ_potential_test) {
      if ($num > $i){
         $MJ[$MJ_potential_seq[$num]][$MJ_potential_seq[$i]] = $MJ[$MJ_potential_seq[$i]][$MJ_potential_seq[$num]];
      }else{
         $MJ[$MJ_potential_seq[$num]][$MJ_potential_seq[$i]] = $val;
      }
      #printf("%s %s %s %s %s\n", $num, $i, $MJ_potential_seq[$num], $MJ_potential_seq[$i], $MJ[$MJ_potential_seq[$num]][$MJ_potential_seq[$i]]);
      $i++;
   }
   $num++;
}

#Reading of eir
open(FH, "<$MJ_eir") or die;
while (($line = <FH>) ne "") {
   next if $line =~ /^\s*$/;
   chomp($line);
   @MJ_potential_test = ();
   push(@MJ_potential_test, split(/ /, $line));
   $i = 0;
   foreach $val (@MJ_potential_test) {
      $eir[$MJ_potential_seq[$i]] =  $val;
      $i++;
   }
}

# eij + err -eir -ejr �̌v�Z
for ($i=1; $i < 21; $i++){
   for ($j=1; $j < 21; $j++){
   	$MJ_r[$i][$j] = $MJ[$i][$j] -2.425325 - $eir[$i] -  $eir[$j]; 
      #  printf("%s %s %s %s\n", $i, $j, $MJ[$i][$j], $MJ_r[$i][$j]);
   }
}


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

   # foreach $val (@peptide1) {
   #   printf("%s\n",$val);
   #}
}



$length1 = @peptide1;
$length2 =  $pred_length;
@peptide2 = ();


for ($i=0; $i < ($length1-$length2+1); $i++){
   for ($j=0; $j < $length2; $j++){
      $score_min = 1000000;
      $numb_peptide_min = 1000000;
      for ($k=1; $k < 21; $k++){
        if ($score_min > $MJ_r[$peptide1[$j+$i]][$k]){
             $numb_peptide_min = $k;
             $score_min = $MJ_r[$peptide1[$j+$i]][$k];
         }
          # printf("%s %s %s %s %s\n",$i, $j, $k, $peptide1[$j+$i], $MJ[$peptide1[$j+$i]][$k]);
      }
      $peptide_score[$i] += $score_min;
      $peptide_seq[$i][$j] = $numb_peptide_min;  
   }
}

printf("\n");

for ($i=0; $i < ($length1-$length2+1); $i++){
   for ($j=0; $j < $length2; $j++){
      $val = $peptide_seq[$i][$j];
      $val =~ s/10/I/g;
      $val =~ s/11/L/g;
      $val =~ s/12/K/g;
      $val =~ s/13/M/g;
      $val =~ s/14/F/g;
      $val =~ s/15/P/g;
      $val =~ s/16/S/g;
      $val =~ s/17/T/g;
      $val =~ s/18/W/g;
      $val =~ s/19/Y/g;
      $val =~ s/20/V/g;
      $val =~ s/1/A/g;
      $val =~ s/2/R/g;
      $val =~ s/3/N/g;
      $val =~ s/4/D/g;
      $val =~ s/5/C/g;
      $val =~ s/6/Q/g;
      $val =~ s/7/E/g;
      $val =~ s/8/G/g;
      $val =~ s/9/H/g;
    #  printf("%s %s %s\n", $i+1, $j+1, $val);
      $peptide_seq_write = $peptide_seq_write.$val;
   }
   printf("%s %s %s\n", $i+1, $peptide_score[$i], $peptide_seq_write);
   $peptide_seq_write = "";
}



exit(0);
