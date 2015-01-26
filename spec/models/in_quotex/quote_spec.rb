require 'spec_helper'

module InQuotex
  describe Quote do
    it "should be OK" do
      c = FactoryGirl.build(:in_quotex_quote, :other_cost => nil, :tax => nil, :shipping_cost => nil, :lead_time_day => nil, :good_for_day => nil)
      c.should be_valid
    end
    
    it "should reject nil product_name" do
      c = FactoryGirl.build(:in_quotex_quote, :product_name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil product spec" do
      c = FactoryGirl.build(:in_quotex_quote, :product_spec => nil)
      c.should_not be_valid
    end
    
    it "should reject nil qty" do
      c = FactoryGirl.build(:in_quotex_quote, :qty => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:in_quotex_quote, :qty => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 task_id" do
      c = FactoryGirl.build(:in_quotex_quote, :task_id => 0)
      c.should_not be_valid
    end
    
    it "should allow nil task_id" do
      c = FactoryGirl.build(:in_quotex_quote, :task_id => nil)
      c.should be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:in_quotex_quote, :category_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 sub_category_id" do
      c = FactoryGirl.build(:in_quotex_quote, :sub_category_id => 0)
      c.should_not be_valid
    end
    it "should accept nil project_id" do
      c = FactoryGirl.build(:in_quotex_quote, :project_id => nil)
      c.should be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:in_quotex_quote, :project_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil supplier_id" do
      c = FactoryGirl.build(:in_quotex_quote, :supplier_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil unit" do
      c = FactoryGirl.build(:in_quotex_quote, :unit => nil)
      c.should_not be_valid
    end
     
    it "should accept 0 tax" do
      c = FactoryGirl.build(:in_quotex_quote, :tax => 0)
      c.should be_valid
    end
         
    it "should accept 0 other_cost" do
      c = FactoryGirl.build(:in_quotex_quote, :other_cost => 0)
      c.should be_valid
    end
           
    it "should accept 0 shipping_cost" do
      c = FactoryGirl.build(:in_quotex_quote, :shipping_cost => 0)
      c.should be_valid
    end
    
    it "should accept 0 lead_time_day" do
      c = FactoryGirl.build(:in_quotex_quote, :lead_time_day => 0)
      c.should be_valid
    end
    
    it "should accept 0 good_for_day" do
      c = FactoryGirl.build(:in_quotex_quote, :good_for_day => 0)
      c.should be_valid
    end
  end
end
