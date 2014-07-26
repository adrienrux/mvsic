require 'spec_helper'

describe Venue do

  it { should validate_presence_of :name }
  it { should have_many :event }
  it { should belong_to :festival }

end
