FactoryGirl.define do

  factory :festival do
    name 'Mysteryland'
    location 'Bethel, NY'
    description 'The best festival ever'
    start_date { Date.tomorrow }
    end_date { Date.tomorrow + 2.days }
  end

  factory :venue do
    name 'Main Stage'
  end

  factory :artist do
    name 'Jamie Jones'
  end

  factory :event do
    start_time { Time.now - 1.hour }
    end_time { Time.now }
    festival
    artist
  end

end
