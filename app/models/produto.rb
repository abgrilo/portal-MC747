class Produto < ActiveRecord::Base

# produtos / grupo 02
  @@produto_base_url = "http://rachacuca.org:8000/stock/"
  @@portal_base_id = 1
  @@products_search_limit = 10


  def self.soa_find_all
    products = []
    #reshi = product_search(@@portal_base_id)
    reshi = [1, 2, 3]
    reshi.each_with_index do |id,index|
      if(index > @@products_search_limit)
        break
      end
      phash = product_info(@@portal_base_id,id)
      products << Produto.extract_produto(id,phash)
    end
    products
  end

  def self.soa_find_by_id(pid)
    phash = product_info(@@portal_base_id,pid)
    
    Produto.extract_produto(pid,phash)
  end

  def self.soa_find_availability_by_id(pid,pp)
    phash = product_availability(@@portal_base_id, pid)
    ##testar isso
    q = phash['available'].to_i - phash['reserved'].to_i
    unless pp == nil
      pp.quantidade = q
    end
    return q
  end

  def self.soa_reserve_by_id(pid,quantity)
    product_reserve(@@portal_base_id, pid.to_i,quantity.to_i)
  end

  private
    def self.extract_produto(id,phash)
      p = Produto.new
      p.id = id.to_i
      p.nome = phash["title"]
      p.descricao = phash["description"]
      p.preco = phash["price"].to_f
      return p
    end
    

    def self.product_search(portal_id)
      client = HTTPClient.new
      # ssh -L 22990:143.106.73.138:8069 ra082704@ssh.students.ic.unicamp.br #
      # response = client.get(' http://localhost:22990/servlets/servlet/debitoonline?conta_do_portal=123456&agencia_portal=123&conta_cliente=123&agencia_do_cliente=&senha_do_cliente=&valor_da_compra=250,35&id_da_compra=112233) #
      response = client.get(@@produto_base_url+"search/"+portal_id.to_s+"/")
      resposta = ActiveSupport::JSON::decode response.body
      (resposta.to_hash)["result"]
    end

    def self.product_info(portal_id,product_id)
      client = HTTPClient.new
      # ssh -L 22990:143.106.73.138:8069 ra082704@ssh.students.ic.unicamp.br #
      # response = client.get(' http://localhost:22990/servlets/servlet/debitoonline?conta_do_portal=123456&agencia_portal=123&conta_cliente=123&agencia_do_cliente=&senha_do_cliente=&valor_da_compra=250,35&id_da_compra=112233) #
      response = client.get(@@produto_base_url+"info/"+portal_id.to_s+"/"+product_id.to_s+"/")
      resposta = ActiveSupport::JSON::decode response.body
      resposta.to_hash
    end

    def self.product_availability(portal_id,product_id)
      client = HTTPClient.new
      # ssh -L 22990:143.106.73.138:8069 ra082704@ssh.students.ic.unicamp.br #
      # response = client.get(' http://localhost:22990/servlets/servlet/debitoonline?conta_do_portal=123456&agencia_portal=123&conta_cliente=123&agencia_do_cliente=&senha_do_cliente=&valor_da_compra=250,35&id_da_compra=112233) #
      response = client.get(@@produto_base_url+"availability/"+portal_id.to_s+"/"+product_id.to_s+"/")
      resposta = ActiveSupport::JSON::decode response.body
      resposta.to_hash
    end

    def self.product_reserve(portal_id,product_id,quantity)
      client = HTTPClient.new
      response = client.get(@@produto_base_url+"reserve/"+portal_id.to_s+"/"+product_id.to_s+"/"+quantity.to_s+"/")
      resposta = ActiveSupport::JSON::decode response.body
      resposta.to_hash unless resposta.blank?
    end

end