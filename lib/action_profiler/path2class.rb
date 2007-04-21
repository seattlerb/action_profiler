class Object

  ##
  # Retrieves the class or module for the path +klassname+ (such as
  # "Test::Unit::TestCase").

  def path2class(klassname)
    klassname.split('::').inject(self) { |k,n| k.const_get n }
  end

end unless Object.respond_to? :path2class

