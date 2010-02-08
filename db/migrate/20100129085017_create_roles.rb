class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
    end
    
    [:admin, :customer, :employee].each do |role|
      Role.create(:name => role.to_s)
    end
    
    if user = User.first
      user.roles << Role.admin
    end
  end

  def self.down
    drop_table :roles
  end
end
