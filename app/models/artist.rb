require 'open-uri'

class Artist < ActiveRecord::Base
  include HasTracker

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validate :track_is_streamable?, on: [:create, :update]
  has_many :events, lambda { order :start_time }

  # Some soundcloud tracks are not streamable. This
  # method checks against the resolve API endpoint and
  # returns whether or not the track is streamable.
  def streamable?
    return false unless soundcloud_track_url

    begin
      resp = open("https://api.soundcloud.com/resolve.json?url=#{soundcloud_track_url}&client_id=#{ENV['SOUNDCLOUD_CLIENT_ID']}").read
    rescue OpenURI::HTTPError => error
      return false
    else
      JSON.parse(resp)['streamable']
    end
  end

  private
  def track_is_streamable?
    errors.add(:soundcloud_track_url, 'is not streamable') if (soundcloud_track_url && !streamable?)
  end
end
