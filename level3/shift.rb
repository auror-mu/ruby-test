class Shift
  attr_reader :user_id, :start_date

  def initialize(user_id, start_date)
    @user_id = user_id
    @start_date = Date.parse(start_date) #chaine de char
  end

  def is_weekend?
   start_date.saturday? || start_date.sunday?
  end

end
