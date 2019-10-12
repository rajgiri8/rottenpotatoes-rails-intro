module ApplicationHelper
def class_pick(param)
 if @sort.to_s == param
   return 'hilite'
 else
   return nil
 end
end

end
