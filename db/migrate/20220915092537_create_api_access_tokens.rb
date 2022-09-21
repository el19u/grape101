class CreateApiAccessTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :api_access_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :key

      t.timestamps
    end
  end
end
