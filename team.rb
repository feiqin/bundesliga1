class Team
  attr_accessor :name, :id, :rank

  def initialize(name, id, rank)
    @name=name
    @id=id
    @rank=rank
  end
 
  def name
    @name
  end

end