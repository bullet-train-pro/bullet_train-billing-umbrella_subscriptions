class CreateBillingUmbrellaSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_umbrella_subscriptions do |t|
      t.references :team, null: false, foreign_key: true
      t.references :covering_team, null: false, foreign_key: {to_table: :teams}

      t.timestamps
    end
  end
end
