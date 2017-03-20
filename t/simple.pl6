#!/usr/bin/env perl6

use v6;

use lib "..";
use AI::NeuralNetwork;

my $nn = AI::NeuralNetwork.new(inputs => 2,
							   outputs => 1,
                               levelsize => []);

say $nn.perl;

for 0 ..^ 5 {
	$nn.train(input => [[0,1].pick,[0,1].pick],
			  expected => [1]);
	say $nn.perl;
}
