class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :inviter_id
      t.integer :invited_id
      t.boolean :accepted

      t.index [ :inviter_id, :invited_id ], unique: true
      t.index [ :invited_id, :inviter_id ], unique: true
    end
  end
end