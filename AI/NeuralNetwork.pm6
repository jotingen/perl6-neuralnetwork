#!/usr/bin/env perl6

use v6;

unit module AI;

class Neuron {
  has @weights;
  my $value;
  
  method calc (@inputs) {
    say 'T';
    my @sub;
    for 0 ..^ @inputs.elems -> $ndx {
      push @sub, @inputs[$ndx] * @!weights[$ndx];
    }
    say 'T';
    say @inputs.perl;
    say @!weights.perl;
    say @sub.perl;
    return @sub.sum > 0;
  }
};

class NeuralNetwork {
  has UInt $inputs;
  has UInt $outputs;
  has      @levels;

method BUILD (:$inputs!, 
              :$outputs!, 
              :@levelsize!) {
  $!inputs  = $inputs; 
  $!outputs = $outputs;
  
  my @level = [];
  for @levelsize -> $size {
    @level = [];
    for 0 ..^ $size {
      push @level, ::Neuron.new(weights => [(-200 .. 200).pick/100.0]);
    }
    push @!levels, @level;
    say "multi";
  }
  @level = [];
  for 0 ..^ $outputs {
    push @level, ::Neuron.new(weights => [-1,1]);
  }
  @level.perl.say;
  push @!levels, @level;

  #if @levelsize.elems {
  #
  #} else {
  #  for 0 ..^ $inputs {
  #    my @w;
  #    for 0 ..^ $outputs {
  #      push @w, (-200 .. 200).pick/100.0;
  #    }
  #    push @!weights, @w;
  #  }
  #}

}


method sim (:@input!) {
 say @!levels.perl; 
 for @levels -> @level {
  for @level -> $neuron {
    say $neuron.calc(@input);
  }
 }
 return (@input.sum)/(@input.elems);
}

method train (:@input!, 
              :@expected!) {
  say @input;
  my @outputs = self.sim(input => @input);
  say @outputs;
  return @outputs/@expected*1.0;
}

};
