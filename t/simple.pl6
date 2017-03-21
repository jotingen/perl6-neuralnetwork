#!/usr/bin/env perl6

use v6;

use lib "..";
use AI::NeuralNetwork;

my $nn = AI::NeuralNetwork.new(inputs => 2,
							   outputs => 1,
                               hidden => 10);

#say $nn.perl;

for 0 .. 50000 -> $count {
	if $count%%1000 {
	  say $count;
	  for 0 .. 1 -> $a {
		for 0 .. 1 -> $b {
		  my $exp = $a==1 ?? ($b==1 ?? 0 !! 1) !! ($b==1 ?? 1 !! 0);
          say "{$a} {$b} {$exp}({$nn.sim(input => [$a,$b])})";
	    }
	  }
	}
	my $a = [0,1].pick.Int;
	my $b = [0,1].pick.Int;
	#xor is acting weird
	my $exp = $a==1 ?? ($b==1 ?? 0 !! 1) !! ($b==1 ?? 1 !! 0);
	$nn.train(input => [$a,$b],
			  expected => [$exp]);
}

#say $nn.perl;
