require 'spec_helper'

describe Festival do

  it { should validate_presence_of :name }
  it { should validate_presence_of :location }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should have_many :venues }
  it { should have_many :events }

end
