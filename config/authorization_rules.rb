authorization do
  role :admin do
    includes [:manager, :standard, :guest]
    has_permission_on [:categories, :clients, :employees, :expense_categories, :expensereports, :jobs, :projects, :status, :week_hours], :to => [:manage]
  end

  role :manager_1 do
    includes [:manager]
  end

  role :manager_2 do
    includes [:manager]
  end

  role :manager_3 do
    includes [:manager]
  end
  
  role :junior_1 do
    includes [:junior]
  end

  role :manager do
    includes [:standard, :guest]
    has_permission_on [:projects], :to => [:view, :create, :new]
    has_permission_on [:projects], :to => [:manage] do
      if_attribute :manager_id => is { user.id }
    end
    has_permission_on [:jobs], :to => [:create, :new]
    has_permission_on [:jobs], :to => [:manage] do
      if_permitted_to :manage, :project
    end
  end

  role :junior do
    includes [:standard, :guest]
  end

  role :standard do
    has_permission_on [:employees], :to => [:update, :edit, :show, :change_picture, :change_password] do
      if_attribute :id => is { user.id }
    end
    has_permission_on [:projects], :to => [:view] do
      if_attribute :involved_employees => contains { user.id }
    end
    has_permission_on [:jobs], :to => [:edit, :update] do
      if_attribute :employee_id => is { user.id }
    end
  end


  role :guest do
  end

end

privileges do
  privilege :manage do
    includes :new, :create, :edit, :update, :destroy, :index, :show
  end
end

privileges do
  privilege :view do
    includes :index, :show
  end
end