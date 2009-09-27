module BudgetsHelper
  def budget_total_class(budget)
    budget.exceeded? ? 'over' : 'under'
  end
end
