module InQuotex
  include Authentify::AuthentifyUtility
  require 'workflow'
  class Quote < ActiveRecord::Base

    include Workflow
    workflow_column :wf_state
    
    workflow do
      #self.to_s = 'EngineName::TableName'    ex, 'InQuotex::Quote'
      wf = Authentify::AuthentifyUtility.find_config_const('quote_wf_pdef', 'in_quotex')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
         #quotes is table name
        eval(wf) if wf.present? #&& self.wf_state.present 
      elsif Rails.env.test? #for rspec. loaded before FactoryGirl.
        state :initial_state do
          event :submit, :transitions_to => :reviewing
        end
        state :reviewing do
          event :approve, :transitions_to => :approved
          event :reject, :transitions_to => :rejected
        end
        state :approved
        state :rejected
      end
    end
       
    attr_accessor :void_noupdate, :quoted_by_noupdate, :last_updated_by_noupdate, :task_name, :wf_comment, :id_noupdate
    attr_accessible :good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :wf_state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :wfid, :void, :quoted_by_id,
                    :task_name,
                    :as => :role_new
    attr_accessible :good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :wf_state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :wfid, :void,
                    :void_noupdate, :quoted_by_noupdate, :last_updated_by_noupdate, :task_name, :id_noupdate, :wf_comment,
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
    
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validation_quote_' + self.wf_state, 'in_quotex')
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) if wf.present?
      #else
        #validate code here
        #case wf_state
        #when 'submit'
        #end
      end
    end
    
  end
end
