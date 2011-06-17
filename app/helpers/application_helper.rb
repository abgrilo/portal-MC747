module ApplicationHelper
  require 'savon'
  require 'httpclient'
  
  # ---- EDILSON ---- #
  
  def edilson_method (cpf, token)
    client = Savon::Client.new do
      wsdl.document = "http://www.supercontrole.com/747/wsConsultaCliente.asmx?WSDL"
    end
    resp = client.request :wsdl, :consulta_cliente, {:token => token, :cpf => cpf}
    resp.to_hash[:consulta_cliente_response][:consulta_cliente_result]
  end
  
  # ---- Grupo 07 ---- #
  
  def calcula_prazo (endereco, produtos)
    client = Savon::Client.new do
      wsdl.document = "http://localhost:8069/ComponentLogistica/services/LogisticaEntrega?WSDL" # Nao conseguimos acessar remotamente o wsdl
    end
    resp = client.request :wsdl, :calcula_prazo do
      soap.body =  {:endereco => endereco, :produtos => produtos}
    end
    resp.to_hash[:calcula_prazo_response][:calcula_prazo_return]
  end
  
  def entrega_produtos (endereco, produtos, remetente, destinatario, id_cliente)
    client = Savon::Client.new do
      wsdl.document = "http://143.106.73.138:8069/ComponentLogistica/services/LogisticaEntrega?WSDL" # nao conseguimos acessar remotamente
    end
    resp = client.request :wsdl, :entrega_produtos, {:endereco => endereco, :produtos => produtos, :remetente => remetente, 
      :destinatario => destinatario, :id_cliente => id_cliente}
    resp.to_hash[:entrega_produtos_response][:entrega_produtos_return]
  end
  
  def verifica_situacao_entrega (protocolo)
    client = Savon::Client.new do
      wsdl.document = "http://143.106.73.138:8069/ComponentLogistica/services/LogisticaEntrega" # nao conseguimos acessar remotamente
    end
    resp = client.request :wsdl, :verifica_situacao_entrega, {:protocolo => protocolo}
    resp.to_hash[:verifica_situacao_entrega_response][:verifica_situacao_entrega_return]
  end

  def obter_lista_protocolos (id_cliente)
    client = Savon::Client.new do
      wsdl.document = "http://143.106.73.138:8069/ComponentLogistica/services/LogisticaEntrega" # nao conseguimos acessar remotamente
    end
    resp.request :wsdl, :obter_list_de_protocolos, {:id_cliente => id_cliente}
    resp.to_hash[:obter_list_de_protocolos_response][:obter_list_de_protocolos_return]
  end
  
  # ----GRUPO 09  ---- #
  
  def autentica_usuario (usuario, senha)
  
    client = HTTPClient.new
    response = client.get('http://server.felipegasparini.com/autenticacao/index.php?r=autenticacao/login&password='+senha+'&email='+usuario)
    resposta = ActiveSupport::JSON::decode response.body
    resposta_hash = resposta.to_hash
    if resposta_hash['erro'] == "E-mail ou senha incorretos."
      return false
    else
      return true
    end
    
  end
  
  #  ----- GRUPO 04 ----- #
  
  # WARNING ! ! ! ! ! ! ! !
  # Devido a uma cagada que fizeram no web service, o tunelamento tem que ser 8085->8085
  # ssh -L 8085:staff01.lab.ic.unicamp.br:8085 ra070018@ssh.students.ic.unicamp.br
  def valida_cartao_de_credito(value, card_number, security_code, owner_name, expiration_date, operator_id)
 
    # Exemplo:
    # :value => "0000.00", :cardNumber => "1111111111111111", :securityCode => "111", :ownerName => "Aremildo Valdinelson da Silva", :expirationDate => "012014", :operatorID => "1"
    
    card = Savon::Client.new do
      wsdl.document = "http://localhost:8085/axis2/services/CreditCardService/CreditCardManager?"
    end

    resp = card.request :wsdl, :credit_card_manager, {
      :value => value, 
      :cardNumber => card_number, 
      :securityCode => security_code, 
      :ownerName => owner_name, 
      :expirationDate => expiration_date, 
      :operatorID => operator_id }
    return resp.to_hash[:credit_card_manager_response][:return]
  end
  
  
  # TODO: O grupo nao especificou os tipos de retorno nem nada, tenso.
  def test_valida_cartao_de_credito()
    a = valida_cartao_de_credito(0.00, "1111111111111111", "111", "Aremildo Valdinelson da Silva", 012014, 1)
    b = valida_cartao_de_credito("0000.00", "2222222222222221", "221", "Lineide Francislleyne Coelho", "012014", "2")
    c = valida_cartao_de_credito("0150.00", "4444444444444442", "442", "Queliquí Josylleyde Pereira", "012014", "2")
    d = valida_cartao_de_credito("0000.00", "1111111111111111", "111", "Bryanne Ethelvina Lima", "012014", "1")
    e = valida_cartao_de_credito("0", "666", "666", "TESTE PRA DAR ERRADO", "666", "6")
    puts a
    puts b
    puts c
    puts d
    puts e
  end
  
  # ---- ---- #
  

## pra parsear valores do grupo 2
## uso: migue_to_hash "Valor1:Valor2:Valor3", [:chave1, :chave2, :chave3]
  def migue_to_hash(strs, keys)
    vals = strs.split(':')
    hashi = {}
    vals.each do |o,i|
      hashi[keys[i]] = o
    end
    return hashi
  end
end
