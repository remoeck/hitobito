# == Schema Information
#
# Table name: mailing_lists
#
#  id                   :integer          not null, primary key
#  name                 :string(255)      not null
#  group_id             :integer          not null
#  description          :text
#  publisher            :string(255)
#  mail_name            :string(255)
#  additional_sender    :string(255)
#  subscribable         :boolean          default(FALSE), not null
#  subscribers_may_post :boolean          default(FALSE), not null
#

class MailingList < ActiveRecord::Base
  
  attr_accessible :name, :description, :publisher, :mail_name, 
                  :additional_sender, :subscribable, :subscribers_may_post
                  
  
  belongs_to :group
  
  has_many :subscriptions, dependent: :destroy
  
  
  validates :mail_name, uniqueness: { allow_blank: true, case_sensitive: false },
                        format: /[a-z0-9\-\_\.]+/
  validate :assert_mail_name_is_not_protected

  
  
  def to_s
    name
  end
  
  private
  
  def assert_mail_name_is_not_protected
    if mail_name? && main = Settings.email.retriever.config.user_name.presence
      if mail_name.downcase == main.split('@', 2).first.downcase
        errors.add(:mail_name, "'#{mail_name}' darf nicht verwendet werden")
      end
    end
  end
end
