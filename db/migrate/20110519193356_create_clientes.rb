class CreateClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      t.string :nome
      t.string :cpf
      t.string :rg
      t.integer :cep
      t.string :complemento
      t.string :data_nascimento
      t.integer :ddd
      t.integer :telefone
      t.integer :ddd_celular
      t.integer :celular
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :clientes
  end
end
