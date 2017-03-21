#!/usr/bin/env perl6

use v6;

unit module AI;

class Neuron {
  has @.weights is rw;
  has Num $.out;
  has Num $.error is rw;
  
  method calc (@inputs) {
    my $net = 0;
    for 0 ..^ @inputs.elems -> $ndx {
      $net += @inputs[$ndx] * @!weights[$ndx];
    }
    $!out = 1/(1+(-$net).exp);
    return $!out;
  }

  method derivative {
    return $!out * ( 1 - $!out );
  }

};

class NeuralNetwork {
  has UInt $.inputs;
  has UInt $.outputs;
  has Num  @.out;
  has      @.layer-output;
  has      @.layer-hidden;

method BUILD (:$inputs!, 
              :$outputs!, 
              :$hidden!) {
  $!inputs  = $inputs; 
  $!outputs = $outputs;
  
  for 0 ..^ $hidden {
    push @!layer-hidden, ::Neuron.new(weights => [(-1000 .. 1000).pick/1000.0 xx $inputs]);
  }

  for 0 ..^ $outputs {
    push @!layer-output, ::Neuron.new(weights => [(-1000 .. 1000).pick/1000.0 xx $hidden]);
  }

}


method sim (:@input!) {

  my @output;

  for 0 ..^ @!layer-hidden.elems -> $i {
    @!layer-hidden[$i].calc(@input);
  }

  for 0 ..^ @!layer-output.elems -> $i {
    my @hidden-outputs;
    for 0 ..^ @!layer-hidden.elems -> $k {
      push @hidden-outputs, @!layer-hidden[$k].out;
    }
    @!layer-output[$i].calc(@hidden-outputs);
    push @output, @!layer-output[$i].out;
  }

  return @output;
}

method train (:@input!, 
              :@expected!) {

  my $learning-rate = .25;

  self.sim(input => @input);

  for 0 ..^ @!layer-output.elems -> $i {
    @!layer-output[$i].error = (@expected[$i] - @!layer-output[$i].out) * @!layer-output[$i].derivative;
    for 0 ..^ @!layer-output.[$i].weights.elems -> $w {
      @!layer-output[$i].weights[$w] += $learning-rate * @!layer-output[$i].error * @!layer-hidden[$w].out;
    }
  }
  
  for 0 ..^ @!layer-hidden.elems -> $i {
    my $weighted-error = 0;
    for 0 ..^ @!layer-output.elems -> $j {
      $weighted-error += @!layer-output[$j].error * @!layer-hidden[$i].weights[$j];
    }
    @!layer-hidden[$i].error = $weighted-error * @!layer-hidden[$i].derivative;
    for 0 ..^ @!layer-hidden.[$i].weights.elems -> $w {
      @!layer-hidden[$i].weights[$w] += $learning-rate * @!layer-hidden[$i].error * @input[$w];
    }
  }


}

};
