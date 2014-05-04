require "in_quotex/engine"

module InQuotex
  mattr_accessor :task_class, :supplier_class, :show_task_path, :return_suppliers, :project_class, :customer_class
  
  def self.task_class
    @@task_class.constantize
  end
  
  def self.supplier_class
    @@supplier_class.constantize
  end
  
  def self.project_class
    @@project_class.constantize
  end
  
  def self.customer_class
    @@customer_class.constantize
  end
end
