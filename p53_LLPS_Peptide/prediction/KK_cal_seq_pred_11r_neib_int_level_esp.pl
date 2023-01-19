use Math::Round;
my ($val, $i, $j, $l, $k, $x, $y, $m,$n, $length, $num, $err, $total_point);
my @MJ = ( () );
my @MJ_r = ( () );
my ($val_1, $val_2, $val_3, $val_4, $length1, $length2, $score_min, $numb_peptide_min);
my ($score_compare, $score_compare_min, $numb_compare, $numb_compare_min, $peptide_position, $peptide_position_min);
my ($score_compare_align, $number_peptide, $score_compare_align_max, $score_compare_max, $peptide_number);
my ($length3, $peptide_score2, $peptide_score_rev, $merged_score_total, $merged_score_rev, $merged_score_specific, $merged_score_total, $Elocation, $Eseq, $Especific_global); #Especific variable
my ($peptide_level, $treshold, $treshold_align); #changing variable
my @peptide1 = ();
my @peptide2 = ();
my @peptide3 = ();
my @merged_score_min = (());
my @merged_score = ();
my @merged_position = (());
my @merged_score_min_rev = (());
my @Especific = ();
my @peptide_score = ();
my @MJ_seq = ();
my @MJ_potential_test = ();
my @eir = ();


my $MJ_potential_seq = shift;
my $MJ_potential = shift;
my $MJ_eir = shift;
my $analysis_data1 = shift; 
my $analysis_data3 = shift; 
my $pred_length = shift;
my $peptide_level = shift;

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
   	$MJ_r[$i][$j] = $MJ[$i][$j] -2.40233185 - $eir[$i] -  $eir[$j]; 
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

#Reading of sequence_peptide_3
open(FH, "<$analysis_data3") or die;
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
   push(@peptide3, split(/ /, $line));

   #foreach $val (@peptide3) {
   #printf("%s\n",$val);
   #}
}


$length1 = @peptide1;
$length2 =  $pred_length;
@peptide2 = ();

#Counting the lowest sequences
$l = 0;
for ($i=1; $i < ($length1-$length2+1-1); $i++){
   for ($j=0; $j < $length2; $j++){
      $score_min = 1000000;
      $numb_peptide_min = 1000000;
      for ($k=1; $k < 21; $k++){
        if ($score_min > ($MJ_r[$peptide1[$j+$i]][$k]+$MJ_r[$peptide1[$j+$i+1]][$k]+$MJ_r[$peptide1[$j+$i-1]][$k])){
             $numb_peptide_min = $k;
             $score_min =  ($MJ_r[$peptide1[$j+$i]][$k]+$MJ_r[$peptide1[$j+$i+1]][$k]+$MJ_r[$peptide1[$j+$i-1]][$k]);
        }
        #printf("%s %s %s %s %s\n",$i, $j, $k, $peptide1[$j+$i], $MJ_r[$peptide1[$j+$i]][$k]);
      }
      $peptide_score[$i][$l] += $score_min;
      $peptide_seq[$i][$j][$l] = $numb_peptide_min;  
    }
}


#counting $peptide_level lowest sequences
for ($i=1; $i < ($length1-$length2+1-1); $i++){
    for($l=0; $l < ($peptide_level-1); $l++){
        $score_compare_min = 1000000;
        $numb_compare_min = 1000000;
        $peptide_position_min =1000000; #changing the position of designed sequence
        for ($j=0; $j < $length2; $j++){
            $score_compare = 1000000;
            $numb_compare = 1000000;
            $peptide_position = 1000000;
            for ($k=1; $k < 21; $k++){
                if (($MJ_r[$peptide1[$j+$i]][$peptide_seq[$i][$j][$l]]+$MJ_r[$peptide1[$j+$i+1]][$peptide_seq[$i][$j][$l]]+$MJ_r[$peptide1[$j+$i-1]][$peptide_seq[$i][$j][$l]]) <  ($MJ_r[$peptide1[$j+$i]][$k]+$MJ_r[$peptide1[$j+$i+1]][$k]+$MJ_r[$peptide1[$j+$i-1]][$k])){
                    if ($score_compare >  $peptide_score[$i][$l] - ($MJ_r[$peptide1[$j+$i]][$peptide_seq[$i][$j][$l]]+$MJ_r[$peptide1[$j+$i+1]][$peptide_seq[$i][$j][$l]]+$MJ_r[$peptide1[$j+$i-1]][$peptide_seq[$i][$j][$l]]) + ($MJ_r[$peptide1[$j+$i]][$k]+$MJ_r[$peptide1[$j+$i+1]][$k]+$MJ_r[$peptide1[$j+$i-1]][$k])){
                        $peptide_position = $j; #position in designed sequence
                        $numb_compare = $k; #amino acid
                        $score_compare = $peptide_score[$i][$l] - ($MJ_r[$peptide1[$j+$i]][$peptide_seq[$i][$j][$l]]+$MJ_r[$peptide1[$j+$i+1]][$peptide_seq[$i][$j][$l]]+$MJ_r[$peptide1[$j+$i-1]][$peptide_seq[$i][$j][$l]]) + ($MJ_r[$peptide1[$j+$i]][$k]+$MJ_r[$peptide1[$j+$i+1]][$k]+$MJ_r[$peptide1[$j+$i-1]][$k]);
                    }
                }
            #printf("%s %s %s %s %s\n",$i, $j, $k, $peptide1[$j+$i], $MJ_r[$peptide1[$j+$i]][$k]);
            }
            if ($score_compare_min > $score_compare){
                $score_compare_min = $score_compare; 
                $peptide_position_min = $peptide_position; #save the lowest position of j
                $numb_compare_min = $numb_compare; 
            }
            $peptide_seq[$i][$j][$l+1] = $peptide_seq[$i][$j][$l];
        }
    $peptide_score[$i][$l+1] = $score_compare_min;
    $peptide_seq[$i][$peptide_position_min][$l+1] = $numb_compare_min;
    }
}


$length3 = @peptide3; #FLp53

for ($k=1; $k < ($length1-$length2+1-1); $k++){
    for($l=0; $l < ($peptide_level); $l++){
        $merged_score_total = 0;
        $merged_score_rev = 0;
        $merged_score_min[$k][$l] = 1000;
        my @merged_score = ();
        for ($i=1; $i < ($length3-$length2); $i++){
            if ($i < (94-$length2) || $i <(325-$length2) && $i > 294 || $i <($length3-$length2) && $i > 357){
                $peptide_score2 = 0;
                $peptide_score_rev = 0;
                for ($j=0; $j < $length2; $j++){
                    $peptide_score2 += ($MJ_r[$peptide3[$j+$i]][$peptide_seq[$k][$j][$l]]+$MJ_r[$peptide3[$j+$i+1]][$peptide_seq[$k][$j][$l]]+$MJ_r[$peptide3[$j+$i-1]][$peptide_seq[$k][$j][$l]]);
                    $peptide_score_rev += ($MJ_r[$peptide3[$j+$i]][$peptide_seq[$k][$length2-$j-1][$l]]+$MJ_r[$peptide3[$j+$i-1]][$peptide_seq[$k][$length2-$j-1][$l]]+$MJ_r[$peptide3[$j+$i+1]][$peptide_seq[$k][$length2-$j-1][$l]]);
                    #printf("%s %s %s %s %s\n", $i, $j, $peptide3[$j+$i], $peptide_seq[$k][$j], $KK[$peptide1[$j+$i]][$peptide_seq[$k][$j]]);
                }
                #printf("%s %s %s %s %s\n", $i+1, $length2, $peptide_score[$i], $peptide_score[$i]/$length2, 0);
                #printf("%s %s %s %s %s\n", $i+1, $length2, $peptide_score_rev[$i], $peptide_score_rev[$i]/$length2, 1);
                if ($peptide_score2 <= $peptide_score_rev){
                    $merged_score[$i] = $peptide_score2;
                    $merged_score_rev = 0;
                }else{
                    $merged_score[$i] = $peptide_score_rev;
                    $merged_score_rev = 1;
                }
                if ($merged_score[$i] < $merged_score_min[$k][$l]){
                    $merged_score_min[$k][$l] = $merged_score[$i];
                    $merged_score_min_rev[$k][$l] = $merged_score_rev;
                    $merged_position[$k][$l] = $i;
                }
                if ($merged_score[$i] < 0){
                    $merged_score_total += $merged_score[$i];
                }
                #printf("%s %s %s %s\n", $i+1, $length2, $merged_score[$i], $merged_score_rev);
            }
        }
        $merged_score_specific = 0;
        for ($m= ($merged_position[$k][$l] - round($length2/2))+1; $m < ($merged_position[$k][$l] + round($length2/2)); $m++){
            #printf("%s %s\n", $i+1, $merged_score[$i]);
            if ($merged_score[$m] < 0){
                $merged_score_specific += $merged_score[$m];
            }
        }
        $Especific[$k][$l] = $merged_score_specific/$merged_score_total;
    }
}

printf("\n");

for ($i=1; $i < ($length1-$length2+1-1); $i++){
    for($l=0; $l < ($peptide_level); $l++){
        for ($j=0; $j < $length2; $j++){
            $val = $peptide_seq[$i][$j][$l];
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
            #printf("%s %s %s\n", $i+1, $j+1, $val);
            $peptide_seq_write = $peptide_seq_write.$val;
        }
        printf("%s %s %s %s %s %s %s %s\n", 
                $i+1, $l+1, $peptide_seq_write, 
                $peptide_score[$i][$l], $merged_position[$i][$l]+1, $merged_score_min[$i][$l],
                $merged_score_min_rev[$i][$l], $Especific[$i][$l]);
        $peptide_seq_write = "";
    }
}

exit(0);
