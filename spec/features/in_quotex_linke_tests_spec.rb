require 'rails_helper'

RSpec.describe "LinkeTests", type: :request do
  describe "GET /in_quotex_linke_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      wf = "def submit
          wf_common_action('initial_state', 'reviewing', 'submit')
        end   
        def accept
          wf_common_action('reviewing', 'accepted', 'accept')
        end    
        def reject
          wf_common_action('reviewing', 'rejected', 'reject')
        end"
      FactoryGirl.create(:engine_config, :engine_name => 'in_quotex', :engine_version => nil, :argument_name => 'quote_wf_action_def', :argument_value => wf)
      FactoryGirl.create(:engine_config, :engine_name => 'in_quotex', :engine_version => nil, :argument_name => 'quote_wf_final_state_string', :argument_value => 'rejected, approved')
      FactoryGirl.create(:engine_config, :engine_name => 'in_quotex', :engine_version => nil, :argument_name => 'quote_submit_inline', 
                         :argument_value => "<%= f.input :tax, :label => t('Tax') %>")
      FactoryGirl.create(:engine_config, :engine_name => 'in_quotex', :engine_version => nil, :argument_name => 'validate_quote_submit', 
                         :argument_value => "errors.add(:tax, I18n.t('Must be numeric')) if !(tax.is_a? Numeric) or (tax.present? && (tax.is_a? Numeric) && tax <= 0)
                                            ")
      FactoryGirl.create(:engine_config, :engine_name => 'in_quotex', :engine_version => nil, :argument_name => 'quote_accept_inline', 
                         :argument_value => "<%= f.input :approved_date, :label => t('Accept Date'), :as => :string %>
                                             <%= f.input :approved, :as => :hidden, :input_html => {:value => true} %>
                                           ")
      FactoryGirl.create(:engine_config, :engine_name => 'in_quotex', :engine_version => nil, :argument_name => 'validate_quote_accept', 
                         :argument_value => "errors.add(:approved_date, I18n.t('Not be blank')) if approved_date.blank?
                                           ")
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      engine_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "t('set'), t('piece')")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])

      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "InQuotex::Quote.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "InQuotex::Quote.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "record.entered_by_id == session[:user_id]")
      ua1 = FactoryGirl.create(:user_access, :action => 'event_action', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'submit', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'accept', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'reject', :resource => 'in_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_in_quote', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")

      @q_task = FactoryGirl.create(:event_taskx_event_task)
      @q_task1 = FactoryGirl.create(:event_taskx_event_task, :name => 'a new name')
      @supplier = FactoryGirl.create(:supplierx_supplier)
      @quote = FactoryGirl.create(:in_quotex_quote, :task_id => @q_task1.id, :supplier_id => @supplier.id, :unit => 'set')
      log = FactoryGirl.create(:commonx_log, :resource_id => @quote.id, :resource_name => 'in_quotex_quotes')
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    it "works! (now write some real specs)" do
      
      visit in_quotex.quotes_path
      save_and_open_page
      expect(page).to have_content('Quotes')
      click_link 'Edit'
      expect(page).to have_content('Update Quote')
      #save_and_open_page
      fill_in 'quote_product_name', :with => 'a new name'
      fill_in 'quote_product_spec', :with => 'tree1234'
      fill_in 'quote_unit_price', :with => 100
      select('piece', :from => 'quote_unit')
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit in_quotex.quotes_path
      click_link 'Edit'
      fill_in 'quote_product_name', :with => 'a new name'
      fill_in 'quote_product_spec', :with => 'tree1234'
      fill_in 'quote_unit_price', :with => 0
      click_button 'Save'
      #save_and_open_page
      
      visit in_quotex.quotes_path
      click_link @quote.id.to_s
      #save_and_open_page
      expect(page).to have_content('Quote Info')
      #expect(page).to have_content('this line tests workflow')
      click_link 'New Log'
      expect(page).to have_content('Log')
      
      visit in_quotex.new_quote_path(:task_id => @q_task.id, :project_id => 1)
      expect(page).to have_content('New Quote')
      fill_in 'quote_product_name', :with => 'a new name'
      fill_in 'quote_product_spec', :with => 'tree1234'
      fill_in 'quote_unit_price', :with => 100
      fill_in 'quote_qty', :with => 200
      select('piece', :from => 'quote_unit')
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit in_quotex.new_quote_path(:task_id => @q_task.id, :project_id => 1)
      expect(page).to have_content('New Quote')
      fill_in 'quote_product_name', :with => ''
      fill_in 'quote_product_spec', :with => 'tree1234'
      fill_in 'quote_unit_price', :with => 0
      fill_in 'quote_qty', :with => 200
      select('piece', :from => 'quote_unit')
      click_button 'Save'
      #save_and_open_page
    end
    
    it "should work for workflow" do
      visit in_quotex.quotes_path
      #save_and_open_page
      click_link 'Submit'
      #save_and_open_page
      fill_in 'quote_wf_comment', :with => 'this line tests workflow'
      fill_in 'quote_tax', :with => '10.00'
      save_and_open_page
      click_button 'Save'
      #
      visit in_quotex.quotes_path
      click_link @quote.id.to_s
      save_and_open_page
      expect(page).to have_content('Quote Info')
      expect(page).to have_content('this line tests workflow')
      #accept quote

      visit in_quotex.quotes_path
      #save_and_open_page
      click_link 'Accept Quote'
      #save_and_open_page
      fill_in 'quote_wf_comment', :with => 'this quote was accepted'
      fill_in 'quote_approved_date', :with => Date.today - 2.days
      click_button 'Save'
      visit in_quotex.quotes_path
      click_link @quote.id.to_s
      #save_and_open_page
      expect(page).to have_content('this quote was accepted')
      expect(page).to have_content((Date.today - 2.days).strftime("%Y/%m/%d"))
      
      visit in_quotex.quotes_path
      #save_and_open_page
      click_link 'Open Process'
      expect(page).to have_content('Quotes')
            
    end
    
    it "should handle data error in wf" do
      visit in_quotex.quotes_path
      #save_and_open_page
      #0
      click_link 'Submit'
      fill_in 'quote_wf_comment', :with => 'this line tests data failure'
      fill_in 'quote_tax', :with => 0
      #save_and_open_page
      click_button 'Save'
      #nil
      visit in_quotex.quotes_path
      #save_and_open_page
      click_link 'Submit'
      fill_in 'quote_wf_comment', :with => 'this line tests data failure'
      fill_in 'quote_tax', :with => nil
      #save_and_open_page
      click_button 'Save'
      #non numeric
      visit in_quotex.quotes_path
      #save_and_open_page
      click_link 'Submit'
      fill_in 'quote_wf_comment', :with => 'this line tests data failure'
      fill_in 'quote_tax', :with => 'nil'
      #save_and_open_page
      click_button 'Save'
      
      visit in_quotex.quotes_path
      click_link @quote.id.to_s
      #save_and_open_page
      expect(page).to have_content('Quote Info')
      expect(page).not_to have_content('this line tests data failure')
    end
    
  end
end
