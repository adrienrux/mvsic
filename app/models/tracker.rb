class Tracker < ActiveRecord::Base

  def increment!
    update_attribute :count, read_attribute(:count) + 1
  end

  def instance
    instance_class.constantize.find(instance_id)
  end

  def self.for(obj, subject)
    Tracker.where(instance_class: obj.class.to_s, instance_id: obj.id, subject: subject).first
  end
end
