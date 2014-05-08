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
        eval(wf) 
      elsif Rails.env.test? #for rspec. loaded before FactoryGirl.
        state :initial_state do
          event :submit, :transitions_to => :reviewing
        end
        state :reviewing do
          event :accept, :transitions_to => :accepted
          event :reject, :transitions_to => :rejected
        end
        state :accepted
        state :rejected
      end
    end
       
    attr_accessor :void_noupdate, :entered_by_noupdate, :last_updated_by_noupdate, :task_name, :wf_comment, :id_noupdate, :project_name, :wf_state_noupdate, :wf_event
    attr_accessible :good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :wf_state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :void, :entered_by_id,
                    :task_name, :project_id, :quote_date, :product_name, :product_spec,
                    :as => :role_new
    attr_accessible :good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :wf_state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :void, :accepted, :accepted_date,
                    :void_noupdate, :entered_by_noupdate, :last_updated_by_noupdate, :task_name, :id_noupdate, :wf_comment, :project_name, :quote_date,
                    :product_name, :product_spec, :wf_state_noupdate,
                    :as => :role_update
    
    attr_accessor :project_id_s, :start_date_s, :end_date_s, :customer_id_s, :void_s, :accepted_s, :time_frame_s, :supplier_id_s, :entered_by_id_s, :product_name_s

    attr_accessible :project_id_s, :start_date_s, :end_date_s, :customer_id_s, :void_s, :accepted_s, :time_frame_s, :supplier_id_s, :entered_by_id_s, :product_name_s,
                    :as => :role_search_stats
                                   
    belongs_to :task, :class_name => InQuotex.task_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :entered_by, :class_name => 'Authentify::User'
    belongs_to :supplier, :class_name => InQuotex.supplier_class.to_s
    belongs_to :project, :class_name => InQuotex.project_class.to_s
   
    validates :unit_price, :task_id, :qty, :supplier_id, :project_id, :presence => true,
                                     :numericality => {:greater_than => 0}
    validates :product_spec, :unit, :product_name, :presence => true 
    validates :tax, :numericality => {:greater_than_or_equal_to => 0, :if => 'tax.present?'}
    validates :shipping_cost, :numericality => {:greater_than_or_equal_to => 0, :if => 'shipping_cost.present?'}
    validates :other_cost, :numericality => {:greater_than_or_equal_to => 0, :if => 'other_cost.present?'}
    validates :good_for_day, :numericality => {:greater_than_or_equal_to => 0, :if => 'good_for_day.present?'}
    validates :lead_time_day, :numericality => {:greater_than_or_equal_to => 0, :if => 'lead_time_day.present?'}
    validate :dynamic_validate
    
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_quote_' + self.wf_event, 'in_quotex') if self.wf_event.present?
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'in_quotex')
      eval(wf) if wf.present?
    end
    
  end
end
