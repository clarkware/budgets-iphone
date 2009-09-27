class Budget < ActiveRecord::Base
  
  belongs_to :user
  has_many :expenses, :dependent => :destroy
  
  validates_presence_of :name, :amount
  validates_numericality_of :amount, :greater_than => 0.0

  def spent
    expenses.sum(:amount) || BigDecimal("0.0")
  end
  
  def exceeded?
    spent > amount
  end
  
  def over_amount
    spent - amount
  end
  
  def under_amount
    amount - spent
  end
  
  def to_xml(options={})
    default_serialization_options(options)
    super(options)
  end
  
  def to_json(options={})
    default_serialization_options(options)
    super(options)
  end
  
protected

  def default_serialization_options(options={})
    options[:only] = [:id, :name, :amount, :updated_at, :created_at]
    options[:methods] = [:spent, :over_amount, :under_amount]
  end
  
end
