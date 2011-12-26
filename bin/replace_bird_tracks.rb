#!/usr/bin/env ruby
$accumulator = []

def flush_accumulator
  unless $accumulator.empty?
    puts "\\begin{code}"
    $accumulator.each do |line|
      print line
    end
    puts "\\end{code}"
  end
  $accumulator = []
end

ARGF.lines.each do |line|
  if line[0] == '>'
    $accumulator << line[2..-1]
  else
    flush_accumulator
    print line
  end
end
flush_accumulator
