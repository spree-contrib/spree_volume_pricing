class VolumePrice < ActiveRecord::Base
  belongs_to :variant
  acts_as_list :scope => :variant

  validates :range, :format => {:with => /\([0-9]+(?:\.{2,3}[0-9]+|\+\))/, :message => "must be in one of the following formats: (a..b), (a...b), (a+)"}
  validates_presence_of :variant
  validates_presence_of :amount
  validates_presence_of :discount_type
  validates :discount_type, :inclusion => {:in => %w(price dollar percent), :message => "%{value} is not a valid Volume Price Type"}
  
  OPEN_ENDED = /\([0-9]+\+\)/
  
  def include?(quantity)
    if open_ended?
      bound = /\d+/.match(range)[0].to_i
      return quantity >= bound
    else
      range.to_range === quantity
    end
  end
  
  # indicates whether or not the range is a true Ruby range or an open ended range with no upper bound
  def open_ended?
    OPEN_ENDED =~ range
  end
end
