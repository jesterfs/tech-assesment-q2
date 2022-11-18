class TreeNode
  attr_accessor :children, :name, :data_type, :text, :id, :class

  def initialize(n, d, t, i, c)
    @name = n
    @data_type = d
    @text = t
    @id = i
    @class = c
    @children = []
  end
end