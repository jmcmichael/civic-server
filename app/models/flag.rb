class Flag < ActiveRecord::Base
  include Subscribable
  include Commentable
  belongs_to :flaggable, polymorphic: true
  belongs_to :flagging_user, class_name: User
  belongs_to :resolving_user, class_name: User

  validates :state, inclusion: ['open', 'resolved']

  def self.index_scope
    includes(comments: [:user])
  end

  def name
    "a flag on #{flaggable.name}"
  end

  def self.create_for_flaggable(user, flaggable)
    cmd = Actions::FlagEntity.new(user, flaggable)
    cmd.perform
  end

  def self.resolve(user, flag)
    cmd = Actions::ResolveFlag.new(user, flag)
    cmd.perform
  end

  def state_params
    {
      flag: {
        id: self.id
      }
    }.merge(flaggable.state_params)
  end
end
