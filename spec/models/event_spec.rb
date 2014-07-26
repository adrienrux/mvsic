require 'spec_helper'

describe Event do

  it { should have_one :venue }
  it { should belong_to :artist }

end
