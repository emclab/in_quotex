require_dependency "in_quotex/application_controller"

module InQuotex
  class QuotesController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Quotes')
      @quotes = params[:in_quotex_quotes][:model_ar_r]  #returned by check_access_right
      @quotes = @quotes.where(:task_id => @quote_task.id) if @quote_task
      @quotes = @quotes.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('quote_index_view', 'in_quotex_quotes')
    end
  
    def new
      @title = t('New Quote')
      @quote = InQuotex::Quote.new()
      @qty_unit = find_config_const('piece_unit').split(',').map(&:strip)
      @erb_code = find_config_const('quote_new_view', 'in_quotex_quotes')
    end
  
    def create
      @quote = InQuotex::Quote.new(params[:quote], :as => :role_new)
      @quote.last_updated_by_id = session[:user_id]
      @quote.quoted_by_id = session[:user_id]
      @quote.task_id = @quote_task.id
      if @quote.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Quote')
      @quote = InQuotex::Quote.find_by_id(params[:id])
      @erb_code = find_config_const('quote_edit_view', 'in_quotex_quotes')
    end
  
    def update
      @quote = InQuotex::Quote.find_by_id(params[:id])
      @quote.last_updated_by_id = session[:user_id]
      if @quote.update_attributes(params[:quote], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Quote Info')
      @quote = InQuotex::Quote.find_by_id(params[:id])
      @erb_code = find_config_const('quote_show_view', 'in_quotex_quotes')
    end
  
    protected
    def load_parent_record
      @quote_task = InQuotex.task_class.find_by_id(params[:task_id]) if params[:task_id].present?
      @quote_task = InQuotex.task_class.find_by_id(InQuotex.task_class.find_by_id(params[:id]).id) if params[:id].present?
    end
    
  end
end
