#!/usr/bin/env perl6

use v6;

unit module AI;

class Neuron {
  has Bool $.bias = False;
  has @.weights is rw;
  has     $.net;
  has     $.out;
  has     $.error is rw;
  has     $.delta is rw;
  
  method calc (@inputs) {
	if $!bias {
      $!out = 1;
    } else {
      $!net = 0;
      for ^@inputs.elems -> $ndx {
        $!net += @inputs[$ndx] * @!weights[$ndx];
      }
      $!out = tanh($!net);
    }
    return $!out;
  }

  method derivative {
    return 1 - $!out**2;
  }

};

class NeuralNetwork {
  has UInt $.inputs;
  has UInt $.outputs;
  has Num  @.out;
  has      @.layers;
  has      $.learning-rate = .1;

method BUILD (:$inputs!, 
              :$outputs!, 
              :@hidden!) {
  $!inputs  = $inputs; 
  $!outputs = $outputs;
  
  my $layer = 0;

  for @hidden {
    for @hidden[$layer] {
      push @!layers[$layer], ::Neuron.new(weights => [(-250 .. 250).pick/1000.0 xx $inputs+1], bias => False);
    }
    push @!layers[$layer], ::Neuron.new(weights => [0 xx $inputs+1], bias => True);
	$layer++;
  }

  for ^$outputs {
    push @!layers[$layer], ::Neuron.new(weights => [(-250 .. 250).pick/1000.0 xx @!layers[$layer-1].elems], bias => False);
  }

}


method sim (:@input!) {

  for ^@!layers.elems -> $layer {
    for ^@!layers[$layer].elems -> $neuron {
      if $layer == 0 {
        @!layers[$layer][$neuron].calc(@input);
      } else {
		my @prev-outputs; 
        for ^@!layers[$layer-1].elems -> $neuron {
          push @prev-outputs, @!layers[$layer-1][$neuron].out;
        }
        @!layers[$layer][$neuron].calc(@prev-outputs);
      }
    }
  }

  my @output;

    for ^@!layers[*-1].elems -> $neuron {
    push @output, @!layers[*-1][$neuron].out;
}

  return @output;
}

method train (:@input!, 
              :@expected!) {

  my @input-with-bias = @input;
  push @input-with-bias, 1;

  self.sim(input => @input-with-bias);

  for (^@!layers).reverse -> $layer {
    for ^@!layers[$layer].elems -> $neuron {
	  if $layer == @!layers.elems-1 {
	  	@!layers[$layer][$neuron].error = @expected[$neuron] - @!layers[$layer][$neuron].out;
	  } else {
        my $weighted-error = 0;
        for ^@!layers[$layer+1].elems -> $neuron {
          $weighted-error += @!layers[$layer+1][$neuron].error * @!layers[$layer][$neuron].weights[$neuron];
        }
        @!layers[$layer][$neuron].error = $weighted-error;
	  }
	  @!layers[$layer][$neuron].delta = @!layers[$layer][$neuron].error * @!layers[$layer][$neuron].derivative;
    }
  }

  for ^@!layers -> $layer {
    for ^@!layers[$layer].elems -> $neuron {
      for ^@!layers[$layer][$neuron].weights.elems -> $w {
	    if $layer == 0 {
          @!layers[$layer][$neuron].weights[$w] += $!learning-rate * @!layers[$layer][$neuron].delta * @input-with-bias[$w];
        } else {
          @!layers[$layer][$neuron].weights[$w] += $!learning-rate * @!layers[$layer][$neuron].delta * @!layers[$layer-1][$neuron].out;
        }
      }
    }
  }

}

};
