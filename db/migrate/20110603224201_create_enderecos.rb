class CreateEnderecos < ActiveRecord::Migration
  def self.up
    create_table :enderecos do |t|
      t.string :cep
      t.string :complemento

      t.timestamps
    end
  end

  def self.down
    drop_table :enderecos
  end
end
