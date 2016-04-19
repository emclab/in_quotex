module InQuotex
  include Authentify::AuthentifyUtility
  require 'workflow'
  class Quote < ActiveRecord::Base

    include Workflow
    workflow_column :wf_state
    
    workflow do
      #self.to_s = 'EngineName::TableName'    ex, 'InQuotex::Quote'
      wf = Authentify::AuthentifyUtility.find_config_const('quote_wf_pdef', 'in_quotex')  #executed before loading FactoryGirl. pdef will be nil if pdef defined in FactoryGirl
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
       
    attr_accessor :void_noupdate, :entered_by_noupdate, :last_updated_by_noupdate, :task_name, :wf_comment, :id_noupdate, :project_name, :wf_state_noupdate, :wf_event,
                  :category_name, :mfg_name, :field_changed
       
    belongs_to :task, :class_name => InQuotex.task_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :entered_by, :class_name => 'Authentify::User'
    belongs_to :supplier, :class_name => InQuotex.supplier_class.to_s
    belongs_to :project, :class_name => InQuotex.project_class.to_s
    belongs_to :category, :class_name => InQuotex.category_class.to_s
    belongs_to :sub_category, :class_name => InQuotex.sub_category_class.to_s
    belongs_to :approved_by, :class_name => 'Authentify::User'
    belongs_to :mfg, :class_name => InQuotex.mfg_class.to_s
   
    validates :unit_price, :qty, :supplier_id, :presence => true,
                                     :numericality => {:greater_than => 0}
    validates :product_spec, :unit, :product_name, :presence => true 
    validates :task_id, :numericality => {:greater_than => 0}, :if => 'task_id.present?'
    validates :category_id, :numericality => {:greater_than => 0}, :if => 'category_id.present?'
    validates :sub_category_id, :numericality => {:greater_than => 0}, :if => 'sub_category_id.present?'
    validates :project_id, :numericality => {:greater_than => 0}, :if => 'project_id.present?'
    validates :mfg_id, :numericality => {:greater_than => 0}, :if => 'mfg_id.present?'
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
