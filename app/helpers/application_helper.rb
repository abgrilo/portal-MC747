module ApplicationHelper
  require 'savon'
  
  def edilson_method (cpf, token)
    client = Savon::Client.new do
      wsdl.document = "http://www.supercontrole.com/747/wsConsultaCliente.asmx?WSDL"
    end
    resp = client.request :wsdl, :consulta_cliente, {:token => token, :cpf => cpf}
    resp.to_hash[:consulta_cliente_response][:consulta_cliente_result]
  end

end
