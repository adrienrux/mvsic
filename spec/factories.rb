FactoryGirl.define do

  factory :festival do
    name 'Mysteryland'
    location 'Bethel, NY'
    description 'The best festival ever'
    start_date { Date.today - 1.day }
    end_date { Date.today }
  end

  factory :venue do
    name 'Main Stage'
    festival
  end

  factory :artist do
    name 'Jamie Jones'
  end

  factory :event do
    start_time { Time.now - 1.hour }
    end_time { Time.now }
    venue
    artist
  end

end
