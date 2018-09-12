class AddSignatureToUsers < ActiveRecord::Migration
  def change
    add_column  :users,	:academic_title,	:string
    add_column  :users,	:position,			:string
  end
end
