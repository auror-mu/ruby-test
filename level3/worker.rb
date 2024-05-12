class Worker
  attr_reader :id, :status
  attr_accessor :shifts

  def initialize(id, status)
    @id = id
    @status = status
  end

  def intern?
    @status == 'interne'
  end

end
