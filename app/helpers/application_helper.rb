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
      wsdl.document = "http://143.106.73.138:8069/ComponentLogistica/services/LogisticaEntrega" # Nao conseguimos acessar remotamente o wsdl
    end
    resp = client.request :wsdl, :calcula_prazo, {:endereco => endereco, :produtos => produtos}
    resp.to_hash[:calcula_prazo_response][:calcula_prazo_return]
  end
  
  def entrega_produtos (endereco, produtos, remetente, destinatario, id_cliente)
    client = Savon::Client.new do
      wsdl.document = "http://143.106.73.138:8069/ComponentLogistica/services/LogisticaEntrega" # nao conseguimos acessar remotamente
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


end
