class BoxId
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def histogram
    return @histogram if @histogram
    @histogram = Hash.new(0)
    id.each_char { |c| @histogram[c] = @histogram[c] + 1 }
    @histogram
  end

  def chars_in_common(other_box_id)
    common = ''
    index = 0
    id.each_char do |c|
      common += c if c == other_box_id.id[index]
      index += 1
    end
    common
  end
end

class BoxIdSet
  attr_reader :box_ids

  def initialize(box_ids)
    @box_ids = box_ids
  end

  def self.from_file(path)
    new(File.readlines(path).map { |box_id| BoxId.new(box_id) })
  end

  def checksum
    two = 0
    three = 0
    box_ids.each do |box_id|
      two += 1 if box_id.histogram.value?(2)
      three += 1 if box_id.histogram.value?(3)
    end
    two * three
  end

  def common_between_ids_off_by_one
    box_ids.each_with_index do |box_id, index|
      box_ids.to_enum.with_index(index + 1).each do |other_box_id|
        common = box_id.chars_in_common(other_box_id)
        return common if common.length == box_id.id.length - 1
      end
    end
  end
end

puts BoxIdSet.from_file('input.txt').common_between_ids_off_by_one
