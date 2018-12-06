require 'set'

class Instruction
  def self.parse(instr_string)
    instr_string.to_i
  end
end

class InstructionSet
  attr_reader :instructions, :frequencies

  def initialize(initial, instructions)
    @initial = initial
    @instructions = instructions
  end

  def self.from_file(path)
    parse_set(File.readlines(path))
  end

  def self.parse_set(instr_list)
    new(0, instr_list.map { |instr| Instruction.parse(instr) })
  end

  def apply
    @instructions.inject { |sum, n| sum + n }
  end

  def find_first_repeat_frequency
    current = @initial
    @frequencies = Set.new
    while true
      @instructions.each do |instr|
        current += instr
        return current if @frequencies.include?(current)
        @frequencies.add(current)
      end
    end
  end
end
