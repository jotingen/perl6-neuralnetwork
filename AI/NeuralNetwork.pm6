#!/usr/bin/env perl6

use v6;

unit module AI;

class Neuron {
  has @.weights is rw;
  has Num $.out;
  
  method calc (@inputs) {
    my $net = 0;
    for 0 ..^ @inputs.elems -> $ndx {
      $net += @inputs[$ndx] * @!weights[$ndx];
    }
    $!out = 1/(1+(-$net).exp);
    return $!out;
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
  }
  @level = [];
  for 0 ..^ $outputs {
    push @level, ::Neuron.new(weights => [-1,1]);
  }
  push @!levels, @level;

}


method sim (:@input!) {
 for @!levels -> @level {
  for @level -> $neuron {
    $neuron.calc(@input);
  }
 }
  my @output;
  for @!levels[*-1] -> @level {
  for @level -> $neuron {
    push @output, $neuron.out;
  }
}
return @output;
}

method train (:@input!, 
              :@expected!) {
  my @outputs = self.sim(input => @input);
  my @errors;
  for 0 ..^ @expected.elems -> $ndx {
     push @errors, 1/2*(@expected[$ndx]-@outputs[$ndx])**2;
  }
  say "{@input} : {@outputs}({@expected}) : {@errors}";
  
  my $learning-rate = .5;
 for @!levels -> @level {
  for @level -> $neuron {
    for 0 ..^ $neuron.weights.elems -> $w {
      $neuron.weights[$w] = $neuron.weights[$w] - $learning-rate * ($neuron.out-@expected) * $neuron.out * (1 - $neuron.out) * $neuron.out;
    }
  }
 }
  return @errors;
}

};
