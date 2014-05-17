require 'spec_helper'

describe Festival do

  it { should validate_presence_of :name }
  it { should validate_presence_of :location }
  it { should validate_presence_of :description }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should have_many :venues }

  it 'should validate that end_date is after start_date' do
    expect{ create(:festival, start_date: Date.today, end_date: Date.today - 1.day) }.to raise_error(ActiveRecord::RecordInvalid)
  end

end
