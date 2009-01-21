#
# ActiveFormでもValidatesDateTimeを有効にする
#
class ActiveForm
  def execute_callstack_for_multiparameter_attributes; end
  
  include ValidatesDateTime 
end