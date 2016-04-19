require_dependency "in_quotex/application_controller"

module InQuotex
  class QuotesController < ApplicationController
    before_action :require_employee
    before_action :load_parent_record
    
    def index
      @title = t('Quotes')
      @quotes = params[:in_quotex_quotes][:model_ar_r]  #returned by check_access_right
      @quotes = @quotes.where(project_id: @project_id) if @project_id
      @quotes = @quotes.where(task_id: @quote_task.id) if @quote_task
      @quotes = @quotes.where(:task_id => InQuotex.task_class.where(:resource_id => params[:resource_id], :resource_string => params[:resource_string]).
                        select('id')) if params[:resource_id].present? && params[:resource_string].present?  #when event task is linked to quoted item
      @quotes = @quotes.where(:task_id => @quote_task.id) if @quote_task
      @quotes = @quotes.where(:wf_state => params[:wf_state].split(',')) if params[:wf_state]
      @quotes = @quotes.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('quote_index_view', 'in_quotex')
    end
  
    def new
      @title = t('New Quote')
      @quote = InQuotex::Quote.new()
      @qty_unit = find_config_const('piece_unit').split(',').map(&:strip) if find_config_const('piece_unit').present?
      @erb_code = find_config_const('quote_new_view', 'in_quotex')
    end
  
    def create
      @quote = InQuotex::Quote.new(new_params)
      @quote.last_updated_by_id = session[:user_id]
      @quote.entered_by_id = session[:user_id]
      #@quote.task_id = @quote_task.id
      if @quote.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @project_id = params[:quote][:project_id]
        @quote_task = InQuotex.task_class.find_by_id(params[:quote][:task_id]) if params[:quote].present? && params[:quote][:task_id].present?
        @erb_code = find_config_const('quote_new_view', 'in_quotex')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Quote')
      @quote = InQuotex::Quote.find_by_id(params[:id])
      @qty_unit = find_config_const('piece_unit').split(',').map(&:strip) if find_config_const('piece_unit').present?
      @erb_code = find_config_const('quote_edit_view', 'in_quotex')
      if @quote.wf_state.present? && @quote.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    def update
      @quote = InQuotex::Quote.find_by_id(params[:id])
      @quote.last_updated_by_id = session[:user_id]
      if @quote.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @qty_unit = find_config_const('piece_unit').split(',').map(&:strip) if find_config_const('piece_unit').present?
        @erb_code = find_config_const('quote_edit_view', 'in_quotex')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Quote Info')
      @quote = InQuotex::Quote.find_by_id(params[:id])
      @erb_code = find_config_const('quote_show_view', 'in_quotex')
    end
  
    def list_open_process  
      index()
      @quotes = return_open_process(@quotes, find_config_const('quote_wf_final_state_string', 'in_quotex'))  # ModelName_wf_final_state_string
    end
    
    protected
    def load_parent_record
      @project_id = params[:project_id].to_i if params[:project_id].present?
      @project = InQuotex.project_class.find_by_id(@project_id) if @project_id
      @quote_task = InQuotex.task_class.find_by_id(params[:task_id]) if params[:task_id].present?
      @quote_task = InQuotex.task_class.find_by_id(InQuotex::Quote.find_by_id(params[:id]).id) if params[:id].present?
    end
    
    private
    
    def new_params
      params.require(:quote).permit(:good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :wf_state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :void, :entered_by_id, :category_id, :sub_category_id,
                    :project_id, :quote_date, :product_spec, :brand, :mfg_id)
    end
    
    def edit_params
      params.require(:quote).permit(:good_for_day, :last_updated_by_id, :lead_time_day, :other_cost, :payment_term, :qty, :quote_condition, :shipping_cost, :wf_state, 
                    :supplier_contact, :supplier_id, :supplier_quote_num, :task_id, :tax, :unit, :unit_price, :void, :approved, :approved_date, :approved_by_id, :sub_category_id,
                    :quote_date, :category_id, :product_spec, :brand, :mfg_id)
    end
  end
end
