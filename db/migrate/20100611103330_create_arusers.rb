class CreateArusers < ActiveRecord::Migration
  def self.up
    create_table :arusers do |t|
      t.string :login
    end
    
    create_table :arfollows do |t|
      t.integer :followed_id
      t.integer :follower_id
    end

    add_index :arfollows, :followed_id
    #add_index :arfollows, :followed_id, :follower_id
  end

  def self.down
    drop_table :arusers
    drop_table :arfollows
  end
end
