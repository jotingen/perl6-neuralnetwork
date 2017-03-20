#!/usr/bin/env perl6

use v6;

use lib "..";
use AI::NeuralNetwork;

my $nn = AI::NeuralNetwork.new(inputs => 2,
							   outputs => 1,
                               levelsize => []);

say $nn.perl;

for 0 ..^ 50000 {
	my $a = [0,1].pick;
	my $b = [0,1].pick;
	my $exp = ($a && $b).Int;
	$nn.train(input => [$a,$b],
			  expected => [$exp]);
}
	say $nn.perl;
