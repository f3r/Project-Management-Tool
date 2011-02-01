authorization do
  role :admin do
    includes [:manager, :standard, :guest]
    has_permission_on [:categories, :clients, :employees, :expense_categories, :expensereports, :jobs, :projects, :status, :week_hours], :to => [:manage]
  end

  role :partner_1 do
    includes [:partner]
  end

  role :partner_2 do
    includes [:partner]
  end

  role :partner_3 do
    includes [:partner]
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
  
  role :associate_1 do
    includes [:associate]
  end

  role :associate_2 do
    includes [:associate]
  end

  role :associate_3 do
    includes [:associate]
  end

  role :junior_1 do
    includes [:junior]
  end

  role :junior_2 do
    includes [:junior]
  end

  role :junior_3 do
    includes [:junior]
  end

  role :associate do
    includes [:standard, :guest]
  end

  role :partner do
    includes [:admin]
  end

  role :manager do
    includes [:standard, :guest]
    has_permission_on [:projects], :to => [:edit, :update] do
      if_attribute :manager_id => is { user.id }
    end
    has_permission_on [:projects], :to => [:create, :new]
    has_permission_on [:jobs], :to => [:create, :new]
    has_permission_on [:jobs], :to => [:manage] do
      if_permitted_to :manage, :project
    end
    has_permission_on :employees, :to => :view
    has_permission_on :clients, :to => :view do
      if_attribute :employees => contains { user }
    end
  end

  role :junior do
    includes [:standard, :guest]
  end

  role :secretary do
    includes [:guest, :basic]
    has_permission_on [:clients], :to => :manage
  end

  role :standard do
    includes [:basic]
    has_permission_on [:projects], :to => [:view, :get_jobs] do
      if_attribute :involved_employees => contains { user.id }
    end
    has_permission_on [:jobs], :to => [:edit, :update] do
      if_attribute :employee_id => is { user.id }
    end
    has_permission_on [:week_hours], :to => [:index]
    has_permission_on [:expensereports], :to => [:new, :create]
    has_permission_on [:expensereports], :to => [:manage] do
      if_attribute :employee_id => is { user.id }
    end
    has_permission_on [:expensereports], :to => [:manage] do
      if_permitted_to :manage, :job
    end
  end

  role :basic do
    has_permission_on [:employees], :to => [:update, :edit, :show, :change_picture, :change_password] do
      if_attribute :id => is { user.id }
    end
    has_permission_on :intranet, :to => :index
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