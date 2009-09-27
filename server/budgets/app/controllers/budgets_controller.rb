class BudgetsController < ApplicationController

  def index
    @budgets = current_user.budgets.all

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @budgets }
      format.json { render :json => @budgets }
    end
  end

  def show
    @budget = current_user.budgets.find(params[:id])
    @expense = Expense.new

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @budget }
      format.json { render :json => @budget }
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid budget."
    redirect_to root_url
  end

  def new
    @budget = current_user.budgets.build

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @budget }
      format.json { render :json => @budget }
    end
  end

  def edit
    @budget = current_user.budgets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid budget."
    redirect_to root_url
  end

  def create
    @budget = current_user.budgets.build(params[:budget])

    respond_to do |format|
      if @budget.save
        format.html { redirect_to @budget }
        format.xml  { render :xml  => @budget, :status => :created, :location => @budget }
        format.json { render :json => @budget, :status => :created, :location => @budget }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml  => @budget.errors, :status => :unprocessable_entity }
        format.json { render :json => @budget.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @budget = current_user.budgets.find(params[:id])

    respond_to do |format|
      if @budget.update_attributes(params[:budget])
        format.html { redirect_to @budget }
        format.any(:xml, :json)  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @budget.errors, :status => :unprocessable_entity }
        format.json { render :json => @budget.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid budget."
    redirect_to root_url
  end

  def destroy
    @budget = current_user.budgets.find(params[:id])
    @budget.destroy

    respond_to do |format|
      format.html { redirect_to(budgets_url) }
      format.any(:xml, :json)  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid budget."
    redirect_to root_url
  end
  
end
