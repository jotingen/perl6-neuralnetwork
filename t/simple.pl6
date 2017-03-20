#!/usr/bin/env perl6

use v6;

use lib "..";
use AI::NeuralNetwork;

my $nn = AI::NeuralNetwork.new(inputs => 2,
							   outputs => 1,
                               levelsize => []);

say $nn.perl;

say $nn.train(input => [0,1],
			  expected => [1]);
