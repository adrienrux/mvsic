require 'spec_helper'

describe Event do

  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }
  it { should belong_to :venue }
  it { should belong_to :artist }

  it 'should validate that end_time is after start_time' do
    expect{ create(:event, start_time: Time.now, end_time: Time.now - 1.hour) }.to raise_error(ActiveRecord::RecordInvalid)
  end

end
