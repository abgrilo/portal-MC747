class CreateCompras < ActiveRecord::Migration
  def self.up
    create_table :compras do |t|
      t.string :numero_cartao
      t.string :codigo_seguranca
      t.string :nome_titular
      t.string :data_validade
      t.integer :bandeira_id

      t.timestamps
    end
  end

  def self.down
    drop_table :compras
  end
end
