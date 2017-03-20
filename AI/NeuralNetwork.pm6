#!/usr/bin/env perl6

use v6;

unit module AI;

class Neuron {
  has @.weights;
  has UInt $.last-value;
  
  method calc (@inputs) {
    my @sub;
    for 0 ..^ @inputs.elems -> $ndx {
      push @sub, @inputs[$ndx] * @!weights[$ndx];
    }
    $!last-value = @sub.sum > 0;
    return $!last-value;
  }
};

class NeuralNetwork {
  has UInt $.inputs;
  has UInt $.outputs;
  has      @.levels;

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

}


method sim (:@input!) {
 for @!levels -> @level {
  for @level -> $neuron {
    $neuron.calc(@input);
  }
 }
 return (@input.sum)/(@input.elems);
}

method train (:@input!, 
              :@expected!) {
  my @outputs = self.sim(input => @input);
  say "{@input} : {@outputs}({@expected})";
  return @outputs/@expected*1.0;
}

};
