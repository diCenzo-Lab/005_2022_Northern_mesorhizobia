#!/usr/bin/env perl

while(<>) {
  chomp;
  @line = split("\t", $_);
  if(@line[11] eq @line[12]) {
    if(@line[0] == 1 && @line[3] == @line[7]) {
      if(@line[1] == @line[7]) {
      }
      else {
        print("$_\n")
      }
    }
  }
}


