require "in_quotex/engine"

module InQuotex
  mattr_accessor :task_class, :supplier_class, :project_class, :customer_class, :category_class, :sub_category_class, :mfg_class
  
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
  
  def self.category_class
    @@category_class.constantize
  end
  
  def self.sub_category_class
    @@sub_category_class
  end
  
  def self.mfg_class
    @@mfg_class.constantize
  end
end
