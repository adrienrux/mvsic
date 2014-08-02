require 'active_support/concern'

module HasHashedId
  extend ActiveSupport::Concern

  included do
    before_validation(on: :create) { generate_hashed_id }
    validates_uniqueness_of :hashed_id
  end

  private
  # Generates a 8 digit hexidecimal ID
  def generate_hashed_id
    self.hashed_id ||= Digest::SHA1.hexdigest([Time.now, rand].join).first(8)
  end
end
