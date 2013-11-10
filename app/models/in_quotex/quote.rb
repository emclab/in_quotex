module InQuotex
  class Quote < ActiveRecord::Base
    attr_accessor :void_noupdate, :quoted_by_noupdate, :last_updated_by_noupdate, :task_name
    attr_accessible :comment, :good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :wfid, :void, :quoted_by_id,
                    :task_name,
                    :as => :role_new
    attr_accessible :comment, :good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :wfid, :void,
                    :void_noupdate, :quoted_by_noupdate, :last_updated_by_noupdate, :task_name,
                    :as => :role_update
                    
    belongs_to :task, :class_name => InQuotex.task_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :quoted_by, :class_name => 'Authentify::User'
    belongs_to :supplier, :class_name => InQuotex.supplier_class.to_s
   
    validates :unit_price, :task_id, :qty, :supplier_id, :presence => true,
                                     :numericality => {:greater_than => 0}
                                
    validates :tax, :numericality => {:greater_than_or_equal_to => 0, :if => 'tax.present?'}
    validates :shipping_cost, :numericality => {:greater_than_or_equal_to => 0, :if => 'shipping_cost.present?'}
    validates :other_cost, :numericality => {:greater_than_or_equal_to => 0, :if => 'other_cost.present?'}
    validates :good_for_day, :numericality => {:greater_than_or_equal_to => 0, :if => 'good_for_day.present?'}
    validates :lead_time_day, :numericality => {:greater_than_or_equal_to => 0, :if => 'lead_time_day.present?'}
    validates_presence_of :unit
  end
end
