class ExpensesController < ApplicationController
  
  before_filter :find_budget

  def index
    @expenses = @budget.expenses.all

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @expenses }
      format.json { render :json => @expenses }
    end
  end

  def show
    @expense = @budget.expenses.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @expense }
      format.json { render :json => @expense }
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid expense."
    redirect_to @budget
  end

  def new
    @expense = @budget.expenses.build

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @expense }
      format.json { render :json => @expense }
    end
  end

  def edit
    @expense = @budget.expenses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid expense."
    redirect_to @budget
  end

  def create    
    @expense = @budget.expenses.build(params[:expense])

    respond_to do |format|      
      if @expense.save
        format.html { redirect_to @budget }
        format.xml  { render :xml  => @expense, :status => :created, :location => [@budget, @expense] }
        format.json { render :json => @expense, :status => :created, :location => [@budget, @expense] }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml  => @expense.errors, :status => :unprocessable_entity }
        format.json { render :json => @expense.errors, :status => :unprocessable_entity }

        format.js do
          render :update do |page| 
            flash[:error] = @expense.errors.full_messages.to_sentence
            page.redirect_to @budget 
          end
        end
      end
    end
  end

  def update
    @expense = @budget.expenses.find(params[:id])

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        format.html { redirect_to @budget }
        format.any(:xml, :json) { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @expense.errors, :status => :unprocessable_entity }
        format.json { render :json => @expense.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid expense."
    redirect_to @budget
  end

  def destroy
    @expense = @budget.expenses.find(params[:id])
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to @budget }
      format.any(:xml, :json) { head :ok }
      format.js   { render 'create'}  
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid expense."
    redirect_to @budget
  end
  
protected

  def find_budget
    @budget = current_user.budgets.find(params[:budget_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid budget."
    redirect_to @budget
  end

end
