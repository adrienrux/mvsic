mysteryland = Festival.where(name: 'Mysteryland', location: 'Bethel, NY', description: 'Cras mattis consectetur purus sit amet fermentum. Donec sed odio dui.', start_date: Date.new(2014, 5, 23), end_date: Date.new(2014, 5, 26)).first_or_create

main_stage = Venue.where(name: 'Main Stage', festival: mysteryland).first_or_create
the_boat = Venue.where(name: 'The Boat', festival: mysteryland).first_or_create
healing_garden = Venue.where(name: 'Healing Garden', festival: mysteryland).first_or_create

sick_individuals = Artist.where(name: 'Sick Individuals').first_or_create
fedde_le_grand = Artist.where(name: 'Fedde Le Grande').first_or_create
nicky_romero = Artist.where(name: 'Nicky Romero').first_or_create
sound_remedy = Artist.where(name: 'Sound Remedy').first_or_create
big_gigantic = Artist.where(name: 'Big Gigantic').first_or_create
marcel_dettman = Artist.where(name: 'Marcel Dettman').first_or_create
jesse_rose = Artist.where(name: 'Jesse Rose').first_or_create
jamie_jones = Artist.where(name: 'Jamie Jones').first_or_create
sasha = Artist.where(name: 'Sasha').first_or_create

Event.where(venue: main_stage, artist: sick_individuals, start_time: DateTime.new(2014, 5, 23, 13), end_time: DateTime.new(2014, 5, 23, 14, 30)).first_or_create
Event.where(venue: main_stage, artist: fedde_le_grand, start_time: DateTime.new(2014, 5, 23, 14, 30), end_time: DateTime.new(2014, 5, 23, 15, 30)).first_or_create
Event.where(venue: main_stage, artist: nicky_romero, start_time: DateTime.new(2014, 5, 23, 15, 30), end_time: DateTime.new(2014, 5, 23, 17)).first_or_create
Event.where(venue: the_boat, artist: sound_remedy, start_time: DateTime.new(2014, 5, 23, 13), end_time: DateTime.new(2014, 5, 23, 14, 30)).first_or_create
Event.where(venue: the_boat, artist: big_gigantic, start_time: DateTime.new(2014, 5, 23, 14, 30), end_time: DateTime.new(2014, 5, 23, 15, 30)).first_or_create
Event.where(venue: the_boat, artist: marcel_dettman, start_time: DateTime.new(2014, 5, 23, 15, 30), end_time: DateTime.new(2014, 5, 23, 17)).first_or_create
Event.where(venue: healing_garden, artist: jesse_rose, start_time: DateTime.new(2014, 5, 23, 13), end_time: DateTime.new(2014, 5, 23, 14, 30)).first_or_create
Event.where(venue: healing_garden, artist: jamie_jones, start_time: DateTime.new(2014, 5, 23, 14, 30), end_time: DateTime.new(2014, 5, 23, 15, 30)).first_or_create
Event.where(venue: healing_garden, artist: sasha, start_time: DateTime.new(2014, 5, 23, 15, 30), end_time: DateTime.new(2014, 5, 23, 17)).first_or_create