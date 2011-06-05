class Talk < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :camp #denormalized from venue because talks start off w/out a venue when a camp is created

  validates_presence_of :user_id, :unless => :proposal?
  validates_presence_of :venue_id, :unless => :proposal?
  validates_presence_of :start_at, :unless => :proposal?
  validates_presence_of :end_at, :unless => :proposal?
  validate :start_at_is_less_than_end_at, :unless => :proposal?

  acts_as_voteable

  def self.for_day(day)
    where('start_at >= ? and start_at < ?', day, day + 1.day).order(:start_at)
  end

  def day
    start_at.to_date
  end

  private

  def proposal?
    is_proposal
  end

  def start_at_is_less_than_end_at
    if start_at.blank? || end_at.blank? || start_at >= end_at
      errors.add :start_at, "The start time must be before the end time" 
    end
  end
end
