require 'spec_helper'

describe Venue do

  it { should validate_presence_of :name }
  it { should belong_to :event }
  it { should belong_to :festival }

end
