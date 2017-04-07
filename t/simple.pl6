#!/usr/bin/env perl6

use v6;

use lib "..";
use AI::NeuralNetwork;

my $nn = AI::NeuralNetwork.new(learning-rate => .1,
                               inputs => 2,
							   outputs => 1,
                               hidden => [4,4]);

#say $nn.perl;

for 0 .. 10000 -> $count {
	my $good = True;
    say $count;
    for [0,1] -> $a {
      for [0,1] -> $b {
  	    #my $exp = $a || $b;
  	    my $exp = $a +^ $b;
  		my $raw = $nn.sim(input => [$a*2-1,$b*2-1])[0];
  		my $out = ($raw > 0) ?? 1 !! 0;
        say "{$a} {$b} {$exp}({$out}:{$raw})";
  	    $good = False if $out != $exp;
      }
    }
      .perl.say for $nn.layers;
      say '';
    last if $good;
	my $a = [0,1].pick.Int;
	my $b = [0,1].pick.Int;
	#my $exp = $a || $b;
	my $exp = $a +^ $b;
	$nn.train(input => [$a*2-1,$b*2-1],
			  expected => [($exp*2)-1]);
}

	  for [0,1] -> $a {
		for [0,1] -> $b {
		  #my $exp = $a || $b;
		  my $exp = $a +^ $b;
		  my $out = ($nn.sim(input => [$a*2-1,$b*2-1])[0] > 0) ?? 1 !! 0;
          say "{$a} {$b} {$exp}({$out})";
	    }
	  }
      .perl.say for $nn.layers;
      say '';
