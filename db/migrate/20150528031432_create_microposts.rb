class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # user_idとcreated_at両方のカラムを1つの配列に含めることで、
    # Active Recordで両方のキーを同時に使用する複合キーインデックスを作成できます。
    add_index :microposts, [:user_id, :created_at]
  end
end
